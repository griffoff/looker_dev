connection: "snowflake_dev"
label: "JIRA_DIG"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

# for work with DIG
explore: vw_dig_info_detail {
  label: "DIG"

}
