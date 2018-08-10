view: a_subscriptions {
  derived_table: {
    sql: with days as (
      select dateadd(dd, -1, current_date()) as day
      union
      select dateadd(dd, -2, current_date()) as day
      union
      select dateadd(dd, -3, current_date()) as day
      union
      select dateadd(dd, -4, current_date()) as day
      union
      select dateadd(dd, -5, current_date()) as day
      union
      select dateadd(dd, -6, current_date()) as day
      union
      select dateadd(dd, -7, current_date()) as day
      union
      select dateadd(dd, -8, current_date()) as day
      union
      select dateadd(dd, -9, current_date()) as day
      union
      select dateadd(dd, -10, current_date()) as day
      union
      select dateadd(dd, -11, current_date()) as day
      union
      select dateadd(dd, -12, current_date()) as day
      union
      select dateadd(dd, -13, current_date()) as day
      union
      select dateadd(dd, -14, current_date()) as day
      union
      select dateadd(dd, -15, current_date()) as day
      union
      select dateadd(dd, -16, current_date()) as day
      union
      select dateadd(dd, -17, current_date()) as day
      union
      select dateadd(dd, -18, current_date()) as day
      union
      select dateadd(dd, -19, current_date()) as day
      union
      select dateadd(dd, -20, current_date()) as day
      union
      select dateadd(dd, -21, current_date()) as day
      union
      select dateadd(dd, -22, current_date()) as day
      union
      select dateadd(dd, -23, current_date()) as day
      union
      select dateadd(dd, -24, current_date()) as day
      union
      select dateadd(dd, -25, current_date()) as day
      union
      select dateadd(dd, -26, current_date()) as day
      union
      select dateadd(dd, -27, current_date()) as day
      union
      select dateadd(dd, -28, current_date()) as day
      union
      select dateadd(dd, -29, current_date()) as day
      union
      select dateadd(dd, -30, current_date()) as day
      )

      , actual_sub as (
      select user_sso_guid
      , max(subscription_start) as subscription_start
      , max(subscription_end) as subscription_end
      from prod.unlimited.RAW_SUBSCRIPTION_EVENT
      group by user_sso_guid
      )
      , sub as (
      select days.day as day
      , actual_sub.user_sso_guid as user_sso_guid
      , se.subscription_state as subscription_state
      , se.contract_id as contract_id
      , se.subscription_start as subscription_start
      , se.subscription_end as subscription_end
      , se._ldts
      , se._rsrc
      , se.message_format_version
      , se.message_type
      , se.platform_environment
      , se.product_platform
      , se.user_environment
      , se._hash
      from prod.unlimited.RAW_SUBSCRIPTION_EVENT as se , actual_sub, days
      where actual_sub.user_sso_guid = se.user_sso_guid
      and actual_sub.subscription_start = se.subscription_start
      and actual_sub.subscription_end = se.subscription_end
      and actual_sub.subscription_start < days.day
      and actual_sub.subscription_end > days.day
      )


      select * from sub
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_users {
    type: count_distinct
    sql: ${user_sso_guid} ;;
    drill_fields: [detail*]
  }

  measure: count_trial {
    type: count_distinct
    sql: ${user_sso_guid} ;;
    filters: {
      field: subscription_state
      value: "trial_access"
    }
    drill_fields: [detail*]
  }



  dimension: day {
    type: date
    sql: ${TABLE}."DAY" ;;
  }

  dimension: user_sso_guid {
    type: string
    sql: ${TABLE}."USER_SSO_GUID" ;;
  }

  dimension: subscription_state {
    type: string
    sql: ${TABLE}."SUBSCRIPTION_STATE" ;;
  }

  dimension: contract_id {
    type: string
    sql: ${TABLE}."CONTRACT_ID" ;;
  }

  dimension_group: subscription_start {
    type: time
    sql: ${TABLE}."SUBSCRIPTION_START" ;;
  }

  dimension_group: subscription_end {
    type: time
    sql: ${TABLE}."SUBSCRIPTION_END" ;;
  }

  dimension_group: _ldts {
    type: time
    sql: ${TABLE}."_LDTS" ;;
  }

  dimension: _rsrc {
    type: string
    sql: ${TABLE}."_RSRC" ;;
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

  dimension: _hash {
    type: string
    sql: ${TABLE}."_HASH" ;;
  }

  set: detail {
    fields: [
      day,
      user_sso_guid,
      subscription_state,
      contract_id,
      subscription_start_time,
      subscription_end_time,
      _ldts_time,
      _rsrc,
      message_format_version,
      message_type,
      platform_environment,
      product_platform,
      user_environment,
      _hash
    ]
  }
}
