connection: "snowflake_dev"
label: "JIRA_DIG"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: vw_dig_info_detail {
  label: "DIG"

  join: vw_dig_info_categories {
    sql_on: ${vw_dig_info_detail.key} = ${vw_dig_info_categories.key} ;;
    relationship: one_to_many
  }

  join: vw_dig_info_components {
    sql_on: ${vw_dig_info_detail.key} = ${vw_dig_info_components.key} ;;
    relationship: one_to_many
  }

  join: dim_date {
    sql_on: ${vw_dig_info_detail.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }
}
