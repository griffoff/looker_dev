view: a_enroll_problem {
  derived_table: {
    sql: select * from prod.UNLIMITED.RAW_OLR_ENROLLMENT
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

  dimension: course_key {
    type: string
    sql: ${TABLE}."COURSE_KEY" ;;
  }

  dimension: access_role {
    type: string
    sql: ${TABLE}."ACCESS_ROLE" ;;
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
      course_key,
      access_role
    ]
  }
}
