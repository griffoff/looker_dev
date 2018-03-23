view: activations_olr_v {
    #sql_table_name: STG_CLTS.ACTIVATIONS_OLR_V ;;
  derived_table: {
    sql:
      SELECT activations_olr.source, actv_trial_purchase,
      activations_olr.actv_olr_id, actv_dt,
      code_source, platform, actv_isbn,
      context_id, activations_olr.user_guid,
      actv_entity_id, actv_entity_name,
      actv_user_type, actv_region,
      actv_count, code_type,
      actv_code
      FROM stg_clts.activations_olr WHERE activations_olr.in_actv_flg = 1
      GROUP BY activations_olr.source, activations_olr.actv_trial_purchase,
      activations_olr.actv_olr_id, activations_olr.actv_dt,
      code_source, activations_olr.platform, activations_olr.actv_isbn,
      activations_olr.context_id, activations_olr.user_guid,
      activations_olr.actv_entity_id, activations_olr.actv_entity_name,
      activations_olr.actv_user_type, activations_olr.actv_region,
      activations_olr.actv_count, activations_olr.code_type,
      activations_olr.actv_code
        ;;
  }

    set: activation_details {
      fields: [actv_code, actv_dt_date, actv_entity_name, actv_user_type, actv_region, platform, code_type]
    }

  dimension: actv_code {
    type: string
    sql: ${TABLE}.ACTV_CODE ;;
    primary_key: yes
  }

  dimension: actv_count {
    label: "Activation count"
    type: number
    sql: ${TABLE}.ACTV_COUNT ;;
  }


  dimension_group: actv_dt {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      day_of_month,
      month_num
    ]
    convert_tz: no
    sql: ${TABLE}.ACTV_DT ;;
  }

  dimension: actv_datekey  {
    type: number
    sql: ${actv_dt_year}*10000 + ${actv_dt_month_num}*100 + ${actv_dt_day_of_month} ;;
  }

  dimension: actv_entity_id {
    type: string
    sql: ${TABLE}.ACTV_ENTITY_ID ;;
  }

  dimension: actv_entity_name {
    #description: "!"
    type: string
    sql: ${TABLE}.ACTV_ENTITY_NAME ;;
  }

  dimension: actv_isbn {
    type: string
    sql: ${TABLE}.ACTV_ISBN ;;
  }

  dimension: actv_region {
    #description: "!"
    type: string
    sql: ${TABLE}.ACTV_REGION ;;
  }

  dimension: actv_trial_purchase {
    type: string
    sql: ${TABLE}.ACTV_TRIAL_PURCHASE ;;
  }

  dimension: actv_user_type {
    #description: "!"
    type: string
    sql: ${TABLE}.ACTV_USER_TYPE ;;
  }

  dimension: code_source {
    type: string
    sql: ${TABLE}.CODE_SOURCE ;;
  }

  dimension: code_type {
    #description: "!"
    type: string
    sql: ${TABLE}.CODE_TYPE ;;
  }

  dimension: context_id {
    type: string
    sql: ${TABLE}.CONTEXT_ID ;;
  }

  dimension: platform {
    description: "Top platform is one of 'MindTap','SSO/OLR','CL Homework','DevMath','Gradebook','Mobile','MindTap Reader','CNOW','CNOW MindApp','CNOW v7','CNOW v8','Aplia','CXP','OWL V2','CourseMate','SAM','4LTR Online','CengageBrain.com','SSO Account Services', 'WebAssign', 'MyCengage', 'AUS - Nelsonnet'"
    type: string
    sql: ${TABLE}.PLATFORM ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.SOURCE ;;
  }

  dimension:topSystem {
    description: "Top platform is one of 'MindTap','SSO/OLR','CL Homework','DevMath','Gradebook','Mobile','MindTap Reader','CNOW','CNOW MindApp','CNOW v7','CNOW v8','Aplia','CXP','OWL V2','CourseMate','SAM','4LTR Online','CengageBrain.com','SSO Account Services', 'WebAssign', 'MyCengage', 'AUS - Nelsonnet'"
    type: yesno
    sql: platform in ('MindTap','SSO/OLR','CL Homework','DevMath','Gradebook','Mobile','MindTap Reader','CNOW','CNOW MindApp','CNOW v7','CNOW v8','Aplia','CXP','OWL V2','CourseMate','SAM','4LTR Online','CengageBrain.com','SSO Account Services', 'WebAssign', 'MyCengage', 'AUS - Nelsonnet') ;;
  }

  dimension: user_guid {
    type: string
    sql: ${TABLE}.USER_GUID ;;
  }

  measure: count {
    # description:"Count distinct activation code"
    label: "Record count"
    type: count_distinct
    sql: ${actv_code} ;;
    drill_fields: [activation_details*]
  }

  }
