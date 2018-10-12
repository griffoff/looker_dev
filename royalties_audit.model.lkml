connection: "snowflake_int"
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



explore: cu_enrollment_events {
  from: cu_enrollment_events
  label: "cu_enrollment_events"

}

explore: cu_raw_olr_raw_mt_resource_interactions {
  from: cu_raw_olr_raw_mt_resource_interactions
  label: "cu_raw_olr_raw_mt_resource_interactions"

}

explore: cu_raw_olr_stg_clts_products_v {
  from: cu_raw_olr_stg_clts_products_v
  label: "cu_raw_olr_stg_clts_products_v"

}

explore: cu_raw_vitalsource_event {
  from: cu_raw_vitalsource_event
  label: "cu_raw_vitalsource_event"

}

explore: ra_check {
  from: ra_check
  label: "ra_check"

}


explore: check_script {
  from: check_script
  label: "check_script"

}

explore: prov_prod {
  # from: prov_prod
  label: "prov_prod"
}

explore: usage {
  # from: usage
  label: "usage"

}
explore: usage_ra {
  # from: usage_ra
  label: "usage_ra"

}
