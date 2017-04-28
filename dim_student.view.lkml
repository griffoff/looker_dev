view: dim_student {
  sql_table_name: DW_DEVMATH.DIM_STUDENT ;;

  dimension: active {
    type: string
    sql: ${TABLE}.ACTIVE ;;
  }

  dimension_group: enddate {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    sql: ${TABLE}.ENDDATE ;;
  }

  dimension_group: ldts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.LDTS ;;
  }

  dimension: rsrc {
    type: string
    sql: ${TABLE}.RSRC ;;
  }

  dimension_group: startdate {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    sql: ${TABLE}.STARTDATE ;;
  }

  dimension: student {
    type: string
    sql: ${TABLE}.STUDENT ;;
  }

  dimension: student_guid {
    type: string
    sql: ${TABLE}.STUDENT_GUID ;;
  }

  dimension: studentid {
    type: string
    sql: ${TABLE}.STUDENTID ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
