view: fact_activity {
  label: "Activity"
  sql_table_name: DW_DEVMATH.FACT_ACTIVITY ;;

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.ID ;;
  }

  dimension: activityid {
    hidden: yes
    type: string
    sql: ${TABLE}.ACTIVITYID ;;
  }

  dimension: courseid {
    hidden: yes
    type: string
    sql: ${TABLE}.COURSEID ;;
  }

  dimension_group: duedate {
    type: time
    timeframes: [raw,date,day_of_week,month,year]
    sql: ${TABLE}.DUEDATE ;;
  }

  dimension: institutionid {
    hidden: yes
    type: string
    sql: ${TABLE}.INSTITUTIONID ;;
  }

  dimension: instructorid {
    hidden: yes
    type: string
    sql: ${TABLE}.INSTRUCTORID ;;
  }

  dimension: normalscore {
    description: "The raw points score"
    label: "Score"
    type: number
    sql: ${TABLE}.NORMALSCORE ;;
  }

  measure: normalscore_avg {
    label: "Score (avg)"
    type: average
    sql: ${normalscore} ;;
    value_format_name: percent_1
  }

  dimension: overridedate {
    type: string
    sql: ${TABLE}.OVERRIDEDATE ;;
  }

  dimension: possiblescore {
    label: "Possible Score"
    type: number
    sql: ${TABLE}.POSSIBLESCORE ;;
  }

  dimension: productid {
    type: string
    sql: ${TABLE}.PRODUCTID ;;
  }

  dimension: scaledscore {
    description: "The % points of possible points"
    label: "Score (avg)"
    type: number
    sql: case when ${TABLE}.SCALEDSCORE > 1 then null else ${TABLE}.SCALEDSCORE end  ;;
    value_format_name: percent_1
  }

  measure: scaledscore_avg {
    label: "% Score (avg)"
    type: average
    sql: ${scaledscore} ;;
    value_format_name: percent_1
  }

  dimension: startdate {
    type: string
    sql: ${TABLE}.STARTDATE ;;
  }

  dimension: startdatekey {
    type: string
    sql: ${TABLE}.STARTDATEKEY ;;
  }

  dimension: studentid {
    type: string
    sql: ${TABLE}.STUDENTID ;;
  }

  dimension: submissiondate {
    type: string
    sql: ${TABLE}.SUBMISSIONDATE ;;
  }

  dimension: timeliness {
    type: number
    sql: ${TABLE}.TIMELINESS_HOUR  / 24.0 ;;
    value_format: "h:mm:ss"
  }

  measure: timeliness_hour_avg {
    label: "Timeliness"
    type: average
    sql: ${timeliness} ;;
    value_format: "h:mm:ss"
  }

  dimension: timespent {
    label: "Time spent"
    type: number
    sql: case when ${TABLE}.TIMESPENT <0 then null else ${TABLE}.TIMESPENT   / 24.0 end ;;
    value_format: "h:mm:ss"
  }

  measure: timespent_hour_avg {
    label: "Time spent (avg)"
    type: average
    sql: ${timespent} ;;
    value_format: "h:mm:ss"
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
