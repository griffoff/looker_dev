view: enroll {
 derived_table: {
  sql: SELECT  _ldts
      , user_sso_guid
      , access_role
      FROM  INT.UNLIMITED.RAW_OLR_ENROLLMENT
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

dimension: access_role {
  type: string
  sql: ${TABLE}."ACCESS_ROLE" ;;
}

set: detail {
  fields: [_ldts_time, user_sso_guid, access_role]
}
}
