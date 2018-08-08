view: a_enrollent {
    derived_table: {
      sql: with paid as( SELECT
              'Paid' as status
              , e._hash as enroll_hash
              , e._ldts as enroll_ldts
              , e._rsrc as enroll_rsrc
              , e.access_role as enroll_access_role
              , e.course_key as course_key
              , e.local_time as enroll_local_time
              , e.message_format_version as enroll_message_format_version
              , e.message_type as enroll_message_type
              , e.platform_environment as enroll_platform_environment
              , e.product_platform as enroll_product_platform
              , e.user_environment as enroll_user_environment
              , e.user_sso_guid as user_sso_guid
              , pp._hash as prod_hash
              , pp._ldts as prod_ldts
              , pp._rsrc as prod_rsrc
              , pp.code_type as prod_code_type
              , pp.core_text_isbn as prod_core_text_isbn
              , pp.date_added as prod_date_added
              , pp.expiration_date as prod_expiration_date
              , pp.iac_isbn as prod_iac_isbn
              , pp.institution_id as prod_institution_id
              , pp.local_time as prod_local_time
              , pp.message_type as prod_message_type
              , pp.platform_environment as prod_platform_environment
              , pp.product_id as prod_product_id
              , pp.product_platform as prod_product_platform
              , pp.region as prod_region
              , pp."source" as prod_source
              , pp.source_id as prod_source_id
              , pp.user_environment as prod_user_environment
              , pp.user_type as prod_user_type
              FROM UNLIMITED.RAW_OLR_ENROLLMENT as e,  UNLIMITED.RAW_OLR_PROVISIONED_PRODUCT as pp
              where e.user_sso_guid = pp.user_sso_guid
              and e.course_key = pp.context_id
              and pp."source" = 'unlimited'
              AND pp.SOURCE_ID <> 'Something'
              )

              , unpaid as(
              SELECT
              'Unpaid' as status
              , e._hash as enroll_hash
              , e._ldts as enroll_ldts
              , e._rsrc as enroll_rsrc
              , e.access_role as enroll_access_role
              , e.course_key as course_key
              , e.local_time as enroll_local_time
              , e.message_format_version as enroll_message_format_version
              , e.message_type as enroll_message_type
              , e.platform_environment as enroll_platform_environment
              , e.product_platform as enroll_product_platform
              , e.user_environment as enroll_user_environment
              , e.user_sso_guid as user_sso_guid
              , null as prod_hash
              , null as prod_ldts
              , null as prod_rsrc
              , null as prod_code_type
              , null as prod_core_text_isbn
              , null as prod_date_added
              , null as prod_expiration_date
              , null as prod_iac_isbn
              , null as prod_institution_id
              , null as prod_local_time
              , null as prod_message_type
              , null as prod_platform_environment
              , null as prod_product_id
              , null as prod_product_platform
              , null as prod_region
              , null as prod_source
              , null as prod_source_id
              , null as prod_user_environment
              , null as prod_user_type
              FROM UNLIMITED.RAW_OLR_ENROLLMENT as e
              where e.user_sso_guid not in (select user_sso_guid from paid)
              )
              , days as (SELECT current_date() as day
                    union
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

              , _all as (
              select * from paid
              union
              select * from unpaid
              )


              , res as (
              select days.day
              , _all.*
              from _all, days
              where enroll_local_time <= days.day
              )
              select  * from res
               ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

  measure: count_e {
    type: count_distinct
    drill_fields: [detail*]
    sql: ${enroll_hash} ;;
  }

    dimension: day {
      type: date
      sql: ${TABLE}."DAY" ;;
    }

    dimension: status {
      type: string
      sql: ${TABLE}."STATUS" ;;
    }

    dimension: enroll_hash {
      type: string
      sql: ${TABLE}."ENROLL_HASH" ;;
    }

    dimension_group: enroll_ldts {
      type: time
      sql: ${TABLE}."ENROLL_LDTS" ;;
    }

    dimension: enroll_rsrc {
      type: string
      sql: ${TABLE}."ENROLL_RSRC" ;;
    }

    dimension: enroll_access_role {
      type: string
      sql: ${TABLE}."ENROLL_ACCESS_ROLE" ;;
    }

    dimension: course_key {
      type: string
      sql: ${TABLE}."COURSE_KEY" ;;
    }

    dimension_group: enroll_local_time {
      type: time
      sql: ${TABLE}."ENROLL_LOCAL_TIME" ;;
    }

    dimension: enroll_message_format_version {
      type: number
      sql: ${TABLE}."ENROLL_MESSAGE_FORMAT_VERSION" ;;
    }

    dimension: enroll_message_type {
      type: string
      sql: ${TABLE}."ENROLL_MESSAGE_TYPE" ;;
    }

    dimension: enroll_platform_environment {
      type: string
      sql: ${TABLE}."ENROLL_PLATFORM_ENVIRONMENT" ;;
    }

    dimension: enroll_product_platform {
      type: string
      sql: ${TABLE}."ENROLL_PRODUCT_PLATFORM" ;;
    }

    dimension: enroll_user_environment {
      type: string
      sql: ${TABLE}."ENROLL_USER_ENVIRONMENT" ;;
    }

    dimension: user_sso_guid {
      type: string
      sql: ${TABLE}."USER_SSO_GUID" ;;
    }

    dimension: prod_hash {
      type: string
      sql: ${TABLE}."PROD_HASH" ;;
    }

    dimension_group: prod_ldts {
      type: time
      sql: ${TABLE}."PROD_LDTS" ;;
    }

    dimension: prod_rsrc {
      type: string
      sql: ${TABLE}."PROD_RSRC" ;;
    }

    dimension: prod_code_type {
      type: string
      sql: ${TABLE}."PROD_CODE_TYPE" ;;
    }

    dimension: prod_core_text_isbn {
      type: string
      sql: ${TABLE}."PROD_CORE_TEXT_ISBN" ;;
    }

    dimension_group: prod_date_added {
      type: time
      sql: ${TABLE}."PROD_DATE_ADDED" ;;
    }

    dimension_group: prod_expiration_date {
      type: time
      sql: ${TABLE}."PROD_EXPIRATION_DATE" ;;
    }

    dimension: prod_iac_isbn {
      type: string
      sql: ${TABLE}."PROD_IAC_ISBN" ;;
    }

    dimension: prod_institution_id {
      type: string
      sql: ${TABLE}."PROD_INSTITUTION_ID" ;;
    }

    dimension_group: prod_local_time {
      type: time
      sql: ${TABLE}."PROD_LOCAL_TIME" ;;
    }

    dimension: prod_message_type {
      type: string
      sql: ${TABLE}."PROD_MESSAGE_TYPE" ;;
    }

    dimension: prod_platform_environment {
      type: string
      sql: ${TABLE}."PROD_PLATFORM_ENVIRONMENT" ;;
    }

    dimension: prod_product_id {
      type: string
      sql: ${TABLE}."PROD_PRODUCT_ID" ;;
    }

    dimension: prod_product_platform {
      type: string
      sql: ${TABLE}."PROD_PRODUCT_PLATFORM" ;;
    }

    dimension: prod_region {
      type: string
      sql: ${TABLE}."PROD_REGION" ;;
    }

    dimension: prod_source {
      type: string
      sql: ${TABLE}."PROD_SOURCE" ;;
    }

    dimension: prod_source_id {
      type: string
      sql: ${TABLE}."PROD_SOURCE_ID" ;;
    }

    dimension: prod_user_environment {
      type: string
      sql: ${TABLE}."PROD_USER_ENVIRONMENT" ;;
    }

    dimension: prod_user_type {
      type: string
      sql: ${TABLE}."PROD_USER_TYPE" ;;
    }

    set: detail {
      fields: [
        day,
        status,
        enroll_hash,
        enroll_ldts_time,
        enroll_rsrc,
        enroll_access_role,
        course_key,
        enroll_local_time_time,
        enroll_message_format_version,
        enroll_message_type,
        enroll_platform_environment,
        enroll_product_platform,
        enroll_user_environment,
        user_sso_guid,
        prod_hash,
        prod_ldts_time,
        prod_rsrc,
        prod_code_type,
        prod_core_text_isbn,
        prod_date_added_time,
        prod_expiration_date_time,
        prod_iac_isbn,
        prod_institution_id,
        prod_local_time_time,
        prod_message_type,
        prod_platform_environment,
        prod_product_id,
        prod_product_platform,
        prod_region,
        prod_source,
        prod_source_id,
        prod_user_environment,
        prod_user_type
      ]
    }
  }
