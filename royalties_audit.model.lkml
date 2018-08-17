connection: "snowflake_prod"
label: "Royalties Audit and Unlimited"

# include all the CU views
include: "*.view.lkml"
include: "dim_date.view"

# include all the dashboards
#include: "*.dashboard.lookml"  # include all dashboards in this project

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

explore: dim_date {}

explore: number_of_sub_per_day {
  from: number_of_sub_per_day
  label: "number_of_sub_per_day"

}
