view: cu_sub_per_day {
 derived_table: {
    sql: with  min_dates AS(
  SELECT
  DISTINCT
  user_sso_guid
  , first_value(local_time) over (partition by user_sso_guid order by LOCAL_TIME)  as first_local_time
  , first_value(subscription_state) over (partition by user_sso_guid order by LOCAL_TIME) AS first_subscription_state
  FROM
  prod.UNLIMITED.RAW_SUBSCRIPTION_EVENt
  WHERE
  USER_ENVIRONMENT like 'production'
  AND PLATFORM_ENVIRONMENT like 'production'
  AND contract_id <> 'stuff'
  AND contract_id <> 'Testuser'

  )

  , max_dates AS(
  SELECT
  DISTINCT
  user_sso_guid
  , last_value(local_time) over (partition by user_sso_guid order by LOCAL_TIME)  as last_local_time
  , last_value(subscription_state) over (partition by user_sso_guid order by LOCAL_TIME) AS last_subscription_state
  FROM
  prod.UNLIMITED.RAW_SUBSCRIPTION_EVENt
  WHERE
  USER_ENVIRONMENT like 'production'
  AND PLATFORM_ENVIRONMENT like 'production'
  AND contract_id <> 'stuff'
  AND contract_id <> 'Testuser'
  )

  , base as(
  SELECT
  distinct
  f.user_sso_guid AS user
  , f.first_subscription_state AS first_subscription_state
  , f.first_local_time AS first_local_time
  , l.last_subscription_state AS last_subscription_state
  , l.last_local_time AS last_local_time
  , s.SUBSCRIPTION_START as _start
  , s.SUBSCRIPTION_END as _end
  FROM
  min_dates f
  INNER JOIN max_dates l ON f.user_sso_guid = l.user_sso_guid
  inner join prod.UNLIMITED.RAW_SUBSCRIPTION_EVENt  s on l.user_sso_guid = s.user_sso_guid and s.local_time = l.last_local_time
  LEFT OUTER JOIN prod.unlimited.EXCLUDED_USERS exc ON exc.user_sso_guid = f.user_sso_guid
  WHERE exc.user_sso_guid is null
  and last_subscription_state <> 'cancelled'
  and last_subscription_state <> 'banned'
  and first_subscription_state <> 'cancelled'
  and first_subscription_state <> 'banned'
  )

  ----------------------------------------------------------------------------------------

  , days as (
  SELECT DATEVALUE as day FROM DW_DEVMATH.DIM_DATE WHERE DATEKEY BETWEEN (TO_CHAR(date_part(year,current_date())) || '0101') AND (TO_CHAR(date_part(year,current_date())) || TO_CHAR(RIGHT('00' || DATE_PART(month,current_date()),2)) || TO_CHAR(RIGHT('00' || DATE_PART(day,current_date()),2))) ORDER BY DATEVALUE
  )

  , res as (
  select
  distinct
  user
  , to_date(first_local_time)
  , first_subscription_state
  , last_subscription_state
  , to_date(_start)
  , to_date(_end)
  , current_date()
  , case when first_subscription_state like 'trial_access' and  last_subscription_state like 'trial_access' and  to_date(_start) <= current_date() and to_date(_end) >= current_date() then 'Trial access users'
  when first_subscription_state like 'full_access' and  last_subscription_state like 'full_access'  and  to_date(_start) <= current_date() and to_date(_end) >= current_date() then 'Full Access - Direct Purchase'
  when first_subscription_state like 'trial_access' and last_subscription_state like 'full_access' and  to_date(_start) <= current_date() and to_date(_end) >= current_date() then 'Full Access - Upgraded'
  when to_date(_end) < current_date() then 'z_Expeired' end as active_status
  , case when user in (select user_guid from prod.STG_CLTS.ACTIVATIONS_OLR_V where actv_isbn in ('9780357700006','9780357700013','9780357700020')) and (active_status like 'Full Access - Direct Purchase' or active_status like 'Full Access - Upgraded' )then 'PAC'
  else case when (active_status like 'Full Access - Direct Purchase' or active_status like 'Full Access - Upgraded' ) then 'Commerce' else 'Unpaid' end end as paid_status
  from base
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
    sql: ${user} ;;
  }

dimension: user {
  type: string
  sql: ${TABLE}."USER" ;;
}

dimension: to_datefirst_local_time {
  type: date
  sql: ${TABLE}."TO_DATE(FIRST_LOCAL_TIME)" ;;
}

dimension: first_subscription_state {
  type: string
  sql: ${TABLE}."FIRST_SUBSCRIPTION_STATE" ;;
}

dimension: last_subscription_state {
  type: string
  sql: ${TABLE}."LAST_SUBSCRIPTION_STATE" ;;
}

dimension: to_date_start {
  type: date
  sql: ${TABLE}."TO_DATE(_START)" ;;
}

dimension: to_date_end {
  type: date
  sql: ${TABLE}."TO_DATE(_END)" ;;
}

dimension: current_date {
  type: date
  sql: ${TABLE}."CURRENT_DATE()" ;;
}

dimension: active_status {
  type: string
  sql: ${TABLE}."ACTIVE_STATUS" ;;
}

dimension: paid_status {
  type: string
  sql: ${TABLE}."PAID_STATUS" ;;
}

set: detail {
  fields: [
    user,
    to_datefirst_local_time,
    first_subscription_state,
    last_subscription_state,
    to_date_start,
    to_date_end,
    current_date,
    active_status,
    paid_status
  ]
}
}
