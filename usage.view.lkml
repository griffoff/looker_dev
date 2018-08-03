view: usage {
   derived_table: {
    sql: with res_users as (
      select guid as user_sso_guid,
      uid as id,
      SUBSCRIPTION_STATE as SUBSCRIPTION_STATE_u
      --,COURSE_KEY as COURSE_KEY
      --,VS_ISBN as vbid
      --,MTR_ISBN as MTR_ISBN
      --,APLIA_ISBN as APLIA_ISBN
      --,APLIA_MTR_ISBN as APLIA_MTR_ISBN
      --,CNOW_ISBN as CNOW_ISBN
      --,CNOW_MTR_ISBN as CNOW_MTR_ISBN
      --,WEBASSIGN_ISBN as WEBASSIGN_ISBN
      --,WEBASSIGN_MTR_ISBN as WEBASSIGN_MTR_ISBN
      --,MT_ISBN as   MT_ISBN
      , CREATED_ON as date_c
      from int.UNLIMITED.SCENARIO_DETAILS
      )

      , vital as (

      select vs.user_sso_guid as vs_user_sso_guid
      , vs.event_time as vital_sourse_event_local_time
      , iac.pp_name as vital_sourse_event_title
      , vs.vbid as vital_sourse_event_isbn
      , vs.session_id as vital_sourse_event_session_id
      , vs.event_type as vital_sourse_event_event_type
      , vs.event_action as vital_sourse_event_event_action
      , vs._hash as vital_sourse_event_hash
      from int.unlimited.RAW_VITALSOURCE_EVENT as vs
      , int.unlimited.RAW_OLR_EXTENDED_IAC as iac
      where iac.pp_isbn_13 = vital_sourse_event_isbn
      )

      , mt as (
      select m.user_identifier as mt_user_sso_guid
      , m.event_time as mt_local_time
      , iac.pp_name as mt_title
      , m.component_isbn as mt_isbn
      , m.mt_session_id as mt_session_id
      , t.platform as mt_platform
      , m.event_action as mt_event_action
      , m.event_category as mt_event_type
      , m._hash as mt_hash
      from cap_er.nonprod.RAW_MT_RESOURCE_INTERACTIONS as m
      , int.unlimited.RAW_OLR_EXTENDED_IAC as iac
      , int.unlimited.RAW_OLR_PROVISIONED_PRODUCT as pp
      ,int.STG_CLTS.PRODUCTS_V as t
      where (m.component_isbn = iac.cp_isbn_13 or m.component_isbn = iac.pp_isbn_13)
      and pp.user_sso_guid =  mt_user_sso_guid
      and iac.pp_isbn_13 = pp.iac_isbn
      and t.isbn13 = iac.pp_isbn_13
      --and mt_platform not in ('MindTap', 'OWL V2', 'Aplia', 'WebAssign', 'CNOW', 'MindTap Reader', 'SAM')
      )
      , u_v as (
      select res_users.*
      , vital.*
      from res_users, vital
      where res_users.user_sso_guid = vital.vs_user_sso_guid
      )

      , res as (
      select u_v.*,
      mt.*
      from u_v, mt
      where mt.mt_user_sso_guid = u_v.user_sso_guid

      union

      select u_v.*
      , u_v.user_sso_guid as mt_user_sso_guid
      , null as mt_local_time
      , null as mt_title
      , null as mt_isbn
      , null as mt_session_id
      , null as mt_platform
      , null as mt_event_action
      , null as mt_event_type
      , null as mt_hash
      from u_v
      where u_v.user_sso_guid not in (select mt_user_sso_guid from mt)

      )


      select * from res
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_vs
  {
    type: count_distinct
    drill_fields: [vs_sum*]
    sql: ${vital_sourse_event_hash} ;;

  }

  measure: h_v
  {
    type: number
    sql: case when ${count_vs} = 0 then 0 else 2 / ((3 / ${count_vs}) + (1/(3 / ${count_vs}))) end ;;

  }


  measure: p_h_v
  {
    type: number
    sql: case when ${count_vs} = 0 then 0 else 1 end ;;

  }

  set:  vs_sum{
    fields: [date_c, id, subscription_state_u, vital_sourse_event_title, vital_sourse_event_isbn, vital_sourse_event_session_id, vital_sourse_event_event_type, vital_sourse_event_event_action, count_vs ]
  }

  measure: count_mtr_e_boock
  {
    type: count_distinct
    drill_fields: [mtr_e_boock_sum*]
    filters: {
      field: mt_platform
      value: "MindTap Reader"
    }
    sql: ${mt_hash} ;;
  }

  measure: h_mtr
  {
    type: number
    sql: case when(${id} like '%no_cu%' and ${count_mtr_e_boock} = 0) then 1 else (case when (${id} like '%no_cu%' and ${count_mtr_e_boock} > 0) then 0 else (case when ${count_mtr_e_boock} = 0 then 0 else (2 / ((3 / ${count_mtr_e_boock}) + (1/(3 / ${count_mtr_e_boock})))) end ) end ) end ;;

  }

  measure: p_h_mtr
  {
    type: number
    sql: case when(${id} like '%no_cu%' and ${count_mtr_e_boock} = 0) then 1 else (case when (${id} like '%no_cu%' and ${count_mtr_e_boock} > 0) then 0 else (case when ${count_mtr_e_boock} = 0 then 0 else 1 end ) end ) end ;;

  }

  set:  mtr_e_boock_sum{
    fields: [date_c, id, subscription_state_u, mt_title, mt_isbn, mt_session_id, mt_event_type, mt_event_action, mt_platform, count_mtr_e_boock]
  }


  measure: count_aplia
  {
    type: count_distinct
    drill_fields: [aplia_sum*]
    filters: {
      field: mt_platform
      value: "Aplia"
    }
    sql: ${mt_hash} ;;
  }

  measure: h_aplia
  {
    type: number
    sql: case when(${id} like '%no_cu%' and ${count_aplia} = 0) then 1 else (case when (${id} like '%no_cu%' and ${count_aplia} > 0) then 0 else (case when ${count_aplia} = 0 then 0 else (2 / ((3 / ${count_aplia}) + (1/(3 / ${count_aplia})))) end ) end ) end ;;

  }

  measure: p_h_aplia
  {
    type: number
    sql: case when(${id} like '%no_cu%' and ${count_aplia} = 0) then 1 else (case when (${id} like '%no_cu%' and ${count_aplia} > 0) then 0 else (case when ${count_aplia} = 0 then 0 else 1 end ) end ) end ;;

  }

  set:  aplia_sum{
    fields: [date_c, id, subscription_state_u, mt_title, mt_isbn, mt_session_id, mt_event_type, mt_event_action, mt_platform, count_aplia]
  }


  measure: count_cnow
  {
    type: count_distinct
    drill_fields: [cnow_sum*]
    filters: {
      field: mt_platform
      value: "CNOW"
    }
    sql: ${mt_hash};;
  }


  measure: h_cnow
  {
    type: number
    sql: case when(${id} like '%no_cu%' and ${count_cnow} = 0) then 1 else (case when (${id} like '%no_cu%' and ${count_cnow} > 0) then 0 else (case when ${count_cnow} = 0 then 0 else (2 / ((3 / ${count_cnow}) + (1/(3 / ${count_cnow})))) end ) end ) end ;;

  }

  measure: p_h_cnow
  {
    type: number
    sql: case when(${id} like '%no_cu%' and ${count_cnow} = 0) then 1 else (case when (${id} like '%no_cu%' and ${count_cnow} > 0) then 0 else (case when ${count_cnow} = 0 then 0 else 1 end ) end ) end ;;

  }


  set:  cnow_sum{
    fields: [date_c, id, subscription_state_u, mt_title, mt_isbn, mt_session_id, mt_event_type, mt_event_action, mt_platform, count_cnow]
  }

  measure: count_mt
  {
    type: count_distinct
    drill_fields: [mt_sum*]
    filters: {
      field: mt_platform
      value: "MindTap"
    }
    sql: ${mt_hash};;
  }


  measure: h_mt
  {
    type: number
    sql: case when(${id} like '%no_cu%' and ${count_mt} = 0) then 1 else (case when (${id} like '%no_cu%' and ${count_mt} > 0) then 0 else (case when ${count_mt} = 0 then 0 else (2 / ((3 / ${count_mt}) + (1/(3 / ${count_mt})))) end ) end ) end ;;

  }

  measure: p_h_mt
  {
    type: number
    sql: case when(${id} like '%no_cu%' and ${count_mt} = 0) then 1 else (case when (${id} like '%no_cu%' and ${count_mt} > 0) then 0 else (case when ${count_mt} = 0 then 0 else 1 end ) end ) end ;;

  }

  set:  mt_sum{
    fields: [date_c, id, subscription_state_u, mt_title, mt_isbn, mt_session_id, mt_event_type, mt_event_action, mt_platform, count_mt]
  }

  measure: count_wa
  {
    type: count_distinct
    drill_fields: [wa_sum*]
    filters: {
      field: mt_platform
      value: "WebAssign"
    }
    sql: ${mt_hash};;
  }

  measure: h_wa
  {
    type: number
    sql: case when(${id} like '%no_cu%' and ${count_wa} = 0) then 1 else (case when (${id} like '%no_cu%' and ${count_wa} > 0) then 0 else (case when ${count_wa} = 0 then 0 else (2 / ((3 / ${count_wa}) + (1/(3 / ${count_wa})))) end ) end ) end ;;

  }

  measure: p_h_wa
  {
    type: number
    sql: case when(${id} like '%no_cu%' and ${count_wa} = 0) then 1 else (case when (${id} like '%no_cu%' and ${count_wa} > 0) then 0 else (case when ${count_wa} = 0 then 0 else 1 end ) end ) end ;;

  }

  set:  wa_sum{
    fields: [date_c, id, subscription_state_u, mt_title, mt_isbn, mt_session_id, mt_event_type, mt_event_action, mt_platform, count_wa]
  }

  measure: health
  {
    type: number
    sql: (${h_aplia} + ${h_cnow} +${h_mtr} + ${h_wa} + ${h_mt} + ${h_v}) / 6;;

  }

  measure: p_health
  {
    type: number
    sql: (${p_h_aplia} + ${p_h_cnow} +${p_h_mtr} + ${p_h_wa} + ${p_h_mt} + ${p_h_v}) / 6;;

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

dimension: vs_user_sso_guid {
  type: string
  sql: ${TABLE}."VS_USER_SSO_GUID" ;;
}

dimension_group: vital_sourse_event_local_time {
  type: time
  sql: ${TABLE}."VITAL_SOURSE_EVENT_LOCAL_TIME" ;;
}

dimension: vital_sourse_event_title {
  type: string
  sql: ${TABLE}."VITAL_SOURSE_EVENT_TITLE" ;;
}

dimension: vital_sourse_event_isbn {
  type: string
  sql: ${TABLE}."VITAL_SOURSE_EVENT_ISBN" ;;
}

dimension: vital_sourse_event_session_id {
  type: string
  sql: ${TABLE}."VITAL_SOURSE_EVENT_SESSION_ID" ;;
}

dimension: vital_sourse_event_event_type {
  type: string
  sql: ${TABLE}."VITAL_SOURSE_EVENT_EVENT_TYPE" ;;
}

dimension: vital_sourse_event_event_action {
  type: string
  sql: ${TABLE}."VITAL_SOURSE_EVENT_EVENT_ACTION" ;;
}

dimension: vital_sourse_event_hash {
  type: string
  sql: ${TABLE}."VITAL_SOURSE_EVENT_HASH" ;;
}

dimension: mt_user_sso_guid {
  type: string
  sql: ${TABLE}."MT_USER_SSO_GUID" ;;
}

dimension_group: mt_local_time {
  type: time
  sql: ${TABLE}."MT_LOCAL_TIME" ;;
}

dimension: mt_title {
  type: string
  sql: ${TABLE}."MT_TITLE" ;;
}

dimension: mt_isbn {
  type: string
  sql: ${TABLE}."MT_ISBN" ;;
}

dimension: mt_session_id {
  type: string
  sql: ${TABLE}."MT_SESSION_ID" ;;
}

dimension: mt_platform {
  type: string
  sql: ${TABLE}."MT_PLATFORM" ;;
}

dimension: mt_event_action {
  type: string
  sql: ${TABLE}."MT_EVENT_ACTION" ;;
}

dimension: mt_event_type {
  type: string
  sql: ${TABLE}."MT_EVENT_TYPE" ;;
}

dimension: mt_hash {
  type: string
  sql: ${TABLE}."MT_HASH" ;;
}

set: detail {
  fields: [
    user_sso_guid,
    id,
    subscription_state_u,
    date_c,
    vs_user_sso_guid,
    vital_sourse_event_local_time_time,
    vital_sourse_event_title,
    vital_sourse_event_isbn,
    vital_sourse_event_session_id,
    vital_sourse_event_event_type,
    vital_sourse_event_event_action,
    vital_sourse_event_hash,
    mt_user_sso_guid,
    mt_local_time_time,
    mt_title,
    mt_isbn,
    mt_session_id,
    mt_platform,
    mt_event_action,
    mt_event_type,
    mt_hash
  ]
}
}
