connection: "snowflake_prod"
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
}

# for work with ESCAL Summary Report
#  explore: vw_escal_detail_dummy {
#    label: "ESCAL Summary Report"
explore: vw_escal_detail_dummy{
  label: "ESCAL Summary Report PROD"

  join: vw_escal_issue_resolved {
    type: left_outer
    relationship: one_to_many
    sql_on: ${vw_escal_issue_resolved.issue_id} = ${vw_escal_detail_dummy.key} ;;
  }

}
