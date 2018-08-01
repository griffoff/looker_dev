view: a_p_p {
  derived_table: {
    sql: with products as (
      select pp.user_sso_guid as p_user_sso_guid
      , pp._hash as hash
      , pp.local_time as prod_local_time
      , iac.pp_name as pp_name
      , iac.cp_name as cp_name
      , se.subscription_state as subscription_state
      , se.subscription_start as subscription_start
      , se.subscription_end as subscription_end
      from prod.unlimited.RAW_OLR_PROVISIONED_PRODUCT as pp
      ,prod.unlimited.RAW_SUBSCRIPTION_EVENT as se
      , prod.unlimited.RAW_OLR_EXTENDED_IAC as iac
      where pp.iac_isbn = iac.pp_isbn_13
      and se.user_sso_guid = p_user_sso_guid
      and subscription_end > prod_local_time
      and subscription_start < prod_local_time
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
    sql: ${hash} ;;
  }

  dimension: p_user_sso_guid {
    type: string
    sql: ${TABLE}."P_USER_SSO_GUID" ;;
  }

  dimension: hash {
    type: string
    sql: ${TABLE}."HASH" ;;
  }

  dimension_group: prod_local_time {
    type: time
    sql: ${TABLE}."PROD_LOCAL_TIME" ;;
  }

  dimension: pp_name {
    type: string
    sql: ${TABLE}."PP_NAME" ;;
  }

  dimension: cp_name {
    type: string
    sql: ${TABLE}."CP_NAME" ;;
  }

  dimension: subscription_state {
    type: string
    sql: ${TABLE}."SUBSCRIPTION_STATE" ;;
  }

  dimension_group: subscription_start {
    type: time
    sql: ${TABLE}."SUBSCRIPTION_START" ;;
  }

  dimension_group: subscription_end {
    type: time
    sql: ${TABLE}."SUBSCRIPTION_END" ;;
  }

  set: detail {
    fields: [
      p_user_sso_guid,
      hash,
      prod_local_time_time,
      pp_name,
      cp_name,
      subscription_state,
      subscription_start_time,
      subscription_end_time
    ]
  }
}
