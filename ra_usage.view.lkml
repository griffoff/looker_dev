view: ra_usage {
  derived_table: {
    sql: with users as (
      select guid as user_sso_guid,
      uid as id,
      SUBSCRIPTION_STATE as SUBSCRIPTION_STATE_u
      , CREATED_ON as date_c
      from prod.UNLIMITED.SCENARIO_DETAILS
      )

      , events as (
      select vs.user_sso_guid as user_sso_guid
      , u.id
      , u.date_c as date_c
      , 'SMEB' as product_platform
      , vs.vbid as isbn
      , vs.event_action as event_action
      , vs.event_time as event_time
      , (datediff(dd, date_c, event_time) + 1) as day_number
      , vs._hash as event_hash
      from ${cu_raw_vitalsource_event.SQL_TABLE_NAME}  vs inner join ${cu_raw_olr_extended_iac.SQL_TABLE_NAME} iac on iac.pp_isbn_13 = vs.vbid
      inner join users u on u.user_sso_guid = vs.user_sso_guid

      union

      select distinct m.user_identifier as user_sso_guid
      , u.id
      , u.date_c as date_c
      , case when t.platform like 'WebAssign' then 'WA'  when t.platform like 'MindTap Reader' then 'MTR' when t.platform like 'MindTap' then 'MTC' else t.platform end as product_platform
      , m.COMPONENT_ISBN as isbn
      , m.event_action as event_action
      , m.event_time as event_time
      , (datediff(dd, date_c, event_time) + 1) as day_number
      , m._hash as hash
      from ${cu_raw_olr_raw_mt_resource_interactions.SQL_TABLE_NAME} as m
      inner join users u on u.user_sso_guid = m.user_identifier
      inner join ${cu_raw_olr_extended_iac.SQL_TABLE_NAME} iac on m.component_isbn = iac.cp_isbn_13 or m.component_isbn = iac.pp_isbn_13
      inner join ${cu_raw_olr_provisioned_product.SQL_TABLE_NAME} pp on pp.user_sso_guid =  m.user_identifier and iac.pp_isbn_13 = pp.iac_isbn
      inner join ${cu_raw_olr_stg_clts_products_v.SQL_TABLE_NAME}  t on t.isbn13 = iac.pp_isbn_13
      )

      , in_join as (
      select distinct e.*
      , 'in join' as status
      , case when e.isbn = sa.component_isbn then 1 else 0 end as isbn_health
      , sa.component_isbn as sa_isbn
      , sa.event_action as sa_event_action
      , case when sa.SUCCESSFUL then 1 else 0 end as sa_SUCCESSFUL
      from events e inner join prod.UNLIMITED.SCENARIO_ACTIVITIES sa on to_date(e.event_time) = to_date(sa.CREATED_ON) and e.id = sa.uid and e.product_platform = sa.product_type and sa.event_action = e.event_action
      )

      select * from in_join

      union

      select distinct  e.*
      , 'not in join' as status
      , null as isbn_health
      , null as sa_isbn
      , null as sa_event_action
      , null as sa_SUCCESSFUL
      from events e left outer join in_join j on j.EVENT_HASH = e.EVENT_HASH
      where e.EVENT_HASH is null

      union

      select
       u.user_sso_guid as user_sso_guid
      , u.id
      , u.date_c as date_c
      , null as product_platform
      , null as isbn
      , null as event_action
      , null as event_time
      , -1 as day_number
      , null as event_hash
      , 'snowflake' as status
      , null as isbn_health
      , null as sa_isbn
      , null as sa_event_action
      , null as sa_SUCCESSFUL
      from users u left outer join prod.UNLIMITED.SCENARIO_ACTIVITIES a on a.uid = u.id
      where a.uid is null

      --select * from in_join where user_sso_guid like '3c74197cde8b38f2:-e6b3fb9:1666215619a:-4f2b' and to_date(event_time) like '2018-10-14'
 ;;
  }

  measure: count_all {
    type: count_distinct
    sql: ${event_hash} ;;
    drill_fields: [detail*]
  }

  measure: count_success {
    type: count_distinct
    filters: {
      field: status
      value: "in join"
    }
    filters: {
      field: isbn_health
      value: "1"
    }
    filters: {
      field: sa_successful
      value: "1"
    }
    sql: ${event_hash} ;;
    drill_fields: [detail*]
  }

  measure: count_success_broke_script {
    type: count_distinct
    filters: {
      field: status
      value: "in join"
    }
    filters: {
      field: isbn_health
      value: "1"
    }
    filters: {
      field: sa_successful
      value: "0"
    }
    sql: ${event_hash} ;;
    drill_fields: [detail*]
  }

  measure: count_success_broke_isbn {
    type: count_distinct
    filters: {
      field: status
      value: "in join"
    }
    filters: {
      field: isbn_health
      value: "0"
    }
    filters: {
      field: sa_successful
      value: "1"
    }
    sql: ${event_hash} ;;
    drill_fields: [detail*]
  }

  measure: count_success_broke_all {
    type: count_distinct
    filters: {
      field: status
      value: "in join"
    }
    filters: {
      field: isbn_health
      value: "0"
    }
    filters: {
      field: sa_successful
      value: "0"
    }
    sql: ${event_hash} ;;
    drill_fields: [detail*]
  }

  measure: count_fail {
    type: count_distinct
    filters: {
      field: status
      value: "not in join"
    }
    sql: ${event_hash} ;;
    drill_fields: [detail*]
  }

  dimension: user_sso_guid {
    type: string
    sql: ${TABLE}."USER_SSO_GUID" ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}."ID" ;;
  }

  dimension: date_c {
    type: date
    sql: ${TABLE}."DATE_C" ;;
  }

  dimension: product_platform {
    type: string
    sql: ${TABLE}."PRODUCT_PLATFORM" ;;
  }

  dimension: isbn {
    type: string
    sql: ${TABLE}."ISBN" ;;
  }

  dimension: event_action {
    type: string
    sql: ${TABLE}."EVENT_ACTION" ;;
  }

  dimension_group: event_time {
    type: time
    sql: ${TABLE}."EVENT_TIME" ;;
  }

  dimension: day_number {
    type: number
    sql: ${TABLE}."DAY_NUMBER" ;;
  }

  dimension: event_hash {
    type: string
    sql: ${TABLE}."EVENT_HASH" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: isbn_health {
    type: number
    sql: ${TABLE}."ISBN_HEALTH" ;;
  }

  dimension: sa_isbn {
    type: string
    sql: ${TABLE}."SA_ISBN" ;;
  }

  dimension: sa_event_action {
    type: string
    sql: ${TABLE}."SA_EVENT_ACTION" ;;
  }

  dimension: sa_successful {
    type: number
    sql: ${TABLE}."SA_SUCCESSFUL" ;;
  }

  set: detail {
    fields: [
      user_sso_guid,
      id,
      date_c,
      product_platform,
      isbn,
      event_action,
      event_time_time,
      day_number,
      event_hash,
      status,
      isbn_health,
      sa_isbn,
      sa_event_action,
      sa_successful
    ]
  }
}
