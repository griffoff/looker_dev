view: switch_state_prod {
  derived_table: {
    sql: with trial as (
      select user_sso_guid as trial_user_sso_guid
      , _hash as trial_hash
      , local_time as trial_subscription_local_time
      , subscription_state as trial_subscription_state
      , subscription_start as trial_subscription_start
      , subscription_end as trial_subscription_end
      from prod.unlimited.RAW_SUBSCRIPTION_EVENT
      where trial_subscription_state like '%trial%'
      )

      , _full as (
      select user_sso_guid as full_user_sso_guid
      , _hash as full_hash
      , local_time as full_subscription_local_time
      , subscription_state as full_subscription_state
      , subscription_end as full_subscription_end
      , subscription_start as full_subscription_start
      from prod.unlimited.RAW_SUBSCRIPTION_EVENT
      where full_subscription_state like '%full%'
      )


      , only_trial as (
      select distinct 'a:TRIAL' as idd
      , trial.trial_user_sso_guid as user_sso_guid
      , trial.trial_subscription_state as subscription_state
      , trial.trial_subscription_start as _start
      , trial.trial_subscription_end as _end
      from trial, _full
      where trial.trial_user_sso_guid not in (select full_user_sso_guid from _full)
      --and date_part(dd, trial_subscription_start) = date_part(dd, full_subscription_start)
      )

      , only_full as (
      select distinct 'b:Full Access - Direct Purchase' as idd
      , _full.full_user_sso_guid as user_sso_guid
      , _full.full_subscription_state as subscription_state
      , _full.full_subscription_start as _start
      , _full.full_subscription_end as _end
      from _full
      where _full.full_user_sso_guid not in (select trial_user_sso_guid from trial)
      )

      , from_trial_to_full_long as(
      select distinct 'd:Full Access - Upgraded' as idd
      , trial.trial_user_sso_guid as user_sso_guid
      , _full.full_subscription_state as subscription_state
      , _full.full_subscription_start as _start
      , _full.full_subscription_end as _end
      from trial, _full
      where trial_user_sso_guid = full_user_sso_guid
      --and full_subscription_start <= trial_subscription_end
      --and day(trial_subscription_end) != day(full_subscription_start)
      )

      , res as (
      select * from only_trial
      union
      select * from only_full
      union
      select * from from_trial_to_full_long
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

dimension: idd {
  type: string
  sql: ${TABLE}."IDD" ;;
}

dimension: user_sso_guid {
  type: string
  sql: ${TABLE}."USER_SSO_GUID" ;;
}

dimension: subscription_state {
  type: string
  sql: ${TABLE}."SUBSCRIPTION_STATE" ;;
}

dimension_group: _start {
  type: time
  sql: ${TABLE}."_START" ;;
}

dimension_group: _end {
  type: time
  sql: ${TABLE}."_END" ;;
}

set: detail {
  fields: [idd, user_sso_guid, subscription_state, _start_time, _end_time]
}
}
