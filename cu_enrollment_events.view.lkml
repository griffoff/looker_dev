view: cu_enrollment_events {
  derived_table: {
    sql: with  enroll as (
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
      , to_date(e.local_time) as local_time
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
      and e.access_role like 'STUDENT'
      )

      ,paid as( SELECT distinct
      case when pp."source" like 'unlimited' then 'Paid via CU' when (pp."source" like 'gateway' and pp.code_type like 'Site License User Access') then 'Paid via Gateway Site license' when (pp."source" is null and  pp.code_type is null) then 'Paid via K12 Site License' else 'Other payment' end  as status
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
      and pp.USER_ENVIRONMENT like 'production'
      and pp.PLATFORM_ENVIRONMENT like 'production'
      AND (pp.SOURCE_ID is null or pp.SOURCE_ID <> 'Something')
      )

      , paid_no_cu as (
      SELECT distinct
      'Paid, without CU' as status
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
      and enroll_hash not in (select enroll_hash from paid)

      )

      , unpaid as (
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
      FROM en e
      where e._hash not in (select enroll_hash from paid_no_cu)
      and e._hash not in (select enroll_hash from paid)
      )

      , other as (
       SELECT distinct
      'error' as status
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
      where e._hash not in (select enroll_hash from paid_no_cu)
      and e._hash not in (select enroll_hash from paid)
      and e._hash not in (select enroll_hash from unpaid)

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
      union
      select * from other
      )


      , res as (
      select days.day
      ,to_date(ENROLL_LOCAL_TIME)
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
    sql: ${enroll_hash} ;;
  }

  dimension: day {
    type: date
    sql: ${TABLE}."DAY" ;;
  }

  dimension: to_dateenroll_local_time {
    type: date
    sql: ${TABLE}."TO_DATE(ENROLL_LOCAL_TIME)" ;;
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

  dimension: enroll_local_time {
    type: date
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
      to_dateenroll_local_time,
      status,
      enroll_hash,
      enroll_ldts_time,
      enroll_rsrc,
      enroll_access_role,
      course_key,
      enroll_local_time,
      enroll_message_format_version,
      enroll_message_type,
      enroll_platform_environment,
      enroll_product_platform,
      enroll_user_environment,
      user_sso_guid
    ]
  }
}
