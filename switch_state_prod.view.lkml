view: switch_state_prod {
 derived_table: {
  sql: with trial as (
      select user_sso_guid as t_s_user_sso_guid
      , _hash as t_hash
      , local_time as t_subscription_local_time
      , subscription_state as t_subscription_state
      , subscription_end as t_subscription_end
      , subscription_start as t_subscription_start
      from prod.unlimited.RAW_SUBSCRIPTION_EVENT
      where t_subscription_state like '%trial%'
      )

      , _full as (
      select user_sso_guid as f_s_user_sso_guid
      , _hash as f_hash
      , local_time as f_subscription_local_time
      , subscription_state as f_subscription_state
      , subscription_end as f_subscription_end
      , subscription_start as f_subscription_start
      from prod.unlimited.RAW_SUBSCRIPTION_EVENT
      where f_subscription_state like '%full%'
      )

      , t_f as(
      select 'trial to full' as idd
      , trial.*
      , _full.*
      from trial, _full
      where t_s_user_sso_guid = f_s_user_sso_guid
      --and f_subscription_start >= t_subscription_end
      and datediff(dd, f_subscription_start, t_subscription_end) < 1
      )

      , only_trial as (
      select 'only trial' as idd
      ,trial.*
      , t_s_user_sso_guid as f_s_user_sso_guid
      , t_hash as f_hash
      , t_subscription_local_time as f_subscription_local_time
      , t_subscription_state as f_subscription_state
      , t_subscription_end as f_subscription_end
      , t_subscription_start as f_subscription_start
      from trial
      where trial.t_s_user_sso_guid not in (select f_s_user_sso_guid from _full)
      )

      , only_full as (
      select 'only full' as idd
      ,null as t_s_user_sso_guid
      , null as t_hash
      , null as t_subscription_local_time
      , null as t_subscription_state
      , null as t_subscription_end
      , null as t_subscription_start
      , _full.*
      from _full
      where _full.f_s_user_sso_guid not in (select t_s_user_sso_guid from trial)
      )
      ,

      res as (
      select * from t_f
      union
      select * from only_trial
      union
      select * from only_full
      )

select * from res
 ;;
}

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_m {
    type: count_distinct
    sql: ${f_hash} ;;
  }

  dimension: idd {
    type: string
    sql: ${TABLE}."IDD" ;;
  }

  dimension: t_s_user_sso_guid {
    type: string
    sql: ${TABLE}."T_S_USER_SSO_GUID" ;;
  }

  dimension: t_hash {
    type: string
    sql: ${TABLE}."T_HASH" ;;
  }

  dimension_group: t_subscription_local_time {
    type: time
    sql: ${TABLE}."T_SUBSCRIPTION_LOCAL_TIME" ;;
  }

  dimension: t_subscription_state {
    type: string
    sql: ${TABLE}."T_SUBSCRIPTION_STATE" ;;
  }

  dimension_group: t_subscription_end {
    type: time
    sql: ${TABLE}."T_SUBSCRIPTION_END" ;;
  }

  dimension_group: t_subscription_start {
    type: time
    sql: ${TABLE}."T_SUBSCRIPTION_START" ;;
  }

  dimension: f_s_user_sso_guid {
    type: string
    sql: ${TABLE}."F_S_USER_SSO_GUID" ;;
  }

  dimension: f_hash {
    type: string
    sql: ${TABLE}."F_HASH" ;;
  }

  dimension_group: f_subscription_local_time {
    type: time
    sql: ${TABLE}."F_SUBSCRIPTION_LOCAL_TIME" ;;
  }

  dimension: f_subscription_state {
    type: string
    sql: ${TABLE}."F_SUBSCRIPTION_STATE" ;;
  }

  dimension_group: f_subscription_end {
    type: time
    sql: ${TABLE}."F_SUBSCRIPTION_END" ;;
  }

  dimension_group: f_subscription_start {
    type: time
    sql: ${TABLE}."F_SUBSCRIPTION_START" ;;
  }

  set: detail {
    fields: [
      idd,
      t_s_user_sso_guid,
      t_hash,
      t_subscription_local_time_time,
      t_subscription_state,
      t_subscription_end_time,
      t_subscription_start_time,
      f_s_user_sso_guid,
      f_hash,
      f_subscription_local_time_time,
      f_subscription_state,
      f_subscription_end_time,
      f_subscription_start_time
    ]
  }
}
