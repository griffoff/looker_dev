view: issue_type {
  sql_table_name: {% parameter explore_level_parameters.database_name %}.{% parameter explore_level_parameters.schema_name %}."ISSUE_TYPE"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: _fivetran_synced {
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
    sql: CAST(${TABLE}."_FIVETRAN_SYNCED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: subtask {
    type: yesno
    sql: ${TABLE}."SUBTASK" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}