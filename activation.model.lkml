connection: "snowflake_prod"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

# test

named_value_format: duration_hms {
  value_format: "hh:mm:ss"
}

explore: dim_user_v{
  label: "Dim user"
}
