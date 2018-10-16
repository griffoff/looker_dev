view: usage_ra {
  derived_table: {
    sql: with res_users as (
      select guid as user_sso_guid,
      uid as id,
      SUBSCRIPTION_STATE as SUBSCRIPTION_STATE_u
      , CREATED_ON as date_c
      from prod.UNLIMITED.SCENARIO_DETAILS
      )

      , vital as (
      select vs.user_sso_guid as vs_user_sso_guid
      , vs._hash as vital_sourse_event_hash
      , vs.event_time ------------
      , vs.event_action
      , vs.vbid
      from ${cu_raw_vitalsource_event.SQL_TABLE_NAME} vs inner join ${cu_raw_olr_extended_iac.SQL_TABLE_NAME} iac on iac.pp_isbn_13 = vs.vbid
      )

      , mt as (
      select distinct m.user_identifier as mt_user_sso_guid
      , m.event_time as mt_event_time----------------
      , t.platform as mt_platform
      , m._hash as mt_hash
      , m.event_action as mt_event_action
      , m.COMPONENT_ISBN as mt_isbn
      from ${cu_raw_olr_raw_mt_resource_interactions.SQL_TABLE_NAME} as m
      inner join ${cu_raw_olr_extended_iac.SQL_TABLE_NAME} iac on m.component_isbn = iac.cp_isbn_13 or m.component_isbn = iac.pp_isbn_13
      inner join ${cu_raw_olr_provisioned_product.SQL_TABLE_NAME} pp on pp.user_sso_guid =  m.user_identifier and iac.pp_isbn_13 = pp.iac_isbn
      inner join ${cu_raw_olr_stg_clts_products_v.SQL_TABLE_NAME}  t on t.isbn13 = iac.pp_isbn_13
      )


      , u_v as (
      select res_users.*
      , vital.*
      , (datediff(dd, date_c, event_time) + 1) as day_number
      from res_users inner join  vital on res_users.user_sso_guid = vital.vs_user_sso_guid  ----------------------
      )

      , res as (
      select u_v.*,
      mt.*
      from u_v inner join  mt on mt.mt_user_sso_guid = u_v.user_sso_guid and to_date(mt.mt_event_time) = to_date(u_v.event_time)---------------

      union

      select u_v.*
      , u_v.user_sso_guid as mt_user_sso_guid
      , null as mt_event_time
      , null as mt_platform
      , null as mt_hash
      , null as mt_event_action
      , null as mt_isbn
      from u_v inner join mt on u_v.user_sso_guid = mt.mt_user_sso_guid
      where  mt.mt_user_sso_guid is null

      )
        --ID
      , r_g as (
      select
      res.*
      , true as success
      from res inner join prod.UNLIMITED.SCENARIO_ACTIVITIES a on a.uid = res.id and (res.mt_platform = a.product_type or res.mt_platform is null)

      )

      , r_r as (
      select res.*
      , false as success
      from res left outer join r_g on r_g.id = res.id and   r_g.MT_PLATFORM = res.MT_PLATFORM and   r_g.EVENT_ACTION = res.EVENT_ACTION
      where r_g.id is null
      or r_g.MT_PLATFORM is null
      or r_g.EVENT_ACTION is null
      )

      select * from r_g
      union
      select * from r_r
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_mt {
    type: count_distinct
    sql: ${mt_hash} ;;
    drill_fields: [
      id,
      mt_event_time_time,
      mt_platform,
      mt_hash,
      mt_event_action,
      mt_isbn,
      success
    ]
  }

  measure: count_vs {
    type: count_distinct
    sql: ${vital_sourse_event_hash} ;;
    drill_fields: [
      id,
      vital_sourse_event_hash,
      event_time_time,
      event_action,
      vbid
      ]
  }

  measure: count_success_v {
    type: count_distinct
    sql: ${vital_sourse_event_hash} ;;
    filters: {
      field: success
      value: "true"
    }
  }
  measure: count_fail_v {
    type: count_distinct
    sql: ${vital_sourse_event_hash} ;;
    filters: {
      field: success
      value: "false"
    }
  }

  measure: count_success_mt {
    type: count_distinct
    sql: ${vital_sourse_event_hash} ;;
    filters: {
      field: success
      value: "true"
    }
  }
  measure: count_fail_mt {
    type: count_distinct
    sql: ${vital_sourse_event_hash} ;;
    filters: {
      field: success
      value: "false"
    }
  }


  dimension: user_sso_guid {
    type: string
    sql: ${TABLE}."USER_SSO_GUID" ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}."ID" ;;
  }


  dimension: subscription_state_u {
    type: string
    sql: ${TABLE}."SUBSCRIPTION_STATE_U" ;;
  }

  dimension: date_c {
    type: date
    sql: ${TABLE}."DATE_C" ;;
  }

  dimension: day_number {
    type: number
    sql: ${TABLE}."DAY_NUMBER" ;;
  }

  dimension: vs_user_sso_guid {
    type: string
    sql: ${TABLE}."VS_USER_SSO_GUID" ;;
  }

  dimension: vital_sourse_event_hash {
    type: string
    sql: ${TABLE}."VITAL_SOURSE_EVENT_HASH" ;;
  }

  dimension_group: event_time {
    type: time
    sql: ${TABLE}."EVENT_TIME" ;;
  }

  dimension: event_action {
    type: string
    sql: ${TABLE}."EVENT_ACTION" ;;
  }

  dimension: vbid {
    type: string
    sql: ${TABLE}."VBID" ;;
  }

  dimension: mt_user_sso_guid {
    type: string
    sql: ${TABLE}."MT_USER_SSO_GUID" ;;
  }

  dimension_group: mt_event_time {
    type: time
    sql: ${TABLE}."MT_EVENT_TIME" ;;
  }

  dimension: mt_platform {
    type: string
    sql: ${TABLE}."MT_PLATFORM" ;;
  }

  dimension: mt_hash {
    type: string
    sql: ${TABLE}."MT_HASH" ;;
  }

  dimension: mt_event_action {
    type: string
    sql: ${TABLE}."MT_EVENT_ACTION" ;;
  }

  dimension: mt_isbn {
    type: string
    sql: ${TABLE}."MT_ISBN" ;;
  }

  dimension: success {
    type: string
    sql: ${TABLE}."SUCCESS" ;;
  }

  set: detail {
    fields: [
      user_sso_guid,
      id,
      subscription_state_u,
      date_c,
      vs_user_sso_guid,
      vital_sourse_event_hash,
      event_time_time,
      event_action,
      vbid,
      mt_user_sso_guid,
      mt_event_time_time,
      mt_platform,
      mt_hash,
      mt_event_action,
      mt_isbn,
      success
    ]
  }
}
