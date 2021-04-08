view: dim_instructor {
  sql_table_name: DW_DEVMATH.DIM_INSTRUCTOR ;;

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

  dimension: instructor {
    type: string
    sql: ${TABLE}.INSTRUCTOR ;;
  }

  dimension: instructor_guid {
    type: string
    sql: ${TABLE}.INSTRUCTOR_GUID ;;
  }

  dimension: instructorid {
    type: string
    sql: ${TABLE}.INSTRUCTORID ;;
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

  measure: count {
    type: count
    drill_fields: []
  }
}
