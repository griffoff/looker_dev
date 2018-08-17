connection: "snowflake_prod"

include: "cu*.view.lkml"         # include all CU views in this project
include: "dim_date.view.lkml"
#include: "cu*.dashboard.lookml"  # include all CU dashboards in this project

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
