view: cs_m {
 derived_table: {
  sql: with  enrollment as (
      select user_sso_guid as e_user_sso_guid
      , local_time as enrollment_local_time
      , access_role as enrollment_access_role
      from int.unlimited.RAW_OLR_ENROLLMENT
      )
      , subscription as (
      select user_sso_guid as s_user_sso_guid
      , local_time as subscription_local_time
      , subscription_state as subscription_state
      from int.unlimited.RAW_SUBSCRIPTION_EVENT
      )
      , products as (
      select pp.user_sso_guid as p_user_sso_guid
      , pp.local_time as prod_local_time
      , iac.pp_name as pp_name
      , iac.cp_name as cp_name
      from int.unlimited.RAW_OLR_PROVISIONED_PRODUCT as pp
      , int.unlimited.RAW_OLR_EXTENDED_IAC as iac
      where pp.iac_isbn = iac.pp_isbn_13
      )
      , res as (
      select enrollment.*
      , subscription.*
      , products.*
      from enrollment, subscription, products
      where enrollment.e_user_sso_guid = subscription.s_user_sso_guid
      and subscription.s_user_sso_guid = products.p_user_sso_guid

      )

      select * from res
       ;;
}

measure: count {
  type: count
  drill_fields: [detail*]
}

measure:  count_sub{
  type: count_distinct
  sql: ${e_user_sso_guid} ;;
}

dimension: e_user_sso_guid {
  type: string
  sql: ${TABLE}."E_USER_SSO_GUID" ;;
}

dimension_group: enrollment_local_time {
  type: time
  sql: ${TABLE}."ENROLLMENT_LOCAL_TIME" ;;
}

dimension: enrollment_access_role {
  type: string
  sql: ${TABLE}."ENROLLMENT_ACCESS_ROLE" ;;
}

dimension: s_user_sso_guid {
  type: string
  sql: ${TABLE}."S_USER_SSO_GUID" ;;
}

dimension_group: subscription_local_time {
  type: time
  sql: ${TABLE}."SUBSCRIPTION_LOCAL_TIME" ;;
}

dimension: subscription_state {
  type: string
  sql: ${TABLE}."SUBSCRIPTION_STATE" ;;
}

dimension: p_user_sso_guid {
  type: string
  sql: ${TABLE}."P_USER_SSO_GUID" ;;
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
    e_user_sso_guid,
    enrollment_local_time_time,
    enrollment_access_role,
    s_user_sso_guid,
    subscription_local_time_time,
    subscription_state,
    p_user_sso_guid,
    prod_local_time_time,
    pp_name,
    cp_name
  ]
}
}
