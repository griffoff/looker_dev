view: a_s_p {
  derived_table: {
    sql: with subscription as (
      select user_sso_guid as s_user_sso_guid
      , _hash as hash
      , local_time as subscription_local_time
      , subscription_state as subscription_state
      , user_environment as user_environment
      , product_platform as product_platform
      from prod.unlimited.RAW_SUBSCRIPTION_EVENT
      )

      select * from subscription
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: s_user_sso_guid {
    type: string
    sql: ${TABLE}."S_USER_SSO_GUID" ;;
  }

  dimension: hash {
    type: string
    sql: ${TABLE}."HASH" ;;
  }

  dimension_group: subscription_local_time {
    type: time
    sql: ${TABLE}."SUBSCRIPTION_LOCAL_TIME" ;;
  }

  dimension: subscription_state {
    type: string
    sql: ${TABLE}."SUBSCRIPTION_STATE" ;;
  }

  dimension: user_environment {
    type: string
    sql: ${TABLE}."USER_ENVIRONMENT" ;;
  }

  dimension: product_platform {
    type: string
    sql: ${TABLE}."PRODUCT_PLATFORM" ;;
  }

  set: detail {
    fields: [
      s_user_sso_guid,
      hash,
      subscription_local_time_time,
      subscription_state,
      user_environment,
      product_platform
    ]
  }
}
