view: a_p_p {
  derived_table: {
    sql: with products as (
      select pp.user_sso_guid as user_sso_guid
      , pp._hash as hash
      , pp.local_time as local_time
      , pp.iac_isbn as isbn
      , case when pp.source_id like 'TRIAL' then 'b' else case when pp.source_id is null then 'a' else 'c' end end as state
      from prod.unlimited.RAW_OLR_PROVISIONED_PRODUCT as pp

      )

      select * from products
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_e {
    type: count_distinct
    sql: ${user_sso_guid} ;;
  }

  dimension: user_sso_guid {
    type: string
    sql: ${TABLE}."USER_SSO_GUID" ;;
  }

  dimension: hash {
    type: string
    sql: ${TABLE}."HASH" ;;
  }

  dimension_group: local_time {
    type: time
    sql: ${TABLE}."LOCAL_TIME" ;;
  }

  dimension: isbn {
    type: string
    sql: ${TABLE}."ISBN" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  set: detail {
    fields: [user_sso_guid, hash, local_time_time, isbn, state]
  }
}
