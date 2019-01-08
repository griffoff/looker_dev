view: prov_prod {
 derived_table: {
  sql: with good as
      (SELECT
      sp.uid as uid
      , sp.product_type as product_type
      , sp.component_isbn as e_component_isbn
      , sp.iac_isbn as iac_isbn
      , sp.created_on as prov_date
      , sp.successful as successful
      , sd.guid as user_sso_guid
      , sd.subscription_state as subscription_state
      , 'good' as status
      FROM UNLIMITED.SCENARIO_PROVISIONING sp
      inner join UNLIMITED.SCENARIO_DETAILS sd on sp.uid = sd.uid
      inner join UNLIMITED.RAW_OLR_ENROLLMENT e on e.user_sso_guid = sd.guid
      inner join UNLIMITED.RAW_OLR_PROVISIONED_PRODUCT pp on pp.user_sso_guid = sd.guid and to_date(pp.local_time) = sp.created_on and pp.iac_isbn = sp.iac_isbn
      )

      , bad as
      (
      select
      sp.uid as uid
      , sp.product_type as product_type
      , sp.component_isbn as e_component_isbn
      , sp.iac_isbn as iac_isbn
      , sp.created_on as prov_date
      , sp.successful as successful
      , sd.guid as user_sso_guid
      , sd.subscription_state as subscription_state
      , case when sd.subscription_state like 'trial_access' and sp.product_type like 'MTC' then 'good' else 'bad' end  as status
      FROM UNLIMITED.SCENARIO_PROVISIONING sp
      inner join UNLIMITED.SCENARIO_DETAILS sd on sp.uid = sd.uid
      left outer join good g on g.uid = sp.uid and g.product_type = sp.product_type and g.iac_isbn = sp.iac_isbn
      where (g.uid is null or g.product_type is null or g.iac_isbn is null)
      and sp.uid not like '%no_cu%'

      )

      , res as (
      select * from good

      union

      select * from bad

      )

      select *
      , case when product_type like 'WA' then 'WebAssign' when product_type like 'SMEB' then 'Standalone Academic eBook' when product_type like 'MTR' then 'MindTap Reader' when product_type like 'MTC' then 'MindTap' when product_type like 'CNOW' then 'CNOW' when product_type like 'APLIA' then 'Aplia' end as b_product_type
      from res
       ;;
}

measure: count {
  type: count
  drill_fields: [detail*]
}

measure: count_good {
  type: count
  filters: {
    field: status
    value: "good"
  }
  drill_fields: [detail*]
}
  measure: count_bad {
    type: count
    filters: {
      field: status
      value: "bad"
    }
    drill_fields: [detail*]
  }
dimension: uid {
  type: string
  sql: ${TABLE}."UID" ;;
}

dimension: product_type {
  type: string
  sql: ${TABLE}."PRODUCT_TYPE" ;;
}

dimension: e_component_isbn {
  type: string
  sql: ${TABLE}."E_COMPONENT_ISBN" ;;
}

dimension: iac_isbn {
  type: string
  sql: ${TABLE}."IAC_ISBN" ;;
}

dimension: prov_date {
  type: date
  sql: ${TABLE}."PROV_DATE" ;;
}

dimension: successful {
  type: string
  sql: ${TABLE}."SUCCESSFUL" ;;
}

dimension: user_sso_guid {
  type: string
  sql: ${TABLE}."USER_SSO_GUID" ;;
}

dimension: subscription_state {
  type: string
  sql: ${TABLE}."SUBSCRIPTION_STATE" ;;
}

dimension: status {
  type: string
  sql: ${TABLE}."STATUS" ;;
}

dimension: b_product_type {
  type: string
  sql: ${TABLE}."B_PRODUCT_TYPE" ;;
}

set: detail {
  fields: [
    uid,
    product_type,
    e_component_isbn,
    iac_isbn,
    prov_date,
    successful,
    user_sso_guid,
    subscription_state,
    status,
    b_product_type
  ]
}
}
