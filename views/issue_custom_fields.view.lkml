include: "/base/common_includes.lkml"

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
      select
        issue_id
        , max(case when f.NAME = 'Time to Close' then ifhc.value end)  as time_to_close
        , max(case when f.NAME = 'Story Points' then ifhc.value end)  as story_points
        , max(case when f.NAME = 'SSO ISBN 13' then ifhc.value end)  as sso_isbn13
        , max(case when f.NAME = 'SF Ticket Status' then ifhc.value end)  as sf_ticket_status
        , max(case when f.NAME = 'Product(s)' then ifhc.value end)  as products
        , max(case when f.NAME = 'Product Owner' then ifhc.value end)  as product_owner
        , max(case when f.NAME = 'Product Manager_' then ifhc.value end)  as product_manager_
        , max(case when f.NAME = 'Product Group_' then ifhc.value end)  as product_group_
        , max(case when f.NAME = 'Last Resolution Date' then ifhc.value end)  as last_resolution_date
        , max(case when f.NAME = 'Last Closure User' then ifhc.value end)  as last_closure_user
        , max(case when f.NAME = 'Last Closure Date' then ifhc.value end)  as last_closure_date
        , max(case when f.NAME = 'Labels' then ifhc.value end)  as labels
        , max(case when f.NAME = 'Issue Category' then ifhc.value end)  as issue_category
        , max(case when f.NAME = 'ESC-COMP' then ifhc.value end)  as esc_comp
        , max(case when f.NAME = 'Epic/Theme' then ifhc.value end)  as epic_theme
        , max(case when f.NAME = 'Discipline Minor' then ifhc.value end)  as discipline_minor
        , max(case when f.NAME = 'Discipline Major' then ifhc.value end)  as discipline_major
        , max(case when f.NAME = 'Customer Reported ISBN' then ifhc.value end)  as customer_reported_isbn
        , max(case when f.NAME = 'Customer Institution' then ifhc.value end)  as customer_institution
        , max(case when f.NAME = 'Course Key' then ifhc.value end)  as course_key
        , max(case when f.NAME = 'Core ISBN' then ifhc.value end)  as core_isbn
        , max(case when f.NAME = 'Content Manager' then ifhc.value end)  as content_manager
        , max(case when f.NAME = 'Case Number' then ifhc.value end)  as case_number
      from ${issue_field_history_combined.SQL_TABLE_NAME} ifhc
      inner join ${field.SQL_TABLE_NAME} f on f.id = ifhc.field_id
      where ifhc._latest
      group by 1
    ;;
    datagroup_trigger: issue_field_history_combined_trigger
  }

  dimension: issue_id {primary_key:yes}
  dimension: time_to_close {}
  dimension: story_points {}
  dimension: sso_isbn13 {}
  dimension: sf_ticket_status {}
  dimension: products {}
  dimension: product_owner {}
  dimension: product_manager_ {}
  dimension: product_group_ {}

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
  dimension: issue_category {}
  dimension: esc_comp {}
  dimension: epic_theme {}
  dimension: discipline_minor {}
  dimension: discipline_major {}
  dimension: customer_reported_isbn {}
  dimension: customer_institution {}
  dimension: course_key {}
  dimension: core_isbn {}
  dimension: content_manager {}
  dimension: case_number {}

}
