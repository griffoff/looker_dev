view: a_p {
  derived_table: {
    sql: with products as (
      select pp.user_sso_guid as p_user_sso_guid
      , user_type as user_type
      , platform_environment as platform_environment
      , user_environment as user_environment
      , pp.local_time as prod_local_time
      , iac.pp_name as pp_name
      , iac.cp_name as cp_name
      from int.unlimited.RAW_OLR_PROVISIONED_PRODUCT as pp
      , int.unlimited.RAW_OLR_EXTENDED_IAC as iac
      where pp.iac_isbn = iac.pp_isbn_13
      )

      select * from products
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: p_user_sso_guid {
    type: string
    sql: ${TABLE}."P_USER_SSO_GUID" ;;
  }

  dimension: user_type {
    type: string
    sql: ${TABLE}."USER_TYPE" ;;
  }

  dimension: platform_environment {
    type: string
    sql: ${TABLE}."PLATFORM_ENVIRONMENT" ;;
  }

  dimension: user_environment {
    type: string
    sql: ${TABLE}."USER_ENVIRONMENT" ;;
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

  set: detail {
    fields: [
      p_user_sso_guid,
      user_type,
      platform_environment,
      user_environment,
      prod_local_time_time,
      pp_name,
      cp_name
    ]
  }
}
