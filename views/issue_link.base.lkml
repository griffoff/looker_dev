view: issue_link {
  sql_table_name: {% parameter explore_level_parameters.database_name %}.{% parameter explore_level_parameters.schema_name %}."ISSUE_LINK"
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

  dimension: issue_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."ISSUE_ID" ;;
  }

  dimension: related_issue_id {
    type: number
    sql: ${TABLE}."RELATED_ISSUE_ID" ;;
  }

  dimension: relationship {
    type: string
    sql: ${TABLE}."RELATIONSHIP" ;;
  }

  measure: count {
    type: count
    drill_fields: [issue.id]
  }
}