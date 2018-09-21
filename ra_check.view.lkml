view: ra_check {
 derived_table: {
  sql: select
      a.ldts as a_ldts
      , a.RSRC as a_rsrc
      , a.uid as a_uid
      , a.product_type as a_product_type
      , a.component_isbn as a_component_isbn
      , a.event_type as a_event_type
      , a.event_action as a_event_action
      , a.event_count as a_event_count
      , a.created_on as a_created_on
      , a.successful as a_successful
      , e.ldts as e_ldts
      , e.RSRC as e_rsrc
      , e.uid as e_uid
      , e.COURSE_KEY as e_course_key
      , e.enrollment_date as e_enrollment_date
      , e.created_on as e_created_on
      , e.successful as e_successful
      , p.ldts as p_ldts
      , p.RSRC as p_rsrc
      , p.uid as p_uid
      , p.product_type as p_product_type
      , p.component_isbn as p_component_isbn
      , p.iac_isbn as p_iac_isbn
      , p.created_on as p_created_on
      , p.successful as p_successful
      , s.ldts as s_ldts
      , s.RSRC as s_rsrc
      , s.uid as s_uid
      , s.contract_id as s_sontract_id
      , s.state as s_state
      , s.start_date as s_start_date
      , s.end_date as s_end_date
      , s.created_on as s_created_on
      , s.successful as s_successful
      , plan.LDTS as plan_LDTS
      , plan.RSRC as plan_RSRC
      , plan.GUID as plan_GUID
      , plan.UID as plan_UID
      , plan.SUBSCRIPTION_STATE as plan_SUBSCRIPTION_STATE
      , plan.SUBSCRIPTION_CONTRACT_ID as plan_SUBSCRIPTION_CONTRACT_ID
      , plan.COURSE_KEY as plan_COURSE_KEY
      , plan.MTR_ISBN as plan_MTR_ISBN
      , plan.VS_ISBN as plan_VS_ISBN
      , plan.APLIA_ISBN as plan_APLIA_ISBN
      , plan.APLIA_MTR_ISBN as plan_APLIA_MTR_ISBN
      , plan.CNOW_ISBN as plan_CNOW_ISBN
      , plan.CNOW_MTR_ISBN as plan_CNOW_MTR_ISBN
      , plan.WEBASSIGN_ISBN as plan_WEBASSIGN_ISBN
      , plan.WEBASSIGN_MTR_ISBN as plan_WEBASSIGN_MTR_ISBN
      , plan.MT_ISBN as plan_MT_ISBN
      , plan.CREATED_ON as  plan_CREATED_ON
      , plan.MT_MTC_ISBN as plan_MT_MTC_ISBN
      from int.UNLIMITED.SCENARIO_ACTIVITIES a
      inner join int.UNLIMITED.SCENARIO_ENROLLMENTS e on e.uid = a.uid
      inner join int.UNLIMITED.SCENARIO_PROVISIONING p on p.uid = a.uid
      inner join int.UNLIMITED.SCENARIO_SUBSCRIPTIONS s on s.uid = a.uid
      inner join int.UNLIMITED.SCENARIO_DETAILS as plan on plan.uid = a.uid
       ;;
}

measure: count {
  type: count
  drill_fields: [detail*]
}

dimension_group: a_ldts {
  type: time
  sql: ${TABLE}."A_LDTS" ;;
}

dimension: a_rsrc {
  type: string
  sql: ${TABLE}."A_RSRC" ;;
}

dimension: a_uid {
  type: string
  sql: ${TABLE}."A_UID" ;;
}

dimension: a_product_type {
  type: string
  sql: ${TABLE}."A_PRODUCT_TYPE" ;;
}

dimension: a_component_isbn {
  type: string
  sql: ${TABLE}."A_COMPONENT_ISBN" ;;
}

dimension: a_event_type {
  type: string
  sql: ${TABLE}."A_EVENT_TYPE" ;;
}

dimension: a_event_action {
  type: string
  sql: ${TABLE}."A_EVENT_ACTION" ;;
}

dimension: a_event_count {
  type: number
  sql: ${TABLE}."A_EVENT_COUNT" ;;
}

dimension: a_created_on {
  type: date
  sql: ${TABLE}."A_CREATED_ON" ;;
}

dimension: a_successful {
  type: string
  sql: ${TABLE}."A_SUCCESSFUL" ;;
}

dimension_group: e_ldts {
  type: time
  sql: ${TABLE}."E_LDTS" ;;
}

dimension: e_rsrc {
  type: string
  sql: ${TABLE}."E_RSRC" ;;
}

dimension: e_uid {
  type: string
  sql: ${TABLE}."E_UID" ;;
}

dimension: e_course_key {
  type: string
  sql: ${TABLE}."E_COURSE_KEY" ;;
}

dimension: e_enrollment_date {
  type: date
  sql: ${TABLE}."E_ENROLLMENT_DATE" ;;
}

dimension: e_created_on {
  type: date
  sql: ${TABLE}."E_CREATED_ON" ;;
}

dimension: e_successful {
  type: string
  sql: ${TABLE}."E_SUCCESSFUL" ;;
}

dimension_group: p_ldts {
  type: time
  sql: ${TABLE}."P_LDTS" ;;
}

dimension: p_rsrc {
  type: string
  sql: ${TABLE}."P_RSRC" ;;
}

dimension: p_uid {
  type: string
  sql: ${TABLE}."P_UID" ;;
}

dimension: p_product_type {
  type: string
  sql: ${TABLE}."P_PRODUCT_TYPE" ;;
}

dimension: p_component_isbn {
  type: string
  sql: ${TABLE}."P_COMPONENT_ISBN" ;;
}

dimension: p_iac_isbn {
  type: string
  sql: ${TABLE}."P_IAC_ISBN" ;;
}

dimension: p_created_on {
  type: date
  sql: ${TABLE}."P_CREATED_ON" ;;
}

dimension: p_successful {
  type: string
  sql: ${TABLE}."P_SUCCESSFUL" ;;
}

dimension_group: s_ldts {
  type: time
  sql: ${TABLE}."S_LDTS" ;;
}

dimension: s_rsrc {
  type: string
  sql: ${TABLE}."S_RSRC" ;;
}

dimension: s_uid {
  type: string
  sql: ${TABLE}."S_UID" ;;
}

dimension: s_sontract_id {
  type: string
  sql: ${TABLE}."S_SONTRACT_ID" ;;
}

dimension: s_state {
  type: string
  sql: ${TABLE}."S_STATE" ;;
}

dimension: s_start_date {
  type: date
  sql: ${TABLE}."S_START_DATE" ;;
}

dimension: s_end_date {
  type: date
  sql: ${TABLE}."S_END_DATE" ;;
}

dimension: s_created_on {
  type: date
  sql: ${TABLE}."S_CREATED_ON" ;;
}

dimension: s_successful {
  type: string
  sql: ${TABLE}."S_SUCCESSFUL" ;;
}

dimension_group: plan_ldts {
  type: time
  sql: ${TABLE}."PLAN_LDTS" ;;
}

dimension: plan_rsrc {
  type: string
  sql: ${TABLE}."PLAN_RSRC" ;;
}

dimension: plan_guid {
  type: string
  sql: ${TABLE}."PLAN_GUID" ;;
}

dimension: plan_uid {
  type: string
  sql: ${TABLE}."PLAN_UID" ;;
}

dimension: plan_subscription_state {
  type: string
  sql: ${TABLE}."PLAN_SUBSCRIPTION_STATE" ;;
}

dimension: plan_subscription_contract_id {
  type: string
  sql: ${TABLE}."PLAN_SUBSCRIPTION_CONTRACT_ID" ;;
}

dimension: plan_course_key {
  type: string
  sql: ${TABLE}."PLAN_COURSE_KEY" ;;
}

dimension: plan_mtr_isbn {
  type: string
  sql: ${TABLE}."PLAN_MTR_ISBN" ;;
}

dimension: plan_vs_isbn {
  type: string
  sql: ${TABLE}."PLAN_VS_ISBN" ;;
}

dimension: plan_aplia_isbn {
  type: string
  sql: ${TABLE}."PLAN_APLIA_ISBN" ;;
}

dimension: plan_aplia_mtr_isbn {
  type: string
  sql: ${TABLE}."PLAN_APLIA_MTR_ISBN" ;;
}

dimension: plan_cnow_isbn {
  type: string
  sql: ${TABLE}."PLAN_CNOW_ISBN" ;;
}

dimension: plan_cnow_mtr_isbn {
  type: string
  sql: ${TABLE}."PLAN_CNOW_MTR_ISBN" ;;
}

dimension: plan_webassign_isbn {
  type: string
  sql: ${TABLE}."PLAN_WEBASSIGN_ISBN" ;;
}

dimension: plan_webassign_mtr_isbn {
  type: string
  sql: ${TABLE}."PLAN_WEBASSIGN_MTR_ISBN" ;;
}

dimension: plan_mt_isbn {
  type: string
  sql: ${TABLE}."PLAN_MT_ISBN" ;;
}

dimension: plan_created_on {
  type: date
  sql: ${TABLE}."PLAN_CREATED_ON" ;;
}

dimension: plan_mt_mtc_isbn {
  type: string
  sql: ${TABLE}."PLAN_MT_MTC_ISBN" ;;
}

set: detail {
  fields: [
    a_ldts_time,
    a_rsrc,
    a_uid,
    a_product_type,
    a_component_isbn,
    a_event_type,
    a_event_action,
    a_event_count,
    a_created_on,
    a_successful,
    e_ldts_time,
    e_rsrc,
    e_uid,
    e_course_key,
    e_enrollment_date,
    e_created_on,
    e_successful,
    p_ldts_time,
    p_rsrc,
    p_uid,
    p_product_type,
    p_component_isbn,
    p_iac_isbn,
    p_created_on,
    p_successful,
    s_ldts_time,
    s_rsrc,
    s_uid,
    s_sontract_id,
    s_state,
    s_start_date,
    s_end_date,
    s_created_on,
    s_successful,
    plan_ldts_time,
    plan_rsrc,
    plan_guid,
    plan_uid,
    plan_subscription_state,
    plan_subscription_contract_id,
    plan_course_key,
    plan_mtr_isbn,
    plan_vs_isbn,
    plan_aplia_isbn,
    plan_aplia_mtr_isbn,
    plan_cnow_isbn,
    plan_cnow_mtr_isbn,
    plan_webassign_isbn,
    plan_webassign_mtr_isbn,
    plan_mt_isbn,
    plan_created_on,
    plan_mt_mtc_isbn
  ]
}
}
