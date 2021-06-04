# view: dim_time {
#   sql_table_name: DW_DEVMATH.DIM_TIME ;;

#   dimension: ampm {
#     type: string
#     sql: ${TABLE}.AMPM ;;
#   }

#   dimension: hour {
#     type: string
#     sql: ${TABLE}.HOUR ;;
#   }

#   dimension: hour24 {
#     type: string
#     sql: ${TABLE}.HOUR24 ;;
#   }

#   dimension: minute {
#     type: string
#     sql: ${TABLE}.MINUTE ;;
#   }

#   dimension: time {
#     type: string
#     sql: ${TABLE}.TIME ;;
#   }

#   dimension: timekey {
#     type: string
#     sql: ${TABLE}.TIMEKEY ;;
#   }

#   measure: count {
#     type: count
#     drill_fields: []
#   }
# }
