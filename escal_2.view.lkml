view: escal_2 {
  view_label: "Escals"
  derived_table: {
    sql: with tickets as(
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
          ,IFNULL(JSONDATA:customfield_26738,'Unspecified') as discipline
          ,JSONDATA:customfield_11248::string as customer_institution
          ,JSONDATA:customfield_28633::string as course_key
          ,JSONDATA:customfield_33033::string as salesforce_key -- customfield_31335 (old)
          -- ,array_size(JSONDATA:customfield_21431) as category_escal_count
          , round(timestampdiff(minute,created,last_resolved)/60) as resolutionTime
          , round(timestampdiff(minute,created,acknowledged)/60) as acknowledgedTime
          , round(timestampdiff(minute,created,last_closed)/60) as closedTime
          , round(timestampdiff(minute,created,current_timestamp())/60) as age
          from tickets )

          select full_table.*
          , PRODUCTGROUP::string as PRODUCTGROUP
          , DISPLAYORDER::number as DISPLAYORDER
          , ISTOPSYSTEM::boolean as ISTOPSYSTEM
          , case when f.clone is null then 'NO' else 'YES' end as is_clone
          from full_table
          left join JIRA.TOPSYSTEM ts on COMPONENT=SYSTEMNAME
          left outer join ${escal_cloned_tickets.SQL_TABLE_NAME}  f on ID_TICKET = f.clone
          where is_clone like 'NO'
          ;;
  }

  set: detalized_set_fields {
    fields: [
      jira_url_by_Key,
      priority,
      category,
      component,
      created_date,
      resolutionStatus,
      last_resolved_date,
      age_days,
      salesforce_key
    ]
  }


  dimension: PRODUCTGROUP {
    type: string
    sql: ${TABLE}.PRODUCTGROUP ;;
  }


  dimension: DISPLAYORDER {
    type: number
    description: "Rang of system from the table TOPSYSTEM"
    sql:  ${TABLE}.DISPLAYORDER ;;
  }

  dimension: component_priority_ORDER {
    type: number
    description: "Rang of system depends from priority"
    sql:  case when priority ='P1 Escalation' then ${DISPLAYORDER}*10+1
               when priority ='P2 Escalation' then ${DISPLAYORDER}*10+2
               when priority ='P3 Escalation' then ${DISPLAYORDER}*10+3
              else ${DISPLAYORDER}*10+5 end
    ;;
  }

  dimension: component_priority_alphabetical {
    type: string
    description: "We can use it for alphabetical order refer to priority"
    sql: ${TABLE}.COMPONENT || ' (' || SPLIT_PART(${TABLE}.priority,' ',1)||')' ;;
  }

  dimension: ISTOPSYSTEM {
    type: yesno
    description: "Boolean from the table TOPSYSTEM"
    sql: ${TABLE}.ISTOPSYSTEM ;;
  }

  dimension: acknowledged {
    type: string
    sql: ${TABLE}.ACKNOWLEDGED ;;
  }

  dimension:age_days {
    type: number
    value_format: "0.0"
    sql:  ${TABLE}.age/24 ;;
  }

  dimension:age_bins {
    type: tier
    tiers: [1, 7, 14, 21, 28, 56]
    style: integer
    sql: ${age_days};;
  }


  dimension: category {
    type: string
    sql: case
            when ${TABLE}.CATEGORY is null or ${TABLE}.CATEGORY='Not set' then 'Uncategorized'
            when ${TABLE}.CATEGORY='Content Development' then 'Content Source'
            else ${TABLE}.CATEGORY end ;;
  }

  dimension: component {
    type: string
    sql: ${TABLE}.COMPONENT  ;;
    #  sql: case when ${TABLE}.COMPONENT is null then ${TABLE}.escal_component else ${TABLE}.COMPONENT end ;;
  }

  # Fields ESC-COMP at Jira
#  dimension: escal_component {
#    type: string
#    sql: ${TABLE}.escal_component ;;
#  }

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
    sql: ${acknowledged} is not null ;;
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

  dimension: salesforce_key {
    link: {
      label: "Review in Jira filtered by the SalesForce key"
      url: "https://jira.cengage.com/issues/?jql=cf%5B33033%5D%20%3D%22{{ value }}%22"
    }
    type: string
    sql: ${TABLE}.salesforce_key ;;
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
    sql:to_date(${TABLE}.CREATED) ;;
  }

  dimension: semester_calendar {
    type: string
    sql: case
            when ${created_month_num} <7 then 'Spring '||${created_year}
            when ${created_month_num} >7 then 'Fall ' ||${created_year}
         end
            ;;
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

  dimension: jira_url_by_Key {
    link: {
      label: "Review in Jira"
      url: "https://jira.cengage.com/browse/{{value}}"
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
    description: "Boolean from the manually created list"
    sql: ${component} in ('4LTR Press Online','Aplia',
          'CengageBrain.com','CL Homework','CNOW', 'CNOW MindApp','CNOW v7','CNOW v8','CXP','CU Catalog Data',
          'DevMath','Gradebook','LMS Integration','MindTap','MindTap School','Mobile','MyCengage','OWL v2','Questia',
          'SAM','SSO Account Services','SSO/OLR', 'WebAssign', 'www.cengage.com') ;;
  }


  measure: count_opened{
    type:  count_distinct
    sql: case when ${status} not like 'Close' then ${ID_TICKET} end ;;
    drill_fields: [detalized_set_fields*]
  }

  measure: count_closed{
    type:  count_distinct
    sql: case when ${status} like 'Close' then ${ID_TICKET} end ;;
    drill_fields: [detalized_set_fields*]
  }


  measure: count_resolved {
    label: "# Resolved"
    type:  count_distinct
    sql: case when ${last_resolved_raw} is not null then ${ID_TICKET} end ;;
    drill_fields: [detalized_set_fields*]
  }

  measure: count_notresolved {
    label: "# Outstanding"
    type:  count_distinct
    sql: case when ${last_resolved_raw} is null then ${ID_TICKET} end;;
    drill_fields: [detalized_set_fields*]
  }

  measure: count_distinct {
    label: "IssuesDistinct"
    type: count_distinct
    sql: ${ID_TICKET};;
    drill_fields: [detalized_set_fields*]
  }

  measure: count {
    label: "IssuesAll"
    type: count
    drill_fields: [detalized_set_fields*]
  }
  #---------------------------------------------------------------
  dimension: is_new{
    type: yesno
    hidden: yes
    sql: datediff(day, ${created_date}, current_timestamp) <= 1 ;;
  }

  dimension: is_resolved{
    type: yesno
    hidden: yes
    sql: datediff(day, ${last_resolved_date}, current_timestamp) <= 1 ;;
  }
  measure: Resolved{
    type:  count_distinct
    sql: ${ID_TICKET} ;;
    filters: {
      field: is_resolved
      value: "yes"
    }
    drill_fields: [detail*]
  }

  measure: New{
    type:  count_distinct
    sql: ${ID_TICKET} ;;
    filters: {
      field: is_new
      value: "yes"
    }
    drill_fields: [detail*]
  }

  measure: Total_unresolved{
    type:  count_distinct
    sql: ${ID_TICKET} ;;
    filters: {
      field: resolution
      value: "null"
    }
    drill_fields: [detail*]
  }

  measure: Tier_3_Await_Ack{
    type:  count_distinct
    sql: ${ID_TICKET} ;;
    filters: {
      field:status
      value: "Tier 3 Awaiting Acknowledge"
    }
    drill_fields: [detail*]
  }

  dimension: is_clone {
    type: string
    sql: ${TABLE}."IS_CLONE" ;;
  }
  set: detail {
    fields: [
      jira_url_by_Key,
      priority,
      category,
      component,
      created_date,
      resolutionStatus,
      last_resolved_date,
      age_days,
      salesforce_key
    ]
  }
  #---------------------------------------------------------------
}
