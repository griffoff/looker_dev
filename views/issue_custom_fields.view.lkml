include: "/base/common_includes.lkml"
include: "issue.view"
include: "issue_field_history_combined.view"
include: "field.view"
include: "issue_link.view"
include: "field_option.view"

explore: issue_custom_fields{
  hidden: yes
  extends: [root]

  join:issue_custom_fields {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: issue_custom_fields {
  derived_table: {
    publish_as_db_view: yes
    sql:
      -- with custom_fields as (
        select
          i.id as issue_id
          , max(case when f.NAME = 'Total Invoiced' then ifhc.value end)  as total_invoiced
          , max(case when f.NAME = 'Total Count' then ifhc.value end)  as total_count
          , max(case when f.NAME = 'Total Cost' then ifhc.value end)  as total_cost
          , max(case when f.NAME = 'Time to Close' then ifhc.value end)  as time_to_close
          , max(case when f.NAME = 'Team' then ifhc.value end)  as team
          , max(case when f.NAME = 'Target start' then ifhc.value end)  as target_start
          , max(case when f.NAME = 'Target end' then ifhc.value end)  as target_end
          , max(case when f.NAME = 'Story Points' then ifhc.value end)  as story_points
          , max(case when f.NAME = 'Status' then ifhc.value end)  as status
          , max(case when f.NAME = 'Start Date' then ifhc.value end)  as start_date
          , max(case when f.NAME = 'SSO ISBN 13' then ifhc.value end)  as sso_isbn13
          , max(case when f.NAME = 'SSO ISBN' then ifhc.value end)  as sso_isbn
          , max(case when f.NAME = 'Sprint' then ifhc.value end)  as sprint
          , max(case when f.NAME = 'SF To Jira Production Case Reference' then ifhc.value end)  as sf_to_jira_production_case_reference
          , max(case when f.NAME = 'SF Ticket Status' then ifhc.value end)  as sf_ticket_status
          , max(case when f.NAME = 'Resolution' then ifhc.value end)  as resolution
          , max(case when f.NAME = 'Release Deliverables' then ifhc.value end)  as release_deliverables
          , max(case when f.NAME = 'QA Vendor' then ifhc.value end)  as qa_vendor
          , max(case when f.NAME = 'Product(s)' then ifhc.value end)  as products
          , max(case when f.NAME = 'Product Owner' then ifhc.value end)  as product_owner
          , max(case when f.NAME = 'Product Manager_' then ifhc.value end)  as product_manager_
          , max(case when f.NAME = 'Product Manager_ Report' then ifhc.value end)  as product_manager_report
          , max(case when f.NAME = 'Product Group_' then ifhc.value end)  as product_group_
          , max(case when f.NAME = 'Part of PO?' then ifhc.value end)  as part_of_po
          , max(case when f.NAME = 'Last Resolution Date' then ifhc.value end)  as last_resolution_date
          , max(case when f.NAME = 'Last In Progress' then ifhc.value end)  as last_in_progress
          , max(case when f.NAME = 'Last Closure User' then ifhc.value end)  as last_closure_user
          , max(case when f.NAME = 'Last Closure Date' then ifhc.value end)  as last_closure_date
          , max(case when f.NAME = 'Labels' then ifhc.value end)  as labels
          , max(case when f.NAME = 'Item ID' then ifhc.value end)  as item_id
          , max(case when f.NAME = 'Issue Category' then ifhc.value end)  as issue_category
          , max(case when f.NAME = 'ESC-COMP' then ifhc.value end)  as esc_comp
          , max(case when f.NAME = 'Epic/Theme' then ifhc.value end)  as epic_theme
          , max(case when f.NAME = 'Epic Link' then ifhc.value end)  as epic_link
          , max(case when f.NAME = 'Due Date' then ifhc.value end)  as due_date
          , max(case when f.NAME = 'Discipline' then ifhc.value end)  as discipline
          , max(case when f.NAME = 'Discipline Minor' then ifhc.value end)  as discipline_minor
          , max(case when f.NAME = 'Discipline Major' then ifhc.value end)  as discipline_major
          , max(case when f.NAME = 'Customer Reported ISBN' then ifhc.value end)  as customer_reported_isbn
          , max(case when f.NAME = 'Customer Institution' then ifhc.value end)  as customer_institution
          , max(case when f.NAME = 'Course Key' then ifhc.value end)  as course_key
          , max(case when f.NAME = 'Core ISBN' then ifhc.value end)  as core_isbn
          , max(case when f.NAME = 'Content Type' then ifhc.value end)  as content_type
          , max(case when f.NAME = 'Content Manager' then ifhc.value end)  as content_manager
          , max(case when f.NAME = 'Content Error Type' then ifhc.value end)  as content_error_type
          , max(case when f.NAME = 'Component/s' then ifhc.value end)  as components
          , max(case when f.NAME = 'Case Number' then ifhc.value end)  as case_number
          , max(case when f.NAME = 'Bucket' then ifhc.value end)  as bucket
          , max(case when f.NAME = 'Billing ISBN' then ifhc.value end)  as billing_isbn
          , max(case when f.NAME = 'Aha! Release' then ifhc.value end)  as aha_release
          , nullif(listagg(distinct case when il.relationship = 'Depends On' then ri.key end,', ')
              within group(order by case when il.relationship = 'Depends On' then ri.key end),'') as depends_on
          , nullif(listagg(distinct case when il.relationship = 'Duplicates' then ri.key end,', ')
              within group(order by case when il.relationship = 'Duplicates' then ri.key end),'') as duplicates
          , nullif(listagg(distinct case when il.relationship = 'is a story of' then ri.key end,', ')
              within group(order by case when il.relationship = 'is a story of' then ri.key end),'') as is_a_story_of
          , nullif(listagg(distinct case when il.relationship = 'is Cloned from' then ri.key end,', ')
              within group(order by case when il.relationship = 'is Cloned from' then ri.key end),'') as is_cloned_from
          , nullif(listagg(distinct case when il.relationship = 'is related to' then ri.key end,', ')
              within group(order by case when il.relationship = 'is related to' then ri.key end),'') as is_related_to

        from ${issue.SQL_TABLE_NAME} i
        left join ${issue_field_history_combined.SQL_TABLE_NAME} ifhc on ifhc.issue_id = i.id  and ifhc._latest
        left join ${field.SQL_TABLE_NAME} f on f.id = ifhc.field_id
        left join ${issue_link.SQL_TABLE_NAME} il on il.issue_id = i.id
        left join ${issue.SQL_TABLE_NAME} ri on ri.id = il.related_issue_id
        group by 1
    ;;
    datagroup_trigger: issue_field_history_combined_trigger
  }

  dimension: issue_id {primary_key:yes hidden:yes}

  dimension: total_invoiced {}
  dimension: total_count {}
  dimension: total_cost {}
  dimension: time_to_close {}
  dimension: team {}

  dimension_group: target_start {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}.target_start AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: target_end {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}.target_end AS TIMESTAMP_NTZ) ;;
  }

  dimension: story_points {}
  dimension: status {}

  dimension_group: start {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}.start_date AS TIMESTAMP_NTZ) ;;
  }

  dimension: sso_isbn13 {label:"SSO ISBN 13"}
  dimension: sso_isbn {label:"SSO ISBN"}
  dimension: sprint {}
  dimension: sf_to_jira_production_case_reference {label:"SF to Jira Production Case Reference"}
  dimension: sf_ticket_status {label:"SF Ticket Status"}
  dimension: resolution {}
  dimension: release_deliverables {}
  dimension: qa_vendor {label:"QA Vendor"}
  dimension: products {}
  dimension: product_owner {}
  dimension: product_manager_ {label:"Product Manager_"}
  dimension: product_manager_report {label:"Product Manager_ Report"}
  dimension: product_group_ {label:"Product Group_"}
  dimension: part_of_po {label:"Part of PO?"}

  dimension_group: last_resolution {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}.last_resolution_date AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: last_in_progress {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}.last_in_progress AS TIMESTAMP_NTZ) ;;
  }

  dimension: last_closure_user {}

  dimension_group: last_closure {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}.last_closure_date AS TIMESTAMP_NTZ) ;;
  }

  dimension: labels {}
  dimension: item_id {label:"Item ID"}
  dimension: issue_category {}
  dimension: esc_comp {label:"ESC-COMP"}
  dimension: epic_theme {label:"Epic/Theme"}
  dimension: epic_link {}

  dimension_group: due {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}.due_date AS TIMESTAMP_NTZ) ;;
  }

  dimension: discipline {}
  dimension: discipline_minor {}
  dimension: discipline_major {}
  dimension: customer_reported_isbn {label:"Customer Reported ISBN"}
  dimension: customer_institution {}
  dimension: course_key {}
  dimension: core_isbn {label:"Core ISBN"}
  dimension: content_type {}
  dimension: content_manager {}
  dimension: content_error_type {}
  dimension: components {}
  dimension: case_number {}
  dimension: bucket {}
  dimension: billing_isbn {label:"Billing ISBN"}
  dimension: aha_release {label:"Aha! Release"}

  dimension: is_related_to {group_label:"Issue Links"}
  dimension: is_cloned_from {group_label:"Issue Links"}
  dimension: is_a_story_of {group_label:"Issue Links"}
  dimension: depends_on {group_label:"Issue Links"}
  dimension: duplicates {group_label:"Issue Links"}



}
