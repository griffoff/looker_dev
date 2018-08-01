connection: "snowflake_int"
label: "ROYALTIES"
#include: "*.view.lkml"  # include all views in this project
#include: "*.dashboard.lookml"  # include all dashboards in this project

include: "sub_event_.view.lkml"

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

explore: sub_event_ {
  from: sub_event_
  label: "sub_event_"
  }