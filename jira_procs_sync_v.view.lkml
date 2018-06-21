view: jira_procs_sync_v {
  derived_table: {
    sql: SELECT * FROM JIRA.JIRA_PROCS_SYNC
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: process_name {
    type: string
    sql: ${TABLE}."PROCESS_NAME" ;;
  }

  dimension_group: last_update {
    type: time
    sql: ${TABLE}."LAST_UPDATE" ;;
  }

  dimension_group: last_sync {
    type: time
    sql: ${TABLE}."LAST_SYNC" ;;
  }

  set: detail {
    fields: [process_name, last_update_time, last_sync_time]
  }
}
