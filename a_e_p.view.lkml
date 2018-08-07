view: a_e_p {
   derived_table: {
    sql: with  enrollment as (
      select distinct user_sso_guid as e_user_sso_guid
      , _hash as hash
      , local_time as enrollment_local_time
      , access_role as enrollment_access_role
      , platform_environment as platform_environment
      , product_platform as product_platform
      , _ldts
      , _rsrc
      , course_key
      , message_format_version
      , message_type
      , user_environment
      from prod.unlimited.RAW_OLR_ENROLLMENT
      )
      --dsfdf
      select * from enrollment
       ;;
  }

measure: count {
  type: count
  drill_fields: [detail*]
}

measure: count_m {
    type: count_distinct
    drill_fields: [detail*]
    sql: ${hash} ;;
}

dimension: e_user_sso_guid {
  type: string
  sql: ${TABLE}."E_USER_SSO_GUID" ;;
}

dimension: hash {
  type: string
  sql: ${TABLE}."HASH" ;;
}

dimension_group: enrollment_local_time {
  type: time
  sql: ${TABLE}."ENROLLMENT_LOCAL_TIME" ;;
}

dimension: enrollment_access_role {
  type: string
  sql: ${TABLE}."ENROLLMENT_ACCESS_ROLE" ;;
}

dimension: platform_environment {
  type: string
  sql: ${TABLE}."PLATFORM_ENVIRONMENT" ;;
}

dimension: product_platform {
  type: string
  sql: ${TABLE}."PRODUCT_PLATFORM" ;;
}

dimension_group: _ldts {
  type: time
  sql: ${TABLE}."_LDTS" ;;
}

dimension: _rsrc {
  type: string
  sql: ${TABLE}."_RSRC" ;;
}

dimension: course_key {
  type: string
  sql: ${TABLE}."COURSE_KEY" ;;
}

dimension: message_format_version {
  type: number
  sql: ${TABLE}."MESSAGE_FORMAT_VERSION" ;;
}

dimension: message_type {
  type: string
  sql: ${TABLE}."MESSAGE_TYPE" ;;
}

dimension: user_environment {
  type: string
  sql: ${TABLE}."USER_ENVIRONMENT" ;;
}

set: detail {
  fields: [
    e_user_sso_guid,
    hash,
    enrollment_local_time_time,
    enrollment_access_role,
    platform_environment,
    product_platform,
    _ldts_time,
    _rsrc,
    course_key,
    message_format_version,
    message_type,
    user_environment
  ]
}
}
