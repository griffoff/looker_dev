view: vw_escal_detail_dummy  {
  derived_table: {
    sql: (
with details_categories as (
  select
      det.key,
      det.priority,
      det.CREATED,
      det.LAST_CLOSED,
      det.LAST_RESOLVED,
      cat.category
  from escal.vw_escal_detail det
  left join escal.vw_escal_categories cat on det.key=cat.key
                            )
,cut_details_categories_components as (
  select
    dc.key as key,
    dc.priority as priority,
      dc.CREATED as CREATED,
      dc.LAST_CLOSED as LAST_CLOSED,
      dc.LAST_RESOLVED as LAST_RESOLVED,
    case when dc.category is null then  'No Category' else  dc.category end as category,
    -- replace null on 'No Category'
    com.component  as component
  from details_categories as dc
  left  join escal.VW_ESCAL_COMPONENTS com on dc.key=com.key
                                        )
,category as (
  select distinct
    case when cat.category is null then  'No Category' else  cat.category end as category
  from escal.VW_ESCAL_DETAIL det
  LEFT OUTER JOIN escal.vw_escal_categories cat on det.key = cat.key
              )
,priority as (
  select distinct
      priority
  from escal.vw_escal_detail
              )
,category_priority as (
  select
      category
    , priority
  from category
  cross join priority
                      )
,product as (
  select distinct
    COMPONENT as product
  from escal.VW_ESCAL_COMPONENTS
            )
,category_priority_component as  (
  select
      category_priority.category
    , category_priority.priority
    , product
  from category_priority
  cross join product
                                  )
,dummy as (
      -- create dummy issue as CROSS JOIN  category x product x priority
      -- dummy issue has prefix 'dummy-'
      -- dummy issue has prefix 'dummy-'
  select
    CONCAT('dummy-',(ROW_NUMBER() OVER ( ORDER BY category))::string) AS key
    ,priority
    ,category
    ,product as component
  from category_priority_component
          )
select
   key,
   priority,
   category,
    CREATED,
    LAST_CLOSED,
    LAST_RESOLVED,
   component
from cut_details_categories_components
  union
select
   key,
   priority,
   category,
    CURRENT_TIMESTAMP::TIMESTAMP_TZ as CREATED,
  null as LAST_CLOSED,
  null as LAST_RESOLVED,
   component
from dummy
               )
            ;;
  }

      dimension: key {
        type: string
        primary_key: yes
        sql: ${TABLE}.key ;;
      }

  dimension: jiraKey {
    link: {
      label: "Review in Jira"
      url: "https://jira.cengage.com/browse/{{value}}"
    }

    sql: ${TABLE}.KEY ;;
  }


  dimension: priority {
    type: string
    sql: ${TABLE}.priority ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: component {
    type: string
    sql: ${TABLE}.component ;;
  }

  dimension:topSystem {
    type: yesno
    sql: ${TABLE}.COMPONENT in ('MindTap','SSO/OLR','CL Homework','DevMath','Gradebook','Mobile','MTQ','CNOW','CNOW MindApp','CNOW v7','CNOW v8','Aplia','CXP','OWL v2','OWL v1','SAM','4LTR Press Online','CengageBrain.com','SSO Account Services') ;;
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

  dimension: resolutionStatus {
    view_label: "Is Resolved?"
    type: yesno
    sql: ${last_resolved_raw} is not null ;;
  }


  dimension: resolutionStatus_Resolved_New {
    view_label: "Is Resolved?"
    type: string
    sql: case when ${last_resolved_raw} is not null then 'Resolved' else 'New' end ;;
  }

  measure: count_notresolved {
    label: "# Outstanding"
    type:  count_distinct
    drill_fields: [jiraKey,  priority, created_date, resolutionStatus, last_resolved_date]
    link: {
      label: "Look at Content Aging Data"
      url: "https://cengage.looker.com/dashboards/37?Category=%25Content%20Development%25"
    }
    link: {
      label: "Look at Software Aging Data"
      url: "https://cengage.looker.com/dashboards/37?Category=%25Software%25"
    }
    sql: case when (${last_resolved_raw} is null) and NOT (CONTAINS(${key}, 'dummy')) then ${key} end;;
  }


  measure: count_resolved {
    label: "# Resolved"
    type:  count_distinct
    drill_fields: [jiraKey,  priority, created_date, resolutionStatus, last_resolved_date]
    link: {
      label: "Look at Content Aging Data"
      url: "https://cengage.looker.com/dashboards/37?Category=%25Content%20Development%25"
    }
    link: {
      label: "Look at Software Aging Data"
      url: "https://cengage.looker.com/dashboards/37?Category=%25Software%25"
    }
    sql: case when ( NOT (CONTAINS(${key}, 'dummy')) ) then ${key} end;;
    #sql: case when (${last_resolved_raw} is not null) and NOT (CONTAINS(${key}, 'dummy')) then ${key} else  ${key} end;;
  }

    measure: count {
    label: " # Issues"
    type: count
    drill_fields: [jiraKey,  priority, created_date, resolutionStatus, last_resolved_date]
    link: {
      label: "Look at Content Aging Data"
      url: "https://cengage.looker.com/dashboards/37?Category=%25Content%20Development%25"
    }
    link: {
      label: "Look at Software Aging Data"
      url: "https://cengage.looker.com/dashboards/37?Category=%25Software%25"
          }
    }
#  measure: count {
#    type: count
 #   drill_fields: [key, priority, category, component]

 # }

    }
