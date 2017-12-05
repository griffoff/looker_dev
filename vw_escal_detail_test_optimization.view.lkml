view: vw_escal_detail_test_optimization {
  view_label: "Escals_optimized"
  derived_table: {
    sql:
 with detail as  (
    select
        JSONDATA:key::string as id
        , JSONDATA:fields:priority:name::string as priority
        , JSONDATA:fields:resolution:name::string as resolution
        , JSONDATA:fields:status:name::string as status
        , JSONDATA:fields:issuetype:name::string as issuetype
        , JSONDATA:fields:summary::string as summary
        , JSONDATA:fields:description::string as description
        , JSONDATA:fields:customfield_23432:value::string as severity
        , split_part(JSONDATA:fields:customfield_23432:value, '-', 1)::int as severity_id
        --you can pass negative numbers to split_part to use relative indexing from the end of the array
        , split_part(JSONDATA:fields:customfield_23432:value, '-', -1)::string as severity_name
        --cast the json value to a string to use it in the to_timestamp function
        , to_timestamp_tz(JSONDATA:fields:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as created
        -- you can use nullif instead of case to simplify this
        , to_timestamp_tz(nullif(JSONDATA:fields:customfield_24430, 'null')::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as acknowledged
        , case when JSONDATA:fields:resolutiondate='null' then null else to_timestamp(JSONDATA:fields:resolutiondate::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') end AS resolved
        , case when JSONDATA:fields:customfield_13438='null' then null else to_timestamp(as_number(JSONDATA:fields:customfield_13438), 3) end AS last_resolved
        , case when JSONDATA:fields:customfield_13430='null' then null else to_timestamp(as_number(JSONDATA:fields:customfield_13430), 3) end AS last_closed
        ,JSONDATA:fields:customfield_21431 as categories
        ,JSONDATA:fields:issuelinks as issuelinks
        ,JSONDATA:fields:customfield_30130::string as sso_isbn
        ,case when JSONDATA:fields:customfield_26738='null' then 'Unspecified' else trim(JSONDATA:fields:customfield_26738::string) end as discipline
        ,JSONDATA:fields:customfield_11248::string as customer_institution
        ,JSONDATA:fields:customfield_28633::string as course_key
        ,array_size(JSONDATA:fields:customfield_21431) as category_count
        ,JSONDATA:fields:components as components
        ,array_size(JSONDATA:fields:components) as component_count
       from
         JIRA.RAW_JIRA_ISSUE
    where contains(key, 'ESCAL')  )
    , t_categories as (  select  detail.id,
     i.value:value::string as category
     from detail
    , lateral flatten(detail.categories) i )
    , t_components as (  select  detail.id,
     i.value:name::string as component
     from detail
    , lateral flatten(detail.components) i )
    , t_issuelinks as (  select  detail.id
    , i.value:type:inward::string as issuelink
    , i.value:inwardIssue:key::string as inwardIssue
     from detail
    , lateral flatten(detail.issuelinks) i )
--    select * from t_issuelinks
 , detail_categories as (select
    t1.*
    , timestampdiff(minute,t1.created,t1.last_resolved)/60 as resolutionTime
    , timestampdiff(minute,t1.created,t1.acknowledged)/60 as acknowledgedTime
    , timestampdiff(minute,t1.acknowledged,t1.last_resolved)/60 as openresolutionTime
    , timestampdiff(minute,t1.created,t1.last_closed)/60 as closedTime
    , timestampdiff(minute, t1.created, current_timestamp())/60 as age
    , t2.category
    --, case when i.value:value::string is null then 'null' else i.value:value::string end  as category
    from detail t1
    -- select * from detail_categories  ;
    left join  t_categories t2 on t1.id=t2.id)
    -- select * from detail_categories  ;
 , detail_categ_comp as ( select
    t1.*
    , t2.component
    from detail_categories t1
    left join  t_components t2 on t1.id=t2.id )
select
    t1.*
    , t2.issuelink
    , t2.inwardIssue
    from detail_categ_comp t1
    left join  t_issuelinks t2 on t1.id=t2.id
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


  dimension: category_non_software {
    type: string
    sql: case when ${TABLE}.CATEGORY='Software' then 'Software' else 'Non-Software' end ;;
  }

  dimension: closedTime_day {
    type: number
    value_format: "0"
    sql: ROUND(${TABLE}.closedTime/24) ;;
  }

  dimension: component {
    type: string
    sql: ${TABLE}.COMPONENT ;;
  }

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

  dimension: inwardIssue {
    type: string
    sql: ${TABLE}.inwardIssue ;;
  }

  dimension: inwardIssue_project {
    type: string
    sql: case when ${TABLE}.inwardIssue is null then null else split_part( ${TABLE}.inwardIssue, '-', 1) end;;
  }

  dimension: issuelink {
    type: string
    sql: ${TABLE}.issuelink ;;
  }

  dimension: issuetype {
    type: string
    sql: ${TABLE}.issuetype ;;
  }

  dimension: openresolutionTime {
    type: string
    sql: ${TABLE}.openresolutionTime ;;
  }

  dimension: resolution {
    type: string
    sql: ${TABLE}.resolution ;;
  }

  dimension: resolutionTime_day {
    type: number
    value_format: "0"
    sql: ROUND(${TABLE}.resolutionTime/24) ;;
  }

  dimension: resolution_times_acc_to_priority {
    type: number
    value_format: "0.0"
    sql: CASE
          WHEN ${priority} = 'P1 Escalation' THEN  ROUND(${TABLE}.resolutionTime/.8)/10
          WHEN ${priority} = 'P2 Escalation' THEN  ROUND(${TABLE}.resolutionTime/2.4)/10
          WHEN ${priority} = 'P3 Escalation' THEN  ROUND(${TABLE}.resolutionTime/18.6)/10
          WHEN ${priority} = 'P4 Escalation' THEN  ROUND(${TABLE}.resolutionTime/30.6)/10
          ELSE null
      END
      ;;
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

  dimension: key {
    type: string
    primary_key: yes
    sql: ${TABLE}.id ;;
  }

  dimension: jiraKey {
    link: {
      label: "Review in Jira"
      url: "https://jira.cengage.com/browse/{{value}}"
    }

    sql: ${TABLE}.id ;;
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

  dimension:topDiscipline {
    type: yesno
    sql: ${TABLE}.discipline in ('Accounting','Business Law','Chemistry','Decision Sciences','Economics','Health Science/Nursing','Management','Psychology & Psychotherapy','Taxation','Unspecified') ;;
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


  measure: average_time_in_days {
    label: "Average_open_to_resolution"
    type:  average
    value_format: "0.0"
    sql: ${TABLE}.resolutionTime/24 ;;
    drill_fields: [jiraKey, resolution, status, created_date, acknowledged, last_resolved_date, last_closed_date, age, openresolutionTime]
  }

  #for openresolutionTime
  measure: average_ACKNOWLEDGED_to_resolution_days {
    label: "Average_ACKNOWLEDGED_to_resolution"
    type:  average
    value_format: "0.0"
    sql: ${TABLE}.openresolutionTime/24 ;;
    drill_fields: [jiraKey, resolution, status, created_date, acknowledged, last_resolved_date, last_closed_date, age, openresolutionTime]
  }


  measure: average_closedDay {
    label: "Average_closedDay"
    type:  average
    value_format: "0.0"
    sql: ${TABLE}.closedTime/24 ;;
    #sql:  ${BROWSER_TIME} ;;
  }


  measure: median_closedDay {
    label: "Median_closedDay"
    type:  median
    value_format: "0.0"
    sql: ${TABLE}.closedTime/24 ;;
    #sql:  ${BROWSER_TIME} ;;
  }

  measure: count_distinct {
    label: "IssuesDistinct"
    type: count_distinct
    sql: ${key};;
    drill_fields: [jiraKey,  priority, created_date, resolution, status, last_resolved_date, last_closed_date, age]
  }

  measure: count {
    label: "IssuesAll"
    type: count
    drill_fields: [jiraKey,  priority, created_date, resolution, status, last_resolved_date, last_closed_date, age]
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
