view: project_board {
  sql_table_name: {% parameter explore_level_parameters.database_name %}.{% parameter explore_level_parameters.schema_name %}."PROJECT_BOARD"
    ;;

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

  dimension: board_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."BOARD_ID" ;;
  }

  dimension: project_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."PROJECT_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [board.id, board.name, project.name, project.id]
  }
}