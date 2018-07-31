view: a_e {
 derived_table: {
  sql: with  enrollment as (
      select user_sso_guid as e_user_sso_guid
      , _hash as hash
      , local_time as enrollment_local_time
      , access_role as enrollment_access_role
      , platform_environment as platform_environment
      , product_platform as product_platform
      from int.unlimited.RAW_OLR_ENROLLMENT
      )

      select * from enrollment
       ;;
}

measure: count {
  type: count
  drill_fields: [detail*]
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

set: detail {
  fields: [
    e_user_sso_guid,
    hash,
    enrollment_local_time_time,
    enrollment_access_role,
    platform_environment,
    product_platform
  ]
}
}
