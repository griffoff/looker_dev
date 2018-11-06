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

datagroup: mt {
  sql_trigger: SELECT COUNT(*) FROM cap_er.prod.RAW_MT_RESOURCE_INTERACTIONS ;;
  max_cache_age: "12 hours"
}

datagroup: clts_products_v {
  sql_trigger: SELECT COUNT(*) FROM prod.STG_CLTS.PRODUCTS_V ;;
  max_cache_age: "12 hours"
}


explore: cu_raw_olr_raw_mt_resource_interactions {
  persist_with: mt
  from: cu_raw_olr_raw_mt_resource_interactions
  label: "cu_raw_olr_raw_mt_resource_interactions"

}

explore: cu_raw_olr_stg_clts_products_v {
  persist_with: clts_products_v
  from: cu_raw_olr_stg_clts_products_v
  label: "cu_raw_olr_stg_clts_products_v"

}

explore: cu_enrollment_events {
  from: cu_enrollment_events
  label: "cu_enrollment_events"

}
explore: cu_raw_vitalsource_event {
  from: cu_raw_vitalsource_event
  label: "cu_raw_vitalsource_event"

}



explore: prov_prod {
  # from: prov_prod
  label: "prov_prod"
}



explore: ra_usage {
  # from: ra_usage
  label: "ra_usage"

}

explore: check_script_2 {
  # from: check_script_2
  label: "check_script_2"

}
