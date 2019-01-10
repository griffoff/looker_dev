view: ra_usage {
  derived_table: {
    sql: with users as (
      select sa.uid as id
      , sd.guid as guid
      , sa.product_type as product_type
      , sd.CREATED_ON as date_c
      , sa.COMPONENT_ISBN as COMPONENT_ISBN
      --, (datediff(dd, sd.CREATED_ON, sa.created_on) + 1) as day_number
      from prod.UNLIMITED.SCENARIO_ACTIVITIES sa inner join prod.UNLIMITED.SCENARIO_DETAILS sd on sa.uid = sd.uid
      )

      , events as (
      select vs.user_sso_guid as user_sso_guid
      , u.id
      , u.date_c
      , 'SMEB' as product_platform
      , vs.vbid as isbn
      , vs.event_action as event_action
      , to_date(vs.event_time) as event_time
      , (datediff(dd, date_c, event_time) + 1) as day_number
      , vs._hash as event_hash
      from prod.UNLIMITED.RAW_VITALSOURCE_EVENT vs inner join UNLIMITED.RAW_OLR_EXTENDED_IAC iac on iac.pp_isbn_13 = vs.vbid
      inner join users u on u.guid = vs.user_sso_guid

      union

      select distinct m.user_identifier as user_sso_guid
      , u.id
      , u.date_c
      , u.product_type as product_platform
      , m.COMPONENT_ISBN as isbn
      , m.event_action as event_action
      , to_date(m.event_time) as event_time
      , (datediff(dd, date_c, event_time) + 1) as day_number
      , m._hash as event_hash
      from cap_er.prod.RAW_MT_RESOURCE_INTERACTIONS as m
      inner join users u on u.guid = m.user_identifier and u.COMPONENT_ISBN = m.COMPONENT_ISBN
      )

      , counts as(
      select e.id
      , to_date(e.event_time) as event_time
      , e.product_platform
      , e.event_action
      , count(distinct e.event_hash) event_count
      from events e
      group by
      e.id
      , to_date(e.event_time)
      , e.product_platform
      , e.event_action
      )

      , counts_validation as(
      select c.id
      , c.event_time
      , c.product_platform
      , c.event_action
      , c.event_count
      , case when c.event_count = sa.event_count then 'correct' else 'fail' end as count_status
      from counts c inner join prod.UNLIMITED.SCENARIO_ACTIVITIES sa on to_date(c.event_time) = to_date(sa.CREATED_ON) and c.id = sa.uid and c.product_platform = sa.product_type and sa.event_action = c.event_action
      )


      , compare_correct as (
      select distinct e.*
      , 'all correct' as status
      , case when e.isbn = sa.component_isbn then 1 else 0 end as isbn_health
      , sa.component_isbn as sa_isbn
      , sa.event_action as sa_event_action
      , case when sa.SUCCESSFUL then 1 else 0 end as sa_SUCCESSFUL
      , c.count_status as count_status
      from events e inner join prod.UNLIMITED.SCENARIO_ACTIVITIES sa on to_date(e.event_time) = to_date(sa.CREATED_ON) and e.id = sa.uid and e.product_platform = sa.product_type and sa.event_action = e.event_action
      inner join counts_validation c on to_date(e.event_time) = to_date(c.event_time) and e.id = c.id and e.product_platform = c.product_platform and c.event_action = e.event_action
      where e.event_action not like 'LOGIN' and e.event_action not like 'UNFOCUSED'

      )

      , compare_error as (
      select distinct e.*
      , 'snowflake error' as status
      , case when e.isbn = sa.component_isbn then 1 else 0 end as isbn_health
      , sa.component_isbn as sa_isbn
      , sa.event_action as sa_event_action
      , case when sa.SUCCESSFUL then 1 else 0 end as sa_SUCCESSFUL
      , null as count_status
      from events e left outer join  prod.UNLIMITED.SCENARIO_ACTIVITIES sa on e.id = sa.uid
      where sa.uid is null
      )

      , compare_error_sa as (
      select
       sd.guid as user_sso_guid
      , sa.uid
      , sd.CREATED_ON as date_c
      , sa.product_type as product_platform
      , null as isbn
      , null as event_action
      , to_date(sa.created_on) as event_time
      , (datediff(dd, sd.CREATED_ON, sa.created_on) + 1) as day_number
      , null as event_hash
      , 'must be in snowflake' as status
      , null as isbn_health
      , sa.component_isbn as sa_isbn
      , sa.event_action as sa_event_action
      , case when sa.SUCCESSFUL then 1 else 0 end as sa_SUCCESSFUL
      , null as count_status
      from prod.UNLIMITED.SCENARIO_ACTIVITIES sa left outer join  events e on e.id = sa.uid and e.product_platform = sa.product_type
      inner join  prod.UNLIMITED.SCENARIO_DETAILS sd on sd.uid like sa.uid
      where e.product_platform is null
      )

      , compare_action as(
      select distinct e.*
      , 'not planned action' as status
      , case when e.isbn = sa.component_isbn then 1 else 0 end as isbn_health
      , sa.component_isbn as sa_isbn
      , sa.event_action as sa_event_action
      , case when sa.SUCCESSFUL then 1 else 0 end as sa_SUCCESSFUL
      , null as count_status
      from events e left outer join  prod.UNLIMITED.SCENARIO_ACTIVITIES sa on to_date(e.event_time) = to_date(sa.CREATED_ON) and e.id = sa.uid and e.product_platform = sa.product_type and sa.event_action = e.event_action
      left outer join compare_error ce on e.event_hash = ce.event_hash
      where sa.event_action is null
      and ce.event_hash is null
      and e.event_action  not like 'LOGIN' and e.event_action not like 'UNFOCUSED'
      )



      , compare as (
      select * from compare_error
      union

      select * from compare_correct
      union

      select * from compare_action

      union
      select * from compare_error_sa

      )

      , res as(
      select * from compare
      )


    select * from res
 ;;
  }



  measure: count_all {
    type: count_distinct
    sql: ${event_hash} ;;
    drill_fields: [detail*]
  }

  measure: count_not_performed{
    type: count_distinct
    filters: {
      field: status
      value: "must be in snowflake"
    }
    sql: ${product_platform} ;;
    drill_fields: [detail*]
  }

  measure: count_one_day_snowflake_error{
    type: count_distinct
    filters: {
      field: status
      value: "problem with this day"
    }
    sql: ${event_hash} ;;
    drill_fields: [detail*]
  }

  measure: count_enpected_record_empty{
    type: count_distinct
    filters: {
      field: status
      value: "problem with this day, snowflake error"

    }
    sql: ${event_hash} ;;
    drill_fields: [detail*]
  }

  measure: count_not_planed_action {
    type: count_distinct
    filters: {
      field: status
      value: "not planned action"
    }
    sql: ${event_hash} ;;
    drill_fields: [detail*]
  }

  measure: count_snowflake_error {
    type: count_distinct
    filters: {
      field: status
      value: "snowflake error"
    }
    sql: ${event_hash} ;;
    drill_fields: [detail*]
  }

  measure: count_success {
    type: count_distinct
    filters: {
      field: status
      value: "all correct"
    }
    filters: {
      field: isbn_health
      value: "1"
    }
    filters: {
      field: sa_successful
      value: "1"
    }
    filters: {
      field: count_status
      value: "correct"
    }

    sql: ${event_hash} ;;
    drill_fields: [detail*]
  }

  measure: count_failed_event_count {
    type: count_distinct
    filters: {
      field: status
      value: "all correct"
    }
    filters: {
      field: isbn_health
      value: "1"
    }
    filters: {
      field: sa_successful
      value: "1"
    }
    filters: {
      field: count_status
      value: "fail"
    }

    sql: ${product_platform} ;;
    drill_fields: [detail*]
  }


  measure: count_success_broke_script {
    type: count_distinct
    filters: {
      field: status
      value: "all correct"
    }
    filters: {
      field: isbn_health
      value: "1"
    }
    filters: {
      field: sa_successful
      value: "0"
    }
    filters: {
      field: count_status
      value: "success"
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
    filters: {
      field: count_status
      value: "success"
    }
    sql: ${event_hash} ;;
    drill_fields: [detail*]
  }


  dimension: id {
    type: string
    sql: ${TABLE}."ID" ;;
  }

  dimension:user_sso_guid {
    type: string
    sql: ${TABLE}."USER_SSO_GUID" ;;
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

  dimension: event_time {
    type: date
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

  dimension: count_status {
    type: string
    sql: ${TABLE}."COUNT_STATUS" ;;
  }

  set: detail {
    fields: [
      user_sso_guid,
      id,
      date_c,
      product_platform,
      isbn,
      event_action,
      event_time,
      day_number,
      event_hash,
      status,
      isbn_health,
      sa_isbn,
      sa_event_action,
      sa_successful,
      count_status
    ]
  }
}
