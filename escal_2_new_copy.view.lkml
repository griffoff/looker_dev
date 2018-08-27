view: escal_2_new_copy {
  derived_table: {
    sql: WITH tickets as(
        SELECT T1.ID_TICKET
        , T2.JSONDATA
        , T2.KEY_JIRA
        , T2.COMPONENT
        FROM JIRA.JIRA_PROCS_ISSUE T1
          INNER JOIN JIRA.RAW_JIRA_DATA T2 ON T1.ID_TICKET=T2.ID_TICKET
       where PROCESS_NAME='filter-99476'  -- stg 92672
  )

, full_table as ( select
      ID_TICKET
    , KEY_JIRA
    , TO_TIMESTAMP_TZ(jsondata:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as CREATED
    , case when JSONDATA:resolutiondate='null' then null else to_timestamp_tz(jsondata:resolutiondate::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') end as acknowledged
    , case when JSONDATA:customfield_24430='null' then null else to_timestamp_tz(jsondata:customfield_24430::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') end as resolved
    , case when JSONDATA:updated='null' then null else to_timestamp_tz(jsondata:updated::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') end as updated
    , case when JSONDATA:customfield_13438='null' then null else to_timestamp(as_number(JSONDATA:customfield_13438), 3) end as last_resolved
    , case when JSONDATA:customfield_13430='null' then null else to_timestamp(as_number(JSONDATA:customfield_13430), 3) end as last_closed
    , JSONDATA:priority:name::string as priority
    , JSONDATA:description::string as description
    , JSONDATA:customfield_23432:value::string as severity
    , jsondata:resolution:name::string  AS resolution
    , jsondata:status:name::string  AS status
    , jsondata:summary::string  AS summary
    --, jsondata:project:projectCategory:name::string as Category
    --, jsondata:customfield_31240:value::string as COMPONENT
    --,JSONDATA:components[0]:name::string as component_escal
    , COALESCE(COMPONENT, JSONDATA:customfield_32866:value::string) as COMPONENT
    --,JSONDATA:customfield_32866:value::string as escal_component
    --, COMPONENT
    , jsondata:updated::string as LAST_UPDATED
    , jsondata:issuetype:name::string as issuetype
            , case when contains(KEY_JIRA, 'ESCAL-') then JSONDATA:customfield_21431[0]:value::string else JSONDATA:customfield_20434:value::string end as category
            ,JSONDATA:customfield_30130::string as sso_isbn
            ,case when JSONDATA:customfield_26738='null' then 'Unspecified' else trim(JSONDATA:customfield_26738::string) end as discipline
            ,JSONDATA:customfield_11248::string as customer_institution
            ,JSONDATA:customfield_28633::string as course_key
            ,JSONDATA:customfield_33033::string as salesforce_key -- customfield_31335 (old)
            -- ,array_size(JSONDATA:customfield_21431) as category_escal_count
        , round(timestampdiff(minute,created,last_resolved)/60) as resolutionTime
        , round(timestampdiff(minute,created,acknowledged)/60) as acknowledgedTime
        , round(timestampdiff(minute,created,last_closed)/60) as closedTime
        , round(timestampdiff(minute,created,current_timestamp())/60) as age
, jsondata:changelog::string as cl
--, value:items as items
from tickets
--, lateral flatten ( input => JSONDATA:changelog:histories)
)
, days as (
SELECT DATEVALUE as day FROM DW_DEVMATH.DIM_DATE WHERE DATEKEY BETWEEN (TO_CHAR(date_part(year,current_date())) || '0101') AND (TO_CHAR(date_part(year,current_date())) || TO_CHAR(RIGHT('00' || DATE_PART(month,current_date()),2)) || TO_CHAR(RIGHT('00' || DATE_PART(day,current_date()),2))) ORDER BY DATEVALUE
            )

, res as(
select
 days.day
, case when to_date(created) = day then 'true' end as created_today
, case when to_date(split_part(LAST_UPDATED, 'T', 1)) = day and status like 'Closed' then 'true' end as closed_today
, case when to_date(split_part(LAST_UPDATED, 'T', 1)) = day and status like 'Reopened' then 'true' end as reopened_today
, full_table.*
from full_table, days
)

select * from res
 ;;
  }

  measure: count {
    type: count_distinct
    sql: ${id_ticket} ;;
    drill_fields: [detail*]
  }

  measure: created
  {
    type: count_distinct
    filters: {
      field: created_today
      value: "true"
    }
    sql: ${id_ticket} ;;
    drill_fields: [detail*]
  }

  measure: closed
  {
    type: count_distinct
    filters: {
      field: closed_today
      value: "true"
    }
    sql: ${id_ticket} ;;
    drill_fields: [detail*]
  }

  measure: reopen
  {
    type: count_distinct
    filters: {
      field: reopened_today
      value: "true"
    }
    sql: ${id_ticket} ;;
    drill_fields: [detail*]
  }


  dimension: day {
    type: date
    sql: ${TABLE}."DAY" ;;
  }

  dimension: created_today {
    type: string
    sql: ${TABLE}."CREATED_TODAY" ;;
  }

  dimension: closed_today {
    type: string
    sql: ${TABLE}."CLOSED_TODAY" ;;
  }

  dimension: reopened_today {
    type: string
    sql: ${TABLE}."REOPENED_TODAY" ;;
  }

  dimension: id_ticket {
    type: string
    sql: ${TABLE}."ID_TICKET" ;;
  }

  dimension: key_jira {
    type: string
    sql: ${TABLE}."KEY_JIRA" ;;
  }

  dimension_group: created {
    type: time
    sql: ${TABLE}."CREATED" ;;
  }

  dimension_group: acknowledged {
    type: time
    sql: ${TABLE}."ACKNOWLEDGED" ;;
  }

  dimension_group: resolved {
    type: time
    sql: ${TABLE}."RESOLVED" ;;
  }

  dimension_group: updated {
    type: time
    sql: ${TABLE}."UPDATED" ;;
  }

  dimension_group: last_resolved {
    type: time
    sql: ${TABLE}."LAST_RESOLVED" ;;
  }

  dimension_group: last_closed {
    type: time
    sql: ${TABLE}."LAST_CLOSED" ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}."PRIORITY" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: severity {
    type: string
    sql: ${TABLE}."SEVERITY" ;;
  }

  dimension: resolution {
    type: string
    sql: ${TABLE}."RESOLUTION" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: summary {
    type: string
    sql: ${TABLE}."SUMMARY" ;;
  }

  dimension: component {
    type: string
    sql: ${TABLE}."COMPONENT" ;;
  }

  dimension: last_updated {
    type: string
    sql: ${TABLE}."LAST_UPDATED" ;;
  }

  dimension: issuetype {
    type: string
    sql: ${TABLE}."ISSUETYPE" ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}."CATEGORY" ;;
  }

  dimension: sso_isbn {
    type: string
    sql: ${TABLE}."SSO_ISBN" ;;
  }

  dimension: discipline {
    type: string
    sql: ${TABLE}."DISCIPLINE" ;;
  }

  dimension: customer_institution {
    type: string
    sql: ${TABLE}."CUSTOMER_INSTITUTION" ;;
  }

  dimension: course_key {
    type: string
    sql: ${TABLE}."COURSE_KEY" ;;
  }

  dimension: salesforce_key {
    type: string
    sql: ${TABLE}."SALESFORCE_KEY" ;;
  }

  dimension: resolutiontime {
    type: number
    sql: ${TABLE}."RESOLUTIONTIME" ;;
  }

  dimension: acknowledgedtime {
    type: number
    sql: ${TABLE}."ACKNOWLEDGEDTIME" ;;
  }

  dimension: closedtime {
    type: number
    sql: ${TABLE}."CLOSEDTIME" ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}."AGE" ;;
  }

  dimension: cl {
    type: string
    sql: ${TABLE}."CL" ;;
  }

  set: detail {
    fields: [
      day,
      created_today,
      closed_today,
      reopened_today,
      id_ticket,
      key_jira,
      created_time,
      acknowledged_time,
      resolved_time,
      updated_time,
      last_resolved_time,
      last_closed_time,
      priority,
      description,
      severity,
      resolution,
      status,
      summary,
      component,
      last_updated,
      issuetype,
      category,
      sso_isbn,
      discipline,
      customer_institution,
      course_key,
      salesforce_key,
      resolutiontime,
      acknowledgedtime,
      closedtime,
      age,
      cl
    ]
  }
}
