connection: "snowflake_jira"
case_sensitive: no

include: "/views/*.explore.lkml"

include: "/views/common_hidden_fields.view"

view: +common_hidden_fields {
  dimension_group: _fivetran_synced {hidden:yes}
}

view: +root {
  extends: []
}

# include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }
