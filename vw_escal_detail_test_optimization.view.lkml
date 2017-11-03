view: vw_escal_detail_test_optimization {
  view_label: "Escals_optimized"
  derived_table: {
    sql:
with detail as  (
select
    JSONDATA:key::string as key
    , JSONDATA:fields:priority:name::string as priority
    , JSONDATA:fields:customfield_23432:value::string as severity
    , split_part(JSONDATA:fields:customfield_23432:value, '-', 1)::int as severity_id
    --you can pass negative numbers to split_part to use relative indexing from the end of the array
    , split_part(JSONDATA:fields:customfield_23432:value, '-', -1)::string as severity_name
    --cast the json value to a string to use it in the to_timestamp function
    , to_timestamp_tz(JSONDATA:fields:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as created
    -- you can use nullif instead of case to simplify this
    , to_timestamp_tz(nullif(JSONDATA:fields:customfield_24430, 'null')::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as acknowledged
    , case when JSONDATA:fields:customfield_13438='null' then null else to_timestamp(as_number(JSONDATA:fields:customfield_13438), 3) end AS last_resolved
    , case when JSONDATA:fields:customfield_13430='null' then null else to_timestamp(as_number(JSONDATA:fields:customfield_13430), 3) end AS last_closed
    ,JSONDATA:fields:customfield_21431 as categories
    ,JSONDATA:fields:customfield_30130::string as sso_isbn
    ,array_size(JSONDATA:fields:customfield_21431) as category_count
    ,JSONDATA:fields:components as components
    ,array_size(JSONDATA:fields:components) as component_count
   from
     JIRA.RAW_JIRA_ISSUE
where contains(key, 'ESCAL')  )
, detail_categories as (select
  detail.key
  , detail.priority
  , detail.severity
  , detail.created
  , detail.last_resolved
  , detail.acknowledged
  , detail.last_closed
  , detail.categories
  , detail.sso_isbn
  , detail.components
  , timestampdiff(minute,detail.created,detail.last_resolved)/60 as resolutionTime
  , timestampdiff(minute,detail.created,detail.acknowledged)/60 as acknowledgedTime
  , timestampdiff(minute,detail.created,detail.last_closed)/60 as closedTime
  , timestampdiff(minute, detail.created, current_timestamp())/60 as age
  , i.value:value::string as category
from detail
     , lateral flatten(detail.categories) i )
 select
  detail_categories.*
  , i.value:name::string as component
from detail_categories
     , lateral flatten(detail_categories.components) i
;;
  }


  dimension: acknowledged {
    type: string
    sql: ${TABLE}.ACKNOWLEDGED ;;
  }

  dimension: resolutionTime {
    type: string
    sql: ${TABLE}.resolutionTime ;;
  }

  dimension:resolutionTime_bins {
    type: tier
    tiers: [1, 7, 14, 21, 28, 56]
    style: integer
    sql: ${TABLE}.resolutionTime ;;
  }

  dimension: resolutionStatus {
   # view_label: "Is Resolved?"
    type: yesno
    sql: ${last_resolved_raw} is not null ;;
  }

  dimension: resolutionIntime {
    type: yesno
    sql: ( ${last_resolved_raw} is not null) and (
           ( (${priority} = 'P4 Escalation') and (${resolutionTime}<306))
        or ( (${priority} = 'P3 Escalation') and (${resolutionTime}<186))
        or ( (${priority} = 'P2 Escalation') and (${resolutionTime}<24))
        or ( (${priority} = 'P1 Escalation') and (${resolutionTime}<8))
                                                  );;
  }

  dimension: resolutionIntimeOuttime {
    type: string
    sql: case when (${resolutionIntime}) then 'In time' else 'Out time' end;;
  }

  dimension: sso_isbn {
    type: string
    sql: ${TABLE}.sso_isbn ;;
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

  dimension: key {
    type: string
    primary_key: yes
    sql: ${TABLE}.KEY ;;
  }

  dimension: jiraKey {
    link: {
      label: "Review in Jira"
      url: "https://jira.cengage.com/browse/{{value}}"
    }

    sql: ${TABLE}.KEY ;;
  }

  dimension_group: last_closed {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week,
      hour_of_day,
      week_of_year

    ]
    sql: ${TABLE}.LAST_CLOSED ;;
  }

  dimension_group: last_resolved {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week,
      hour_of_day,
      week_of_year
    ]
    sql: ${TABLE}.LAST_RESOLVED ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}.PRIORITY ;;
  }

  dimension: severity {
    type: string
    sql: ${TABLE}.SEVERITY ;;
  }

  dimension: createdatekey  {
    type: number
    sql: ${created_year}*10000 + ${created_month_num}*100 + ${created_day_of_month} ;;

  }

  dimension:age {
    type: number
    sql:  ${TABLE}.age/60 ;;
  }

  dimension:age_bins {
    type: tier
    tiers: [1, 7, 14, 21, 28, 56]
    style: integer
    sql: ${age} ;;
  }


  dimension: category {
    type: string
    sql: ${TABLE}.CATEGORY ;;
  }

  dimension: component {
    type: string
    sql: ${TABLE}.COMPONENT ;;
  }

  dimension:topSystem {
    type: yesno
    sql: ${TABLE}.COMPONENT in ('MindTap','SSO/OLR','CL Homework','DevMath','Gradebook','Mobile','MTQ','CNOW','CNOW MindApp','CNOW v7','CNOW v8','Aplia','CXP','OWL v2','OWL v1','SAM','4LTR Press Online','CengageBrain.com','SSO Account Services', 'WebAssign', 'MyCengage') ;;
  }

  measure: count_resolved {
    label: "# Resolved"
    type:  count_distinct
    sql: case when ${last_resolved_raw} is not null then ${key} end ;;
  }

  measure: count_notresolved {
    label: "# Outstanding"
    type:  count_distinct
    sql: case when ${last_resolved_raw} is null then ${key} end;;
  }

  measure: count {
    label: "Issues"
    type: count_distinct
    drill_fields: [jiraKey, severity, priority, created_date, resolutionStatus, last_resolved_date, age]
    link: {
      label: "Look at Content Aging Data"
      url: "https://cengage.looker.com/dashboards/37?Category=%25Content%20Development%25"
    }
    link: {
      label: "Look at Software Aging Data"
      url: "https://cengage.looker.com/dashboards/37?Category=%25Software%25"

    }
  }
  #measure: count2 {
  #  type: count
  #  link: {
  #    label: "‘Drill Down Test’"
  #    url: "{{ sessions.count_bounce_sessions._link }}"
  #    icon_url: "http://www.looker.com/favicon.ico"
  #  }
  #}
}
