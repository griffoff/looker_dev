# view: fact_learningobjective {
#   label: "Learning Objective"
#   sql_table_name: DW_DEVMATH.FACT_LEARNINGOBJECTIVE ;;

#   dimension: id {
#     hidden: yes
#     primary_key: yes
#     type: string
#     sql: ${TABLE}.ID ;;
#   }

#   dimension: activityid {
#     hidden: yes
#     type: string
#     sql: ${TABLE}.ACTIVITYID ;;
#   }

#   dimension: activitystartdatekey {
#     hidden: yes
#     type: string
#     sql: ${TABLE}.ACTIVITYSTARTDATEKEY ;;
#   }

#   dimension: checkin_mastery {
#     label: "Check-in mastery"
#     type: number
#     sql: ${TABLE}.CHECKIN_MASTERY ;;
#     value_format_name: percent_1
#   }

#   measure: checkin_mastery_avg {
#     label: "Check-in mastery (avg)"
#     type: average
#     sql: ${checkin_mastery} ;;
#     value_format_name: percent_1
#   }

#   dimension: courseid {
#     hidden: yes
#     type: string
#     sql: ${TABLE}.COURSEID ;;
#   }

#   dimension: institutionid {
#     hidden: yes
#     type: string
#     sql: ${TABLE}.INSTITUTIONID ;;
#   }

#   dimension: instructorid {
#     hidden: yes
#     type: string
#     sql: ${TABLE}.INSTRUCTORID ;;
#   }

#   dimension: learningobjectiveid {
#     hidden: yes
#     type: string
#     sql: ${TABLE}.LEARNINGOBJECTIVEID ;;
#   }

#   dimension: data_age {
#     group_label: "Data stats"
#     label: "Data Age"
#     type: number
#     sql: datediff(minute, ${TABLE}.LOADDATE, current_timestamp())/86400.0 ;;
#     value_format: "h:mm:ss"
#   }

#   measure: data_age_max {
#     group_label: "Data stats"
#     label: "Data Age (max)"
#     type: max
#     sql: ${data_age} ;;
#     value_format: "h:mm:ss"
#   }

#   measure: data_age_avg {
#     group_label: "Data stats"
#     label: "Data Age (avg)"
#     type: average
#     sql: ${data_age} ;;
#     value_format: "h:mm:ss"
#   }

#   dimension: mastery {
#     type: number
#     sql: ${TABLE}.MASTERY ;;
#     value_format_name: percent_1
#     description: "This is what mastery means"
#   }

#   measure: mastery_avg {
#     label: "Mastery (avg)"
#     type: average
#     sql: ${mastery} ;;
#     value_format_name: percent_1
#   }

#   dimension: productid {
#     type: string
#     sql: ${TABLE}.PRODUCTID ;;
#     hidden: yes
#   }

#   dimension: studentid {
#     type: string
#     sql: ${TABLE}.STUDENTID ;;
#     hidden: yes
#   }

#   measure: count {
#     type: count
#     drill_fields: [id]
#   }
# }
