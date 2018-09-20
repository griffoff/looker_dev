view: cu_sub_per_day_3 {
  derived_table: {
    sql: with
        min_dates AS(
        SELECT
        DISTINCT
        user_sso_guid
        , first_value(local_time) over (partition by user_sso_guid order by LOCAL_TIME)  as first_local_time
        , first_value(subscription_state) over (partition by user_sso_guid order by LOCAL_TIME) AS first_subscription_state
        FROM
        prod.UNLIMITED.RAW_SUBSCRIPTION_EVENt
        WHERE  USER_ENVIRONMENT like 'production'
        AND PLATFORM_ENVIRONMENT like 'production'
        AND contract_id <> 'stuff'
        AND contract_id <> 'Testuser'

        )

        , min_full AS(
        SELECT
        DISTINCT
        user_sso_guid
        , first_value(local_time) over (partition by user_sso_guid order by LOCAL_TIME)  as min_full_time
        , first_value(subscription_state) over (partition by user_sso_guid order by LOCAL_TIME) AS min_full_state
        FROM
        prod.UNLIMITED.RAW_SUBSCRIPTION_EVENt
        WHERE USER_ENVIRONMENT like 'production'
        AND PLATFORM_ENVIRONMENT like 'production'
        AND contract_id <> 'stuff'
        AND contract_id <> 'Testuser'
        and subscription_state like 'full_access'
        )

        , res as (
        select distinct
        t.user_sso_guid
        , t.first_local_time as trial_start
        , f.min_full_time as full_start
        , datediff(day, trial_start, full_start) as day
        from min_dates t inner join min_full f on t.user_sso_guid = f.user_sso_guid
        LEFT OUTER JOIN prod.unlimited.VW_USER_BLACKLIST exc ON exc.user_sso_guid = f.user_sso_guid
        WHERE exc.user_sso_guid is null
        )


        select * from res
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: Number_of_users {
    drill_fields: [detail*]
    type: count_distinct
    sql: ${user_sso_guid} ;;
  }

  dimension: user_sso_guid {
    type: string
    sql: ${TABLE}."USER_SSO_GUID" ;;
  }

  dimension_group: trial_start {
    type: time
    sql: ${TABLE}."TRIAL_START" ;;
  }

  dimension_group: full_start {
    type: time
    sql: ${TABLE}."FULL_START" ;;
  }

  dimension: day {
    type: number
    sql: ${TABLE}."DAY" ;;
  }

  set: detail {
    fields: [user_sso_guid, trial_start_time, full_start_time, day]
  }
}
