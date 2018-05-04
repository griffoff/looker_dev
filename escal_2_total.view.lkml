view: escal_2_total {
  view_label: "Escals"
  derived_table: {
    sql:
    WITH tickets as(
        SELECT T1.ID_TICKET
        , T2.JSONDATA
        , T2.KEY_JIRA
        , T2.COMPONENT
        FROM JIRA.JIRA_PROCS_ISSUE T1
          INNER JOIN JIRA.RAW_JIRA_DATA T2 ON T1.ID_TICKET=T2.ID_TICKET
        where PROCESS_NAME='filter-92672'
  )
  , category as (
select
i.COLUMN1 as category
from values ('Content Development'),('Digital Production'),('Software'),('Uncategorized') i
              )
,priority as (select
i.COLUMN1 as priority
from values ('P1 Escalation'),('P2 Escalation'),('P3 Escalation') i
              )
,component as (select
i.COLUMN1 as component
from values ('4LTR Press Online'),('Aplia'),('CengageBrain.com'),('CL Homework'),('CNOW'),('CNOW MindApp'),('CNOW v7'),('CNOW v8'),('CXP'),('DevMath'),('Gradebook'),('LMS Integration'),('MindTap'),('MindTap School'),('Mobile'),('MyCengage'),('OWL v2'),('Questia'),('SAM'),('SSO Account Services'),('SSO/OLR'),( 'WebAssign'),( 'www.cengage.com') i
              )
,category_priority as (
  select
*
  from category
  cross join priority
                      )
 , dummy as( select
*
  from category_priority
  cross join component )
select
    KEY_JIRA
    , TO_TIMESTAMP_TZ(jsondata:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as CREATED
    --, case when JSONDATA:resolutiondate='null' then null else to_timestamp_tz(jsondata:resolutiondate::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') end as acknowledged
    --, case when JSONDATA:customfield_24430='null' then null else to_timestamp_tz(jsondata:customfield_24430::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') end as resolved
    , JSONDATA:priority:name::string as priority
    , jsondata:resolution:name::string  AS resolution
    , case when JSONDATA:resolutiondate='null' then null else to_timestamp_tz(jsondata:resolutiondate::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') end as resolutiondate
    --, jsondata:status:name::string  AS status
    , COMPONENT
    ,JSONDATA:customfield_21431[0]:value::string as category
from tickets
  union
select
   'dummy-' as KEY_JIRA
  , TO_DATE('20000101', 'yyyymmdd') as CREATED
  , priority
  , null as resolution
  , null as resolutiondate
  , component
  , category
  --,null as LAST_CLOSED
from dummy
        ;;
  }


  dimension: category {
    type: string
    sql: case when ${TABLE}.CATEGORY is null then 'Uncategorized' else ${TABLE}.CATEGORY end ;;
  }

  dimension: component {
    type: string
    sql: ${TABLE}.COMPONENT ;;
  }

  dimension: component_priority {
    type: string
    sql: ${TABLE}.COMPONENT || ' ' || ${TABLE}.priority ;;
  }


  dimension: resolutionStatus {
    # view_label: "Is Resolved?"
    type: yesno
    sql: ${resolution} is not null ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year,
      day_of_week,
      hour_of_day,
      week_of_year,
      day_of_month,
      month_num
    ]
    sql: ${TABLE}.CREATED ;;
  }

  dimension: KEY_JIRA {
    type: string
    sql: ${TABLE}.KEY_JIRA ;;
  }

  dimension: jiraKey {
    link: {
      label: "Review in Jira"
      url: "https://s-jira.cengage.com/browse/{{value}}"
    }
    sql: ${TABLE}.KEY_JIRA ;;
  }


  dimension: resolution {
    type: string
    sql: ${TABLE}.resolution ;;
  }

  dimension_group: resolutiondate {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year,
      day_of_week,
      hour_of_day,
      week_of_year,
      day_of_month,
      month_num
    ]
    sql: ${TABLE}.resolutiondate ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}.PRIORITY ;;
  }

  dimension:topSystem {
    type: yesno
    sql: ${TABLE}.COMPONENT in ('4LTR Press Online','Aplia','CengageBrain.com','CL Homework','CNOW',    'CNOW MindApp','CNOW v7','CNOW v8','CXP',
      'DevMath','Gradebook','LMS Integration','MindTap','MindTap School','Mobile','MyCengage','OWL v2','Questia','SAM','SSO Account Services','SSO/OLR', 'WebAssign', 'www.cengage.com') ;;
  }


  measure: count {
    label: " # Issues"
    type: count_distinct
    sql: ${KEY_JIRA} ;;
    drill_fields: [jiraKey,category, component_priority, created_date, resolutionStatus]
  }

  measure: count_created_yesterday {
    label: "# Created_yesterday"
    type:  count_distinct
    sql: case when ${created_date} =TO_DATE(dateadd(day,-5,current_timestamp))  then ${KEY_JIRA} end ;;
    drill_fields: [jiraKey,category, component_priority, created_date, resolutionStatus]
  }

  measure: count_resolved_yesterday {
    label: "# Resolved_yesterday"
    type:  count_distinct
    sql: case when ${resolutiondate_date} =TO_DATE(dateadd(day,-5,current_timestamp)) then ${KEY_JIRA} end ;;
    drill_fields: [jiraKey,category, component_priority, created_date, resolutionStatus]
  }

  }
