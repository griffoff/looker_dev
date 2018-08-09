view: a_prov_problem {
  derived_table: {
    sql: SELECT * FROM prod.UNLIMITED.RAW_OLR_PROVISIONED_PRODUCT
      ;;
  }

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

  dimension: message_format_version {
    type: number
    sql: ${TABLE}."MESSAGE_FORMAT_VERSION" ;;
  }

  dimension: message_type {
    type: string
    sql: ${TABLE}."MESSAGE_TYPE" ;;
  }

  dimension_group: local_time {
    type: time
    sql: ${TABLE}."LOCAL_TIME" ;;
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

  dimension_group: date_added {
    type: time
    sql: ${TABLE}."DATE_ADDED" ;;
  }

  dimension: context_id {
    type: string
    sql: ${TABLE}."CONTEXT_ID" ;;
  }

  dimension_group: expiration_date {
    type: time
    sql: ${TABLE}."EXPIRATION_DATE" ;;
  }

  dimension: core_text_isbn {
    type: string
    sql: ${TABLE}."CORE_TEXT_ISBN" ;;
  }

  dimension: iac_isbn {
    type: string
    sql: ${TABLE}."IAC_ISBN" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."source" ;;
  }

  dimension: source_id {
    type: string
    sql: ${TABLE}."SOURCE_ID" ;;
  }

  dimension: product_id {
    type: string
    sql: ${TABLE}."PRODUCT_ID" ;;
  }

  dimension: code_type {
    type: string
    sql: ${TABLE}."CODE_TYPE" ;;
  }

  dimension: user_type {
    type: string
    sql: ${TABLE}."USER_TYPE" ;;
  }

  dimension: institution_id {
    type: string
    sql: ${TABLE}."INSTITUTION_ID" ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}."REGION" ;;
  }

  set: detail {
    fields: [
      _hash,
      _ldts_time,
      _rsrc,
      message_format_version,
      message_type,
      local_time_time,
      user_sso_guid,
      user_environment,
      product_platform,
      platform_environment,
      date_added_time,
      context_id,
      expiration_date_time,
      core_text_isbn,
      iac_isbn,
      source,
      source_id,
      product_id,
      code_type,
      user_type,
      institution_id,
      region
    ]
  }
}
