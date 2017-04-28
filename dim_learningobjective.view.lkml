view: dim_learningobjective {
  label: "Learning Objective"
  sql_table_name: DW_DEVMATH.DIM_LEARNINGOBJECTIVE ;;

  dimension: active {
    type: yesno
    sql: ${TABLE}.ACTIVE = 1;;
  }

  dimension_group: enddate {
    label: "End"
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
    hidden: yes
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

  dimension: learningobjective {
    label: "Name"
    type: string
    sql: ${TABLE}.LEARNINGOBJECTIVE ;;
  }

  dimension: learningobjectiveid {
    hidden: yes
    type: number
    sql: ${TABLE}.LEARNINGOBJECTIVEID ;;
  }

  dimension: learningoutcome {
    label: "Outcome"
    type: string
    sql: ${TABLE}.LEARNINGOUTCOME ;;
  }

  dimension: lobjectiveid {
    hidden: yes
    type: number
    sql: ${TABLE}.LOBJECTIVEID ;;
  }

  dimension: loutcomeid {
    hidden: yes
    type: number
    sql: ${TABLE}.LOUTCOMEID ;;
  }

  dimension: rsrc {
    hidden: yes
    type: string
    sql: ${TABLE}.RSRC ;;
  }

  dimension_group: startdate {
    label: "Start"
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
