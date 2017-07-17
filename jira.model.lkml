connection: "snowflake_dev"
label: "JIRA"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: vw_escal_detail {
  label: "Escals"

  join: vw_escal_categories {
    sql_on: ${vw_escal_detail.key} = ${vw_escal_categories.key} ;;
    relationship: one_to_many
  }

  join: vw_escal_components {
    sql_on: ${vw_escal_detail.key} = ${vw_escal_components.key} ;;
    relationship: one_to_many
  }

  join: dim_date {
    view_label: "Date"
    sql_on: ${vw_escal_detail.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }

  join: issue_status_last_month{
    sql_on: ${issue_status_last_month.key} = ${vw_escal_detail.key} ;;
    relationship: many_to_many
  }

  join: issue_escal_resolved {
    type: left_outer
    relationship: many_to_many
    sql_on: ${issue_escal_resolved.issue_id} = ${vw_escal_detail.key} ;;
  }


}

# for work with DIG
explore: vw_dig_info_detail {
  label: "DIG"


  join: vw_dig_info_changelog {
    sql_on: ${vw_dig_info_detail.key} = ${vw_dig_info_changelog.key} ;;
    relationship: one_to_many
  }

  join: dim_date {
    view_label: "Date"
    sql_on: ${vw_dig_info_changelog.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }

  join: issue_closures {
    type: left_outer
    relationship: many_to_many
    sql_on: ${issue_closures.issue_id} = ${vw_dig_info_detail.key} ;;
  }


}
