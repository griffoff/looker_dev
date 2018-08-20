view: products_that_making__full {
 derived_table: {
  sql: with true_users as (
      select distinct sub.user_sso_guid as user
      from prod.UNLIMITED.RAW_SUBSCRIPTION_EVENT sub left outer join prod.unlimited.CLTS_EXCLUDED_USERS exc on sub.user_sso_guid = exc.user_sso_guid
      where exc.user_sso_guid is null
      and sub.USER_ENVIRONMENT like 'production'
      and sub.PLATFORM_ENVIRONMENT like 'production'
      and sub.contract_id <> 'stuff'
      and sub.contract_id <> 'Testuser'
      group by user
      )

      , min_dates as(
      select user_sso_guid
      , subscription_state
      , min(local_time)  as  local_time
      from prod.UNLIMITED.RAW_SUBSCRIPTION_EVENt
      inner join true_users t on t.user = user_sso_guid
      group by user_sso_guid, subscription_state
      )

      , trial as (
      select distinct sub.user_sso_guid
      , m.local_time
      , sub.SUBSCRIPTION_START
      , sub.SUBSCRIPTION_END
      , sub.SUBSCRIPTION_STATE
      , sub.CONTRACT_ID
      from prod.UNLIMITED.RAW_SUBSCRIPTION_EVENT sub
      inner join true_users t on t.user = sub.user_sso_guid
      inner join min_dates m on m.user_sso_guid = sub.user_sso_guid and m.local_time = sub.local_time
      where sub.SUBSCRIPTION_STATE like 'trial_access'
      and m.subscription_state like 'trial_access'

      )

      , _full as (
      select distinct sub.user_sso_guid
      , m.local_time
      , sub.SUBSCRIPTION_START
      , sub.SUBSCRIPTION_END
      , sub.SUBSCRIPTION_STATE
      , sub.CONTRACT_ID
      from prod.UNLIMITED.RAW_SUBSCRIPTION_EVENT sub
      inner join true_users t on t.user = sub.user_sso_guid
      inner join min_dates m on m.user_sso_guid = sub.user_sso_guid and m.local_time = sub.local_time
      where sub.SUBSCRIPTION_STATE like 'full_access'
      and m.subscription_state like 'full_access'

      )
      , two_state as (
      select distinct _full.user_sso_guid
      , to_date(_full.local_time) as time
      , to_date(_full.SUBSCRIPTION_START) as _start
      , to_date(_full.SUBSCRIPTION_END) as _end
      , _full.SUBSCRIPTION_STATE
      , _full.CONTRACT_ID
      , 'Full Access - Upgraded' as status
      , case when _full.user_sso_guid in (select user_guid from prod.STG_CLTS.ACTIVATIONS_OLR_V where actv_isbn in ('9780357700006','9780357700013','9780357700020')) then 'PAC' else 'Commerce' end as paid_status
      from _full
      inner join trial t on t.User_sso_guid = _full.user_sso_guid
      )

, f as (SELECT user_sso_guid
, min(LOCAL_TIME) as _time
FROM prod.UNLIMITED.RAW_OLR_PROVISIONED_PRODUCT
where user_environment like 'production'
and PLATFORM_ENVIRONMENT like 'production'
group by user_sso_guid

)

, f_id as (
select distinct f.user_sso_guid
, f._time
, p.product_id
, iac.pp_name
, t.paid_status
from f inner join prod.UNLIMITED.RAW_OLR_PROVISIONED_PRODUCT p on f.user_sso_guid = p.user_sso_guid and f._time = p.local_time
inner join prod.UNLIMITED.RAW_OLR_EXTENDED_IAC iac on p.product_id = iac.pp_pid
inner join two_state t on t.user_sso_guid = f.user_sso_guid
)



select * from f_id
 ;;
}

measure: count {
  type: count
  drill_fields: [detail*]
}

measure: count_all {
  type:  count_distinct
  sql: ${user_sso_guid} ;;
  drill_fields: [detail*]
}


  measure: count_pac {
    type:  count_distinct
    filters: {
      field: paid_status
      value: "PAC"
    }
    sql: ${user_sso_guid} ;;
    drill_fields: [detail*]
  }


  measure: count_commerce {
    type:  count_distinct
    filters: {
      field: paid_status
      value: "Commerce"
    }
    sql: ${user_sso_guid} ;;
    drill_fields: [detail*]
  }

dimension: user_sso_guid {
  type: string
  sql: ${TABLE}."USER_SSO_GUID" ;;
}

dimension_group: _time {
  type: time
  sql: ${TABLE}."_TIME" ;;
}

dimension: product_id {
  type: string
  sql: ${TABLE}."PRODUCT_ID" ;;
}

dimension: pp_name {
  type: string
  sql: ${TABLE}."PP_NAME" ;;
}

dimension: paid_status {
  type: string
  sql: ${TABLE}."PAID_STATUS" ;;
}

set: detail {
  fields: [user_sso_guid, _time_time, product_id, pp_name, paid_status]
}
}
