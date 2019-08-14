view: ra_usage_v2 {
  derived_table: {
    sql: with bbase as (SELECT DATAVAULT.HUB_USER.UID as _uid


            , DATAVAULT.SAT_READER_EVENT.EVENT_SOURCE as e_source
            , DATAVAULT.SAT_READER_EVENT.EVENT_ID as e_id
            , to_date(DATAVAULT.SAT_READER_EVENT.EVENT_TIME) as e_time
            , DATAVAULT.SAT_READER_EVENT.EVENT_CATEGORY as e_category
            , DATAVAULT.SAT_READER_EVENT.EVENT_ACTION as e_action
            , DATAVAULT.HUB_BOOK.ISBN13 as ISBN13
            , UNLIMITED.SCENARIO_DETAILS.uid as email


            FROM DATAVAULT.HUB_USER
            INNER JOIN DATAVAULT.LINK_USER_BOOK on DATAVAULT.LINK_USER_BOOK.HUB_USER_KEY =  DATAVAULT.HUB_USER.HUB_USER_KEY
            INNER JOIN DATAVAULT.HUB_BOOK on DATAVAULT.HUB_BOOK.HUB_BOOK_KEY = DATAVAULT.LINK_USER_BOOK.HUB_BOOK_KEY
            INNER JOIN DATAVAULT.SAT_READER_EVENT on DATAVAULT.SAT_READER_EVENT.LINK_USER_BOOK_KEY = DATAVAULT.LINK_USER_BOOK.LINK_USER_BOOK_KEY
            INNER JOIN UNLIMITED.SCENARIO_DETAILS on UNLIMITED.SCENARIO_DETAILS.guid = DATAVAULT.HUB_USER.uid
            )

            , base as(select email, _uid, e_time, isbn13, e_source, e_category, e_action, count(*) as e_count
            from bbase
            group by email, _uid, e_time, isbn13, e_source, e_category, e_action)

            , success as (
            select base.*
            , UNLIMITED.SCENARIO_DETAILS.created_on as created
            , 1 as success
            from base
            inner join UNLIMITED.SCENARIO_ACTIVITIES on UNLIMITED.SCENARIO_ACTIVITIES.uid = base.email and base.e_time = UNLIMITED.SCENARIO_ACTIVITIES.CREATED_ON and base.isbn13 = UNLIMITED.SCENARIO_ACTIVITIES.COMPONENT_ISBN and base.e_action = UNLIMITED.SCENARIO_ACTIVITIES.EVENT_ACTION and base.e_count = UNLIMITED.SCENARIO_ACTIVITIES.EVENT_COUNT
            INNER join UNLIMITED.SCENARIO_DETAILS on UNLIMITED.SCENARIO_DETAILS.UID = base.email
            )

            , fail as(
            SELECT
            UNLIMITED.SCENARIO_ACTIVITIES.uid as email
            , UNLIMITED.SCENARIO_DETAILS.GUID as _uid
            , UNLIMITED.SCENARIO_ACTIVITIES.CREATED_ON as e_time
            , UNLIMITED.SCENARIO_ACTIVITIES.COMPONENT_ISBN as ISBN13
            , null as e_source
            , UNLIMITED.SCENARIO_ACTIVITIES.EVENT_TYPE as e_category
            , UNLIMITED.SCENARIO_ACTIVITIES.EVENT_ACTION as e_action
            , UNLIMITED.SCENARIO_ACTIVITIES.EVENT_COUNT as e_count
            , UNLIMITED.SCENARIO_DETAILS.CREATED_ON as created
            , 0 as success
            from UNLIMITED.SCENARIO_DETAILS
            INNER JOIN UNLIMITED.SCENARIO_ACTIVITIES on UNLIMITED.SCENARIO_ACTIVITIES.uid = UNLIMITED.SCENARIO_DETAILS.uid
            LEFT OUTER JOIN success on success._uid = UNLIMITED.SCENARIO_DETAILS.GUID and success.e_time = UNLIMITED.SCENARIO_ACTIVITIES.CREATED_ON and success.isbn13 = UNLIMITED.SCENARIO_ACTIVITIES.COMPONENT_ISBN and success.e_action = UNLIMITED.SCENARIO_ACTIVITIES.EVENT_ACTION and success.e_count = UNLIMITED.SCENARIO_ACTIVITIES.EVENT_COUNT
            where success._uid is null
            and success.e_time is null
            and success.isbn13 is null
            and success.e_action is null
            and success.e_count is null
            and UNLIMITED.SCENARIO_ACTIVITIES.EVENT_ACTION not like 'LAUNCH'

            )

            select * from success
            union
            select * from fail
             ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure: count_good {
    type: count
    filters: {
      field: success
      value: "1"
    }
    drill_fields: [detail*]
  }

  measure: count_bad {
    type: count
    filters: {
      field: success
      value: "0"
    }
    drill_fields: [detail*]
  }
  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: _uid {
    type: string
    sql: ${TABLE}."_UID" ;;
  }

  dimension: e_time {
    type: date
    sql: ${TABLE}."E_TIME" ;;
  }

  dimension: isbn13 {
    type: string
    sql: ${TABLE}."ISBN13" ;;
  }

  dimension: e_source {
    type: string
    sql: ${TABLE}."E_SOURCE" ;;
  }

  dimension: e_category {
    type: string
    sql: ${TABLE}."E_CATEGORY" ;;
  }

  dimension: e_action {
    type: string
    sql: ${TABLE}."E_ACTION" ;;
  }

  dimension: e_count {
    type: number
    sql: ${TABLE}."E_COUNT" ;;
  }

  dimension: created {
    type: date
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: success {
    type: number
    sql: ${TABLE}."SUCCESS" ;;
  }

  dimension: day_number {
    type: number
    sql: (datediff(dd, ${created}, ${e_time})) ;;
  }

  set: detail {
    fields: [
      email,
      _uid,
      e_time,
      isbn13,
      e_source,
      e_category,
      e_action,
      e_count,
      created,
      success
    ]
  }
}
