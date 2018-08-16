view: a_no_cu_pay {
   derived_table: {
    sql:  with
      enroll as (
            select distinct sub.user_sso_guid as user
            , sub.course_key
            , min(sub.local_time) as time
            from prod.UNLIMITED.RAW_OLR_ENROLLMENT sub left outer join prod.unlimited.CLTS_EXCLUDED_USERS exc on sub.user_sso_guid = exc.user_sso_guid
            where exc.user_sso_guid is null
            group by user, sub.course_key
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
      and e.course_key = enroll.course_key
      and c."#CONTEXT_ID" = e.course_key
      --and c.COURSE_INTERNAL_FLG like 'false'
      and e.access_role like 'STUDENT'
      )


      ,paid as( SELECT distinct

      case  when e.user_sso_guid in (select user_sso_guid from prod.unlimited.RAW_SUBSCRIPTION_EVENT where subscription_state like 'full_access')  and  e.user_sso_guid in (select user_guid from prod.STG_CLTS.ACTIVATIONS_OLR_V where actv_isbn in ('9780357700006','9780357700013','9780357700020')) then 'PAC' else
                  case when e.user_sso_guid in (select user_sso_guid from prod.unlimited.RAW_SUBSCRIPTION_EVENT where subscription_state like 'full_access') and  e.user_sso_guid not in (select user_guid from prod.STG_CLTS.ACTIVATIONS_OLR_V where actv_isbn in ('9780357700006','9780357700013','9780357700020')) then 'Commerce'
                  end
      end as status
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
            'Paid no CU' as status
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
SELECT DATEVALUE as day FROM DW_DEVMATH.DIM_DATE WHERE DATEKEY BETWEEN (TO_CHAR(date_part(year,current_date())) || '0101') AND (TO_CHAR(date_part(year,current_date())) || TO_CHAR(RIGHT('00' || DATE_PART(month,current_date()),2)) || TO_CHAR(RIGHT('00' || DATE_PART(day,current_date()),2))) ORDER BY DATEVALUE
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
