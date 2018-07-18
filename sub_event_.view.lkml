view: sub_event_ {
  derived_table: {
    sql: SELECT SUBSCRIPTION_STATE
      , count (SUBSCRIPTION_STATE)
      FROM UNLIMITED.RAW_SUBSCRIPTION_EVENT
      where datediff(dd, _LDTS, current_date()) < 1
      group by SUBSCRIPTION_STATE
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: subscription_state {
    type: string
    sql: ${TABLE}."SUBSCRIPTION_STATE" ;;
  }

  dimension: count_subscription_state {
    type: number
    label: "COUNT (SUBSCRIPTION_STATE)"
    sql: ${TABLE}."COUNT (SUBSCRIPTION_STATE)" ;;
  }

  set: detail {
    fields: [subscription_state, count_subscription_state]
  }
}
