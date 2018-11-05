view: cu_vw_subscription_base {
  derived_table: {
    sql:
      SELECT DISTINCT
        sub.*
      FROM
        ${cu_raw_subscription_event.SQL_TABLE_NAME} sub
        LEFT OUTER JOIN prod.unlimited.EXCLUDED_USERS exc
          ON sub.user_sso_guid = exc.user_sso_guid
      WHERE
        exc.user_sso_guid is null -- not found in exclusions table
      and sub.USER_ENVIRONMENT like 'production'
      and sub.PLATFORM_ENVIRONMENT like 'production'
      and sub.contract_id <> 'stuff'
      and sub.contract_id <> 'Testuser'
      ;;
  }
  dimension: _hash {
    type: string
    sql: ${TABLE}."_HASH" ;;
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

  dimension_group: local {
    type: time
    sql: ${TABLE}."LOCAL_TIME" ;;
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

  dimension_group: subscription_end {
    type: time
    sql: ${TABLE}."SUBSCRIPTION_END" ;;
  }

  dimension_group: subscription_start {
    type: time
    sql: ${TABLE}."SUBSCRIPTION_START" ;;
  }

  dimension: subscription_state {
    type: string
    sql: ${TABLE}."SUBSCRIPTION_STATE" ;;
  }

  dimension: user_environment {
    type: string
    sql: ${TABLE}."USER_ENVIRONMENT" ;;
  }

  dimension: user {
    type: string
    sql: ${TABLE}."USER_SSO_GUID" ;;
  }

  set: detail {
    fields: [
      _hash,
      _ldts_time,
      _rsrc,
      contract_id,
      local_time,
      message_format_version,
      message_type,
      platform_environment,
      product_platform,
      subscription_end_time,
      subscription_start_time,
      subscription_state,
      user_environment,
      user
    ]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }
}
