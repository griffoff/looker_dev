view: a_no_cu_pay {
   derived_table: {
    sql: with
      enroll as (
            select distinct user_sso_guid as user
            , max(local_time) as time
            from  prod.UNLIMITED.RAW_OLR_ENROLLMENT
            group by user
            )

      , en as (
      select distinct
      e._hash
      , e._ldts
      , e._rsrc
      , e.access_role
      , e.course_key
      , e.local_time
      , e.message_format_version
      , e.message_type
      , e.platform_environment
      , e.product_platform
      , e.user_environment
      , e.user_sso_guid
      FROM prod.UNLIMITED.RAW_OLR_ENROLLMENT as e,  enroll, prod.STG_CLTS.OLR_COURSES c
      where  enroll.user = e.user_sso_guid
      and e.local_time = enroll.time
      and c."#CONTEXT_ID" = e.course_key
      and c.COURSE_INTERNAL_FLG <> 'true'
      and e.access_role like 'STUDENT'
      )

      ,paid as( SELECT distinct
      'CU Paid' as status
      , 'CU Paid' as status_2
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
      FROM en as e,  prod.UNLIMITED.RAW_OLR_PROVISIONED_PRODUCT as pp
      where e.user_sso_guid = pp.user_sso_guid
      and e.course_key = pp.context_id
      and pp."source" = 'unlimited'
      AND pp.SOURCE_ID <> 'Something'
      and pp.USER_ENVIRONMENT like 'production'
      and pp.PLATFORM_ENVIRONMENT like 'production'
      )

            , paid_no_cu as (
            SELECT distinct
            case when a.code_type like 'PAC' then 'Paid no CU PAC' else case when a.code_type like 'IAC' then 'Paid no CU IAC' else 'Paid no CU other' end end as status
            , 'Paid no CU' as status_2
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
            FROM prod.STG_CLTS.ACTIVATIONS_OLR_V a,  en e
            where a.user_guid = e.user_sso_guid
            and e.course_key = a.context_id
            and user_sso_guid not in (select user_sso_guid from paid)

            )

            , unpaid as (
            SELECT distinct
            'Unpaid' as status
            , 'Unpaid' as status_2
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
            FROM en e
            where e.user_sso_guid not in (select user_sso_guid from paid_no_cu)
            and e.user_sso_guid not in (select user_sso_guid from paid)
            )


            , days as (
            select distinct to_date(local_time) as day
            from prod.UNLIMITED.RAW_OLR_ENROLLMENT
            where day <> current_date()
            )
            , _all as (
            select * from paid
            union
            select * from unpaid
            union
            select * from paid_no_cu
            )


            , res as (
            select days.day
            , _all.*
            from _all, days
            where to_date(enroll_local_time) <= days.day
            )


            select * from res
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
dimension: status_2 {
    type: string
    sql: ${TABLE}."STATUS_2" ;;
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
    user_sso_guid
  ]
}
}
