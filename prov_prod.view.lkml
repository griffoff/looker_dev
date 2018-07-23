view: prov_prod {
  derived_table: {
    sql: SELECT _LDTS, user_sso_guid FROM INT.UNLIMITED.RAW_OLR_PROVISIONED_PRODUCT
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

  set: detail {
    fields: [_ldts_time, user_sso_guid]
  }
}
