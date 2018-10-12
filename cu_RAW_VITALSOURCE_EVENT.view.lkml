view: cu_raw_vitalsource_event {

  sql_table_name: prod.UNLIMITED.RAW_VITALSOURCE_EVENT;;

  measure: count {
    type: count
    drill_fields: [detail*]
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

  dimension_group: event_time {
    type: time
    sql: ${TABLE}."EVENT_TIME" ;;
  }

  dimension: timezone_offset {
    type: string
    sql: ${TABLE}."TIMEZONE_OFFSET" ;;
  }

  dimension: user_sso_guid {
    type: string
    sql: ${TABLE}."USER_SSO_GUID" ;;
  }

  dimension: user_environment {
    type: string
    sql: ${TABLE}."USER_ENVIRONMENT" ;;
  }

  dimension: product_platform {
    type: string
    sql: ${TABLE}."PRODUCT_PLATFORM" ;;
  }

  dimension: platform_environment {
    type: string
    sql: ${TABLE}."PLATFORM_ENVIRONMENT" ;;
  }

  dimension: event_id {
    type: string
    sql: ${TABLE}."EVENT_ID" ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}."EVENT_TYPE" ;;
  }

  dimension: event_action {
    type: string
    sql: ${TABLE}."EVENT_ACTION" ;;
  }

  dimension: vbid {
    type: string
    sql: ${TABLE}."VBID" ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}."SESSION_ID" ;;
  }

  dimension: target_name {
    type: string
    sql: ${TABLE}."TARGET_NAME" ;;
  }

  dimension: target_type {
    type: string
    sql: ${TABLE}."TARGET_TYPE" ;;
  }

  dimension: search_term {
    type: string
    sql: ${TABLE}."SEARCH_TERM" ;;
  }

  set: detail {
    fields: [
      _hash,
      _ldts_time,
      _rsrc,
      event_time_time,
      timezone_offset,
      user_sso_guid,
      user_environment,
      product_platform,
      platform_environment,
      event_id,
      event_type,
      event_action,
      vbid,
      session_id,
      target_name,
      target_type,
      search_term
    ]
  }
}
