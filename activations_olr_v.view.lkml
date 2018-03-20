view: activations_olr_v {
    sql_table_name: STG_CLTS.ACTIVATIONS_OLR_V ;;

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
    description: "!"
    type: string
    sql: ${TABLE}.ACTV_ENTITY_NAME ;;
  }

  dimension: actv_isbn {
    type: string
    sql: ${TABLE}.ACTV_ISBN ;;
  }

  dimension: actv_region {
    description: "!"
    type: string
    sql: ${TABLE}.ACTV_REGION ;;
  }

  dimension: actv_trial_purchase {
    type: string
    sql: ${TABLE}.ACTV_TRIAL_PURCHASE ;;
  }

  dimension: actv_user_type {
    description: "!"
    type: string
    sql: ${TABLE}.ACTV_USER_TYPE ;;
  }

  dimension: code_type {
    description: "!"
    type: string
    sql: ${TABLE}.CODE_TYPE ;;
  }

  dimension: context_id {
    type: string
    sql: ${TABLE}.CONTEXT_ID ;;
  }

  dimension: entity_no {
    type: string
    sql: ${TABLE}.ENTITY_NO ;;
  }

  dimension: platform {
    description: "!"
    type: string
    sql: ${TABLE}.PLATFORM ;;
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
  # # You can specify the table name if it's different from the view name:
  # sql_table_name: my_schema_name.tester ;;
  #
  # # Define your dimensions and measures here, like this:
  # dimension: user_id {
  #   description: "Unique ID for each user that has ordered"
  #   type: number
  #   sql: ${TABLE}.user_id ;;
  # }
  #
  # dimension: lifetime_orders {
  #   description: "The total number of orders for each user"
  #   type: number
  #   sql: ${TABLE}.lifetime_orders ;;
  # }
  #
  # dimension_group: most_recent_purchase {
  #   description: "The date when each user last ordered"
  #   type: time
  #   timeframes: [date, week, month, year]
  #   sql: ${TABLE}.most_recent_purchase_at ;;
  # }
  #
  # measure: total_lifetime_orders {
  #   description: "Use this for counting lifetime orders across many users"
  #   type: sum
  #   sql: ${lifetime_orders} ;;
  # }
#}

# view: activations_olr_v {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
