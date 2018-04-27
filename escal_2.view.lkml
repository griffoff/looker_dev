view: escal_2 {
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
select
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
    , COMPONENT
    , jsondata:updated::string as LAST_UPDATED
    , jsondata:issuetype:name::string as issuetype
            ,JSONDATA:customfield_21431[0]:value::string as category
            ,JSONDATA:customfield_30130::string as sso_isbn
            ,case when JSONDATA:customfield_26738='null' then 'Unspecified' else trim(JSONDATA:customfield_26738::string) end as discipline
            ,JSONDATA:customfield_11248::string as customer_institution
            ,JSONDATA:customfield_28633::string as course_key
            ,array_size(JSONDATA:customfield_21431) as category_escal_count
        , round(timestampdiff(minute,created,last_resolved)/60) as resolutionTime
        , round(timestampdiff(minute,created,acknowledged)/60) as acknowledgedTime
        , round(timestampdiff(minute,created,last_closed)/60) as closedTime
        , round(timestampdiff(minute,created,current_timestamp())/60) as age
from tickets
        ;;
  }


  dimension: acknowledged {
    type: string
    sql: ${TABLE}.ACKNOWLEDGED ;;
  }

  dimension:age {
    type: number
    value_format: "0.0"
    sql:  ${TABLE}.age/24 ;;
  }

  dimension:age_bins {
    type: tier
    tiers: [1, 7, 14, 21, 28, 56]
    style: integer
    sql: ${age} ;;
  }


  dimension: category {
    type: string
    sql: case when ${TABLE}.CATEGORY is null then 'Uncategorized' else ${TABLE}.CATEGORY end ;;
  }

  dimension: component {
    type: string
    sql: ${TABLE}.COMPONENT ;;
  }

  #dimension: component_escal {
  #  type: string
  #  sql: ${TABLE}.component_escal ;;
  #}

  dimension: course_key {
    type: string
    sql: ${TABLE}.course_key ;;
  }

  dimension: customer_institution {
    type: string
    sql: ${TABLE}.customer_institution ;;
  }

  dimension: discipline {
    type: string
    sql: ${TABLE}.discipline ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension:days_resolution {
    type: tier
    tiers: [7, 15, 30, 60, 90]
    style: integer
    sql: ${TABLE}.age/24 ;;
  }

  dimension:days_resolution_mounth {
    type: tier
    tiers: [30, 60, 90]
    style: integer
    sql: case when  ${TABLE}.age >720 then  ${TABLE}.age/24 else null end ;;
  }

  dimension: issuetype {
    type: string
    sql: ${TABLE}.issuetype ;;
  }

  dimension: resolution {
    type: string
    sql: ${TABLE}.resolution ;;
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
    sql: ${resolved_raw} is not null ;;
  }

  dimension: resolutionIntime {
    type: yesno
    sql: ( ${resolved_raw} is not null) and (
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

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: summary {
    type: string
    sql: ${TABLE}.summary ;;
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

  dimension: ID_TICKET {
    type: string
    primary_key: yes
    sql: ${TABLE}.ID_TICKET ;;
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

  dimension_group: resolved {
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
    sql: ${TABLE}.RESOLVED ;;
  }

  dimension_group: updated {
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
    sql: ${TABLE}.updated ;;
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
    hidden: yes
    sql: ${created_year}*10000 + ${created_month_num}*100 + ${created_day_of_month} ;;

  }

  dimension:topDiscipline {
    type: yesno
    sql: ${TABLE}.discipline in ('Accounting','Business Law','Chemistry','Decision Sciences','Economics','Health Science/Nursing','Management','Psychology & Psychotherapy','Taxation','Unspecified') ;;
  }

  dimension:topSystem {
    type: yesno
    sql: ${TABLE}.COMPONENT in ('4LTR Press Online','Aplia','CengageBrain.com','CL Homework','CNOW',    'CNOW MindApp','CNOW v7','CNOW v8','CXP',
    'DevMath','Gradebook','LMS Integration','MindTap','MindTap School','Mobile','MyCengage','OWL v2','Questia','SAM','SSO Account Services','SSO/OLR', 'WebAssign', 'www.cengage.com') ;;
  }

  measure: count_resolved {
    label: "# Resolved"
    type:  count_distinct
    sql: case when ${last_resolved_raw} is not null then ${ID_TICKET} end ;;
  }

  measure: count_notresolved {
    label: "# Outstanding"
    type:  count_distinct
    sql: case when ${last_resolved_raw} is null then ${ID_TICKET} end;;
  }

  measure: count_distinct {
    label: "IssuesDistinct"
    type: count_distinct
    sql: ${ID_TICKET};;
    drill_fields: [jiraKey, priority, created_date, resolutionStatus, last_resolved_date, age]
  }

  measure: count {
    label: "IssuesAll"
    type: count
    drill_fields: [jiraKey, priority, created_date, resolutionStatus, last_resolved_date, age]
  }
}
