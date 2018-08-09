view: a_actv_problem {
  derived_table: {
    sql: SELECT * FROM prod.STG_CLTS.ACTIVATIONS_OLR_V
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: ldts {
    type: time
    sql: ${TABLE}."LDTS" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: actv_trial_purchase {
    type: string
    sql: ${TABLE}."ACTV_TRIAL_PURCHASE" ;;
  }

  dimension: actv_olr_id {
    type: number
    sql: ${TABLE}."ACTV_OLR_ID" ;;
  }

  dimension: actv_dt {
    type: date
    sql: ${TABLE}."ACTV_DT" ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}."PLATFORM" ;;
  }

  dimension: actv_isbn {
    type: string
    sql: ${TABLE}."ACTV_ISBN" ;;
  }

  dimension: context_id {
    type: string
    sql: ${TABLE}."CONTEXT_ID" ;;
  }

  dimension: user_guid {
    type: string
    sql: ${TABLE}."USER_GUID" ;;
  }

  dimension: actv_entity_id {
    type: string
    sql: ${TABLE}."ACTV_ENTITY_ID" ;;
  }

  dimension: actv_entity_name {
    type: string
    sql: ${TABLE}."ACTV_ENTITY_NAME" ;;
  }

  dimension: actv_user_type {
    type: string
    sql: ${TABLE}."ACTV_USER_TYPE" ;;
  }

  dimension: actv_region {
    type: string
    sql: ${TABLE}."ACTV_REGION" ;;
  }

  dimension: actv_count {
    type: number
    sql: ${TABLE}."ACTV_COUNT" ;;
  }

  dimension: code_type {
    type: string
    sql: ${TABLE}."CODE_TYPE" ;;
  }

  dimension: actv_code {
    type: string
    sql: ${TABLE}."ACTV_CODE" ;;
  }

  dimension: pac_isbn {
    type: string
    sql: ${TABLE}."PAC_ISBN" ;;
  }

  set: detail {
    fields: [
      ldts_time,
      source,
      actv_trial_purchase,
      actv_olr_id,
      actv_dt,
      platform,
      actv_isbn,
      context_id,
      user_guid,
      actv_entity_id,
      actv_entity_name,
      actv_user_type,
      actv_region,
      actv_count,
      code_type,
      actv_code,
      pac_isbn
    ]
  }
}
