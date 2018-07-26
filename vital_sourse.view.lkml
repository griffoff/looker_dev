view: vital_sourse {
derived_table: {
  sql: with fa as (
      select guid as user_sso_guid,
      uid as id,
      SUBSCRIPTION_STATE as SUBSCRIPTION_STATE_u,
      SUBSCRIPTION_CONTRACT_ID as SUBSCRIPTION_CONTRACT_ID,
      COURSE_KEY as COURSE_KEY,
      VS_ISBN as vbid
      , CREATED_ON as date_c
      from int.UNLIMITED.SCENARIO_DETAILS
      WHERE CONTAINS(id, 'full_access')
      --and CREATED_ON = (select max(CREATED_ON) from int.UNLIMITED.SCENARIO_DETAILS)
      and CREATED_ON = '2018-07-19'
      )
      , ta as (
      select guid as user_sso_guid,
      uid as id,
      SUBSCRIPTION_STATE as SUBSCRIPTION_STATE_u,
      SUBSCRIPTION_CONTRACT_ID as SUBSCRIPTION_CONTRACT_ID,
      COURSE_KEY as COURSE_KEY,
      VS_ISBN as vbid
      , CREATED_ON as date_c
      from int.UNLIMITED.SCENARIO_DETAILS
      WHERE CONTAINS(id, 'trial_access')
      --and CREATED_ON = (select max(CREATED_ON) from int.UNLIMITED.SCENARIO_DETAILS)
      and CREATED_ON = '2018-07-19'
      )
      , na as (
      select guid as user_sso_guid,
      uid as id,
      SUBSCRIPTION_STATE as SUBSCRIPTION_STATE_u,
      SUBSCRIPTION_CONTRACT_ID as SUBSCRIPTION_CONTRACT_ID,
      COURSE_KEY as COURSE_KEY,
      VS_ISBN as vbid
      , CREATED_ON as date_c
      from int.UNLIMITED.SCENARIO_DETAILS
      WHERE CONTAINS(id, 'no_cu')
      --and CREATED_ON = (select max(CREATED_ON) from int.UNLIMITED.SCENARIO_DETAILS)
      and CREATED_ON = '2018-07-19'
      )
      , res_users as(
      select * from fa
      union
      select * from ta
      union
      select * from na
      )
      , res as(

      select vs.event_action as event_action
      , b.pp_name as name
      , res_users.id as id
      , pp_isbn_13 as isbn
      , res_users.vbid as vbid
      , vs.event_id
      , case when isbn = res_users.vbid then 1 else 0 end as check_res
      , case when CONTAINS(id, 'full_access') then 1 else (case when CONTAINS(id, 'trial') then 2 else 3 end )end as iddd
      from int.unlimited.RAW_VITALSOURCE_EVENT as vs
      , int.unlimited.RAW_OLR_EXTENDED_IAC as b
      , res_users
      where res_users.user_sso_guid = vs.user_sso_guid
      and vs.vbid = b.pp_isbn_13

      )

      select * from res
       ;;
}

measure: count {
  type: count
  drill_fields: [detail*]
}

dimension: event_action {
  type: string
  sql: ${TABLE}."EVENT_ACTION" ;;
}

dimension: name {
  type: string
  sql: ${TABLE}."NAME" ;;
}

dimension: id {
  type: string
  sql: ${TABLE}."ID" ;;
}

dimension: isbn {
  type: string
  sql: ${TABLE}."ISBN" ;;
}

dimension: vbid {
  type: string
  sql: ${TABLE}."VBID" ;;
}

dimension: event_id {
  type: string
  sql: ${TABLE}."EVENT_ID" ;;
}

dimension: check_res {
  type: number
  sql: ${TABLE}."CHECK_RES" ;;
}

dimension: iddd {
  type: number
  sql: ${TABLE}."IDDD" ;;
}

set: detail {
  fields: [
    event_action,
    name,
    id,
    isbn,
    vbid,
    event_id,
    check_res,
    iddd
  ]
}
}
