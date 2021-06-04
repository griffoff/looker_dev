# view: dim_productplatform {
#   sql_table_name: DW_DEVMATH.DIM_PRODUCTPLATFORM ;;

#   dimension: dw_ldid {
#     type: string
#     sql: ${TABLE}.DW_LDID ;;
#   }

#   dimension_group: dw_ldts {
#     type: time
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: ${TABLE}.DW_LDTS ;;
#   }

#   dimension: is_platform {
#     type: string
#     sql: ${TABLE}.IS_PLATFORM ;;
#   }

#   dimension: productplatform {
#     type: string
#     sql: ${TABLE}.PRODUCTPLATFORM ;;
#   }

#   dimension: productplatformid {
#     type: string
#     sql: ${TABLE}.PRODUCTPLATFORMID ;;
#   }

#   measure: count {
#     type: count
#     drill_fields: []
#   }
# }
