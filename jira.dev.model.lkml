connection: "snowflake_dev"
label: "JIRA DEV"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: escals {
  from: vw_escal_detail
  label: "Alternative Escals"

  join: vw_escal_categories {
    fields: [] # hide all the fields
    sql_on: ${escals.key} = ${vw_escal_categories.key} ;;
    relationship: one_to_many
  }

  join: vw_escal_components {
    fields: []  #hide all the fields
    sql_on: ${escals.key} = ${vw_escal_components.key} ;;
    relationship: one_to_many
  }

  join: dim_date {
    view_label: "Date"
    sql_on: ${escals.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }

  join: all_categories {
    sql: right join all_categories on ${vw_escal_categories.category} = ${all_categories.category} ;;
    relationship: one_to_many
  }

  join: all_priorities {
    sql: right join all_priorities on ${escals.priority} = ${all_priorities.priority} ;;
    relationship: one_to_many
  }

  join: all_products {
    sql: right join all_products on ${vw_escal_components.component} = ${all_products.product} ;;
    relationship: one_to_many
  }

}

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
    sql_on: ${vw_escal_detail.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }

  join: issue_status_last_month{
    sql_on: ${issue_status_last_month.key} = ${vw_escal_detail.key} ;;
    relationship: many_to_many
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

  join: vw_dig_info_categories {
    sql_on: ${vw_dig_info_detail.key} = ${vw_dig_info_categories.key} ;;
    relationship: one_to_many
  }

  join: vw_dig_info_components {
    sql_on: ${vw_dig_info_detail.key} = ${vw_dig_info_components.key} ;;
    relationship: one_to_many
  }

}

# for work with ESCAL Summary Report
#  explore: vw_escal_detail_dummy {
#    label: "ESCAL Summary Report"
explore: vw_escal_statuses{
    label: "ESCAL Summary Report"

    join: vw_escal_issue_resolved {
      type: left_outer
      relationship: one_to_many
      sql_on: ${vw_escal_issue_resolved.issue_id} = ${vw_escal_statuses.key} ;;
    }

}


# for work with ESCAL Summary Report
#  explore: vw_escal_detail_dummy {
#    label: "ESCAL Summary Report"
explore: vw_escal_detail_dummy{
  label: "ESCAL Summary Report DEV"

  join: vw_escal_issue_resolved {
    type: left_outer
    relationship: one_to_many
    sql_on: ${vw_escal_issue_resolved.issue_id} = ${vw_escal_detail_dummy.key} ;;
  }

}
