view: sub_event_ {
  derived_table: {
    sql: SELECT SUBSCRIPTION_STATE, user_sso_guid, _LDTS, SUBSCRIPTION_END
      FROM INT.UNLIMITED.RAW_SUBSCRIPTION_EVENT
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

  dimension: user_sso_guid {
    type: string
    sql: ${TABLE}."USER_SSO_GUID" ;;
  }

  dimension_group: _ldts {
    type: time
    sql: ${TABLE}."_LDTS" ;;
  }

  dimension_group: subscription_end {
    type: time
    sql: ${TABLE}."SUBSCRIPTION_END" ;;
  }

  set: detail {
    fields: [subscription_state, user_sso_guid, _ldts_time, subscription_end_time]
  }
}
