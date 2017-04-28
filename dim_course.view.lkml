view: dim_course {
  sql_table_name: DW_DEVMATH.DIM_COURSE ;;

  dimension: active {
    type: string
    sql: ${TABLE}.ACTIVE ;;
  }

  dimension: cgi {
    type: string
    sql: ${TABLE}.CGI ;;
  }

  dimension: courseid {
    type: string
    sql: ${TABLE}.COURSEID ;;
  }

  dimension: coursekey {
    type: string
    sql: ${TABLE}.COURSEKEY ;;
  }

  dimension: coursename {
    type: string
    sql: ${TABLE}.COURSENAME ;;
  }

  dimension: coursetitle {
    type: string
    sql: ${TABLE}.COURSETITLE ;;
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

  dimension: enddatekey {
    type: string
    sql: ${TABLE}.ENDDATEKEY ;;
  }

  dimension: endtime {
    type: string
    sql: ${TABLE}.ENDTIME ;;
  }

  dimension: institutionid {
    type: string
    sql: ${TABLE}.INSTITUTIONID ;;
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

  dimension: productid {
    type: string
    sql: ${TABLE}.PRODUCTID ;;
  }

  dimension: rsrc {
    type: string
    sql: ${TABLE}.RSRC ;;
  }

  dimension: sso_entity_id {
    type: string
    sql: ${TABLE}.SSO_ENTITY_ID ;;
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

  dimension: startdatekey {
    type: string
    sql: ${TABLE}.STARTDATEKEY ;;
  }

  dimension: starttime {
    type: string
    sql: ${TABLE}.STARTTIME ;;
  }

  measure: count {
    type: count
    drill_fields: [coursename]
  }
}
