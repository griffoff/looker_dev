view: issue_multiselect_history {
  sql_table_name: {% parameter explore_level_parameters.database_name %}.{% parameter explore_level_parameters.schema_name %}."ISSUE_MULTISELECT_HISTORY"
    ;;

  dimension: _fivetran_id {
    type: string
    sql: ${TABLE}."_FIVETRAN_ID" ;;
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

  dimension: author_id {
    type: string
    sql: ${TABLE}."AUTHOR_ID" ;;
  }

  dimension: field_id {
    type: string
    # hidden: yes
    sql: ${TABLE}."FIELD_ID" ;;
  }

  dimension: issue_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."ISSUE_ID" ;;
  }

  dimension_group: time {
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
    sql: CAST(${TABLE}."TIME" AS TIMESTAMP_NTZ) ;;
  }

  dimension: value {
    type: string
    sql: ${TABLE}."VALUE" ;;
  }

  measure: count {
    type: count
    drill_fields: [issue.id, field.name, field.id]
  }
}