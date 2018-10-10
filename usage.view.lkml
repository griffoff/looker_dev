view: usage {
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
      from prod.unlimited.RAW_VITALSOURCE_EVENT  vs inner join prod.unlimited.RAW_OLR_EXTENDED_IAC iac on iac.pp_isbn_13 = vs.vbid
      )

      , mt as (
      select distinct m.user_identifier as mt_user_sso_guid
      , m.event_time as mt_event_time----------------
      , t.platform as mt_platform
      , m._hash as mt_hash
      from cap_er.prod.RAW_MT_RESOURCE_INTERACTIONS as m
      inner join prod.unlimited.RAW_OLR_EXTENDED_IAC iac on m.component_isbn = iac.cp_isbn_13 or m.component_isbn = iac.pp_isbn_13
      inner join prod.unlimited.RAW_OLR_PROVISIONED_PRODUCT pp on pp.user_sso_guid =  m.user_identifier and iac.pp_isbn_13 = pp.iac_isbn
      inner join prod.STG_CLTS.PRODUCTS_V  t on t.isbn13 = iac.pp_isbn_13
      )


      , u_v as (
      select res_users.*
      , vital.*
      from res_users inner join  vital on res_users.user_sso_guid = vital.vs_user_sso_guid  ----------------------
      )

      , res as (
      select u_v.*,
      mt.*
      from u_v inner join  mt on mt.mt_user_sso_guid = u_v.user_sso_guid---------------

      union

      select u_v.*
      , u_v.user_sso_guid as mt_user_sso_guid
      , null as mt_event_time
      , null as mt_platform
      , null as mt_hash
      from u_v inner join mt on u_v.user_sso_guid = mt.mt_user_sso_guid
      where  mt.mt_user_sso_guid is null

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



  measure: p_h_v
  {
    type: number
    sql: case when ${count_vs} = 0 then 0 else 1 end ;;

  }

  dimension_group: mt_event_time {
    type: time
    sql: ${TABLE}."MT_EVENT_TIME" ;;
  }

  set:  vs_sum{
    fields: [date_c, id, subscription_state_u,  count_vs ]
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


  measure: p_h_mtr
  {
    type: number
    sql: case when(${id} like '%no_cu%' and ${count_mtr_e_boock} = 0) then 1 else (case when (${id} like '%no_cu%' and ${count_mtr_e_boock} > 0) then 0 else (case when ${count_mtr_e_boock} = 0 then 0 else 1 end ) end ) end ;;

  }

  set:  mtr_e_boock_sum{
    fields: [date_c, id, subscription_state_u, mt_session_id, mt_platform, count_mtr_e_boock]
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


  measure: p_h_aplia
  {
    type: number
    sql: case when(${id} like '%no_cu%' and ${count_aplia} = 0) then 1 else (case when (${id} like '%no_cu%' and ${count_aplia} > 0) then 0 else (case when ${count_aplia} = 0 then 0 else 1 end ) end ) end ;;

  }

  set:  aplia_sum{
    fields: [date_c, id, subscription_state_u, mt_session_id, mt_platform, count_aplia]
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



  measure: p_h_cnow
  {
    type: number
    sql: case when(${id} like '%no_cu%' and ${count_cnow} = 0) then 1 else (case when (${id} like '%no_cu%' and ${count_cnow} > 0) then 0 else (case when ${count_cnow} = 0 then 0 else 1 end ) end ) end ;;

  }


  set:  cnow_sum{
    fields: [date_c, id, subscription_state_u, mt_session_id, mt_platform, count_cnow]
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


  measure: p_h_mt
  {
    type: number
    sql: case when(${id} like '%no_cu%' and ${count_mt} = 0) then 1 else (case when (${id} like '%no_cu%' and ${count_mt} > 0) then 0 else (case when ${count_mt} = 0 then 0 else 1 end ) end ) end ;;

  }

  set:  mt_sum{
    fields: [date_c, id, subscription_state_u, mt_session_id,  mt_platform, count_mt]
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


  measure: p_h_wa
  {
    type: number
    sql: case when(${id} like '%no_cu%' and ${count_wa} = 0) then 1 else (case when (${id} like '%no_cu%' and ${count_wa} > 0) then 0 else (case when ${count_wa} = 0 then 0 else 1 end ) end ) end ;;

  }

  set:  wa_sum{
    fields: [date_c, id, subscription_state_u, mt_session_id,  mt_platform, count_wa]
  }


  measure: p_health
  {
    type: number
    sql: (${p_h_aplia} + ${p_h_cnow} +${p_h_mtr} + ${p_h_wa} + ${p_h_mt} + ${p_h_v}) / 6;;
    drill_fields: [detail*]

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

dimension: vital_sourse_event_hash {
  type: string
  sql: ${TABLE}."VITAL_SOURSE_EVENT_HASH" ;;
}

dimension: mt_user_sso_guid {
  type: string
  sql: ${TABLE}."MT_USER_SSO_GUID" ;;
}



dimension: mt_session_id {
  type: string
  sql: ${TABLE}."MT_SESSION_ID" ;;
}

dimension: mt_platform {
  type: string
  sql: ${TABLE}."MT_PLATFORM" ;;
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
    mt_user_sso_guid,
    mt_session_id,
    mt_platform
  ]
}
}
