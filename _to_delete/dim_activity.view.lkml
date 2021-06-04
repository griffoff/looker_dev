# view: dim_activity {
#   sql_table_name: DW_DEVMATH.DIM_ACTIVITY ;;
#   label: "Activity"

#   dimension: active {
#     type: string
#     sql: ${TABLE}.ACTIVE = 1;;
#   }

#   dimension: activitydescription {
#     type: string
#     sql: ${TABLE}.ACTIVITYDESCRIPTION ;;
#   }

#   dimension: activityid {
#     type: string
#     sql: ${TABLE}.ACTIVITYID ;;
#   }

#   dimension: activitysort {
#     type: string
#     sql: ${TABLE}.ACTIVITYSORT ;;
#   }

#   dimension: activitytitle {
#     type: string
#     sql: ${TABLE}.ACTIVITYTITLE ;;
#   }

#   dimension: activitytype {
#     type: string
#     sql: ${TABLE}.ACTIVITYTYPE ;;
#   }

#   dimension: cgi {
#     type: string
#     sql: ${TABLE}.CGI ;;
#   }

#   dimension_group: enddate {
#     type: time
#     timeframes: [
#       raw,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     convert_tz: no
#     sql: ${TABLE}.ENDDATE ;;
#   }

#   dimension_group: ldts {
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
#     sql: ${TABLE}.LDTS ;;
#   }

#   dimension: rsrc {
#     type: string
#     sql: ${TABLE}.RSRC ;;
#   }

#   dimension_group: startdate {
#     type: time
#     timeframes: [
#       raw,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     convert_tz: no
#     sql: ${TABLE}.STARTDATE ;;
#   }

#   measure: count {
#     type: count
#     drill_fields: []
#   }
# }
