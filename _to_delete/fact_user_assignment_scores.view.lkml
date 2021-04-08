view: fact_user_assignment_scores {
  sql_table_name: DW_DEVMATH.FACT_USER_ASSIGNMENT_SCORES ;;

  dimension: activitytitle {
    type: string
    sql: ${TABLE}.ACTIVITYTITLE ;;
  }

  dimension: courseid {
    type: string
    sql: ${TABLE}.COURSEID ;;
  }

  dimension: coursename {
    type: string
    sql: ${TABLE}.COURSENAME ;;
  }

  dimension: duedate_type {
    type: string
    sql: ${TABLE}.DUEDATE_TYPE ;;
  }

  dimension: institutionid {
    type: string
    sql: ${TABLE}.INSTITUTIONID ;;
  }

  dimension: instructorid {
    type: string
    sql: ${TABLE}.INSTRUCTORID ;;
  }

  dimension: maxnormalscore {
    type: number
    sql: ${TABLE}.MAXNORMALSCORE ;;
  }

  dimension: productid {
    type: string
    sql: ${TABLE}.PRODUCTID ;;
  }

  dimension: studentid {
    type: string
    sql: ${TABLE}.STUDENTID ;;
  }

  dimension: sumtimespent_min {
    type: number
    sql: ${TABLE}.SUMTIMESPENT_MIN ;;
  }

  dimension: timeliness_sec {
    type: string
    sql: ${TABLE}.TIMELINESS_SEC ;;
  }

  measure: count {
    type: count
    drill_fields: [coursename]
  }
}
