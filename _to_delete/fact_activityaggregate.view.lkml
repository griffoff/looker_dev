view: fact_activityaggregate {
  sql_table_name: DW_DEVMATH.FACT_ACTIVITYAGGREGATE ;;

  dimension: aggregateuri {
    type: string
    sql: ${TABLE}.AGGREGATEURI ;;
  }

  dimension: coursekey {
    type: string
    sql: ${TABLE}.COURSEKEY ;;
  }

  dimension_group: creationdate {
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
    sql: ${TABLE}.CREATIONDATE ;;
  }

  dimension: guid {
    type: string
    sql: ${TABLE}.GUID ;;
  }

  dimension_group: lastupdatedate {
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
    sql: ${TABLE}.LASTUPDATEDATE ;;
  }

  dimension: normalscore {
    type: string
    sql: ${TABLE}.NORMALSCORE ;;
  }

  dimension: possiblescore {
    type: string
    sql: ${TABLE}.POSSIBLESCORE ;;
  }

  dimension_group: submissiondate {
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
    sql: ${TABLE}.SUBMISSIONDATE ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
