view: switch_state_prod {
   derived_table: {
    sql: with trial as (
      select user_sso_guid as trial_user_sso_guid
      , _hash as trial_hash
      , local_time as trial_subscription_local_time
      , subscription_state as trial_subscription_state
      , subscription_start as trial_subscription_start
      , subscription_end as trial_subscription_end
      , _ldts
      , _rsrc
      , contract_id
      , message_format_version
      , message_type
      , platform_environment
      , product_platform
      , user_environment
      from prod.unlimited.RAW_SUBSCRIPTION_EVENT
      where trial_subscription_state like '%trial%'
      and contract_id not in ('stuff', 'Testuser')

      )

      , _full as (
      select user_sso_guid as full_user_sso_guid
      , _hash as full_hash
      , local_time as full_subscription_local_time
      , subscription_state as full_subscription_state
      , subscription_end as full_subscription_end
      , subscription_start as full_subscription_start
      , _ldts
      , _rsrc
      , contract_id
      , message_format_version
      , message_type
      , platform_environment
      , product_platform
      , user_environment
      from prod.unlimited.RAW_SUBSCRIPTION_EVENT
      where full_subscription_state like '%full%'
      and contract_id not in ('stuff', 'Testuser')
      )


      , only_trial as (
      select distinct 'a:TRIAL' as idd
      , trial.trial_user_sso_guid as user_sso_guid
      , trial.trial_subscription_state as subscription_state
      , trial.trial_subscription_start as _start
      , trial.trial_subscription_end as _end
      , trial._ldts
      , trial._rsrc
      , trial.contract_id
      , trial.message_format_version
      , trial.message_type
      , trial.platform_environment
      , trial.product_platform
      , trial.user_environment
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
      , _ldts
      , _rsrc
      , contract_id
      , message_format_version
      , message_type
      , platform_environment
      , product_platform
      , user_environment
      from _full
      where _full.full_user_sso_guid not in (select trial_user_sso_guid from trial)
      )

      , from_trial_to_full_long as(
      select distinct 'd:Full Access - Upgraded' as idd
      , trial.trial_user_sso_guid as user_sso_guid
      , _full.full_subscription_state as subscription_state
      , _full.full_subscription_start as _start
      , _full.full_subscription_end as _end
      , _full._ldts
      , _full._rsrc
      , _full.contract_id
      , _full.message_format_version
      , _full.message_type
      , _full.platform_environment
      , _full.product_platform
      , _full.user_environment
      from trial, _full
      where trial_user_sso_guid = full_user_sso_guid
      --and full_subscription_start <= trial_subscription_end
      --and day(trial_subscription_end) != day(full_subscription_start)
      )

      ,days as (
      select distinct to_date(local_time) as day
      from prod.UNLIMITED.RAW_SUBSCRIPTION_EVENT
      where day <> current_date()
      )
      , _all as (
      select * from only_trial
      union
      select * from only_full
      union
      select * from from_trial_to_full_long
      )

      , res as (
      select days.day
      , _all.*
      from _all, days
      where to_date(_start) <= days.day
      and to_date(_end) >= days.day
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

dimension: day {
  type: date
  sql: ${TABLE}."DAY" ;;
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

dimension_group: _ldts {
  type: time
  sql: ${TABLE}."_LDTS" ;;
}

dimension: _rsrc {
  type: string
  sql: ${TABLE}."_RSRC" ;;
}

dimension: contract_id {
  type: string
  sql: ${TABLE}."CONTRACT_ID" ;;
}

dimension: message_format_version {
  type: number
  sql: ${TABLE}."MESSAGE_FORMAT_VERSION" ;;
}

dimension: message_type {
  type: string
  sql: ${TABLE}."MESSAGE_TYPE" ;;
}

dimension: platform_environment {
  type: string
  sql: ${TABLE}."PLATFORM_ENVIRONMENT" ;;
}

dimension: product_platform {
  type: string
  sql: ${TABLE}."PRODUCT_PLATFORM" ;;
}

dimension: user_environment {
  type: string
  sql: ${TABLE}."USER_ENVIRONMENT" ;;
}

set: detail {
  fields: [
    day,
    idd,
    user_sso_guid,
    subscription_state,
    _start_time,
    _end_time,
    _ldts_time,
    _rsrc,
    contract_id,
    message_format_version,
    message_type,
    platform_environment,
    product_platform,
    user_environment
  ]
}
}
