view: vital_sourse {
  derived_table: {
    sql: SELECT vs._LDTS, vs.user_sso_guid, vs.event_type, vs.event_action, vs.VBID, b.pp_name
      FROM INT.UNLIMITED.RAW_VITALSOURCE_EVENT as vs
      , INT.UNLIMITED.RAW_OLR_EXTENDED_IAC as b
      where b.pp_isbn_13 = vs.VBID
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: _ldts {
    type: time
    sql: ${TABLE}."_LDTS" ;;
  }

  dimension: user_sso_guid {
    type: string
    sql: ${TABLE}."USER_SSO_GUID" ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}."EVENT_TYPE" ;;
  }

  dimension: event_action {
    type: string
    sql: ${TABLE}."EVENT_ACTION" ;;
  }

  dimension: vbid {
    type: string
    sql: ${TABLE}."VBID" ;;
  }

  dimension: pp_name {
    type: string
    sql: ${TABLE}."PP_NAME" ;;
  }

  set: detail {
    fields: [
      _ldts_time,
      user_sso_guid,
      event_type,
      event_action,
      vbid,
      pp_name
    ]
  }
}
