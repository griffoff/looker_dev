view: a_enrollent {
    derived_table: {
      sql: with
              enroll as (
              select user_sso_guid  as user
              , max(local_time) as time
              from  prod.UNLIMITED.RAW_OLR_ENROLLMENT
              group by user
              )


              ,paid as( SELECT distinct
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
                            FROM prod.UNLIMITED.RAW_OLR_ENROLLMENT as e,  prod.UNLIMITED.RAW_OLR_PROVISIONED_PRODUCT as pp, enroll
                            where e.user_sso_guid = pp.user_sso_guid
                            and e.course_key = pp.context_id
                            and pp."source" = 'unlimited'
                            AND pp.SOURCE_ID <> 'Something'
                            and enroll.user = e.user_sso_guid
                            and enroll_local_time = enroll.time
                            )

                            , unpaid as(
                            SELECT distinct
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
                            FROM prod.UNLIMITED.RAW_OLR_ENROLLMENT as e, enroll
                            where e.user_sso_guid not in (select user_sso_guid from paid)
                            and enroll.user = e.user_sso_guid
                            and enroll_local_time = enroll.time
                            )
                            , days as (
                            select distinct to_date(local_time) as day
                            from prod.UNLIMITED.RAW_OLR_ENROLLMENT
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
    sql: ${user_sso_guid} ;;
  }

  measure: count_users {
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
