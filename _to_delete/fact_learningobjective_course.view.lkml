# view: fact_learningobjective_course {
#   sql_table_name: DW_DEVMATH.FACT_LEARNINGOBJECTIVE_COURSE ;;

#   dimension: activitytitle {
#     type: string
#     sql: ${TABLE}.ACTIVITYTITLE ;;
#   }

#   dimension: courseid {
#     type: string
#     sql: ${TABLE}.COURSEID ;;
#   }

#   dimension: institutionid {
#     type: string
#     sql: ${TABLE}.INSTITUTIONID ;;
#   }

#   dimension: instructorid {
#     type: string
#     sql: ${TABLE}.INSTRUCTORID ;;
#   }

#   dimension: learningobjective {
#     type: string
#     sql: ${TABLE}.LEARNINGOBJECTIVE ;;
#   }

#   dimension: mastery {
#     type: string
#     sql: ${TABLE}.MASTERY ;;
#   }

#   dimension: mastery_checkin {
#     type: string
#     sql: ${TABLE}.MASTERY_CHECKIN ;;
#   }

#   dimension: non_mastery {
#     type: string
#     sql: ${TABLE}.NON_MASTERY ;;
#   }

#   dimension: non_mastery_checkin {
#     type: string
#     sql: ${TABLE}.NON_MASTERY_CHECKIN ;;
#   }

#   dimension: productid {
#     type: string
#     sql: ${TABLE}.PRODUCTID ;;
#   }

#   dimension: studentcount {
#     type: string
#     sql: ${TABLE}.STUDENTCOUNT ;;
#   }

#   measure: count {
#     type: count
#     drill_fields: []
#   }
# }
