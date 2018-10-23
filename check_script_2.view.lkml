view: check_script_2 {
  derived_table: {
    sql: select distinct
        sd.created_on as created_on
        , sd.guid as user_sso_guid
        , sd.uid as id
        , sd.course_key as expected_course_key
        , sd.subscription_state as expected_subscription_state
        , sd.SUBSCRIPTION_CONTRACT_ID as expected_contract_id
        , e._hash as en_hash
        , e.course_key as actual_course_key
        , case when e.course_key = sd.course_key then 1 else 0 end as en_health
        , ls.SUBSCRIPTION_STATE as actual_SUBSCRIPTION_STATE
        , ls.CONTRACT_ID as actual_CONTRACT_ID
        , case when actual_CONTRACT_ID = expected_contract_id then 1 else 0 end as cid_health
        , case when expected_subscription_state = actual_SUBSCRIPTION_STATE then 1 else 0 end as sst_health
        from prod.UNLIMITED.SCENARIO_DETAILS sd
        inner join prod.UNLIMITED.RAW_OLR_ENROLLMENT e on sd.guid = e.user_sso_guid
        inner join prod.UNLIMITED.VW_IPM_LATEST_SUBSCRIPTION ls on sd.guid = ls.user_sso_guid
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_success {
    type: sum
    drill_fields: [detail*]
    sql: (${cid_health} + ${en_health} + ${sst_health}) ;;
  }

  measure: total_fail {
    type: sum
    drill_fields: [detail*]
    sql: 3 - (${cid_health} + ${en_health} + ${sst_health}) ;;
  }

  measure: health {
    type: sum
    sql: 100 * ((${cid_health} + ${en_health} + ${sst_health}) / 3);;
  }


  dimension: created_on {
    type: date
    sql: ${TABLE}."CREATED_ON" ;;
  }

  dimension: user_sso_guid {
    type: string
    sql: ${TABLE}."USER_SSO_GUID" ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}."ID" ;;
  }

  dimension: expected_course_key {
    type: string
    sql: ${TABLE}."EXPECTED_COURSE_KEY" ;;
  }

  dimension: expected_subscription_state {
    type: string
    sql: ${TABLE}."EXPECTED_SUBSCRIPTION_STATE" ;;
  }

  dimension: expected_contract_id {
    type: string
    sql: ${TABLE}."EXPECTED_CONTRACT_ID" ;;
  }

  dimension: en_hash {
    type: string
    sql: ${TABLE}."EN_HASH" ;;
  }

  dimension: actual_course_key {
    type: string
    sql: ${TABLE}."ACTUAL_COURSE_KEY" ;;
  }

  dimension: en_health {
    type: number
    sql: ${TABLE}."EN_HEALTH" ;;
  }

  dimension: actual_subscription_state {
    type: string
    sql: ${TABLE}."ACTUAL_SUBSCRIPTION_STATE" ;;
  }

  dimension: actual_contract_id {
    type: string
    sql: ${TABLE}."ACTUAL_CONTRACT_ID" ;;
  }

  dimension: cid_health {
    type: number
    sql: ${TABLE}."CID_HEALTH" ;;
  }

  dimension: sst_health {
    type: number
    sql: ${TABLE}."SST_HEALTH" ;;
  }

  set: detail {
    fields: [
      created_on,
      user_sso_guid,
      id,
      expected_course_key,
      expected_subscription_state,
      expected_contract_id,
      en_hash,
      actual_course_key,
      en_health,
      actual_subscription_state,
      actual_contract_id,
      cid_health,
      sst_health
    ]
  }
}
