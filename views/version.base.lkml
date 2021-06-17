view: version {
  sql_table_name: {% parameter explore_level_parameters.database_name %}.{% parameter explore_level_parameters.schema_name %}."VERSION"
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

  dimension: archived {
    type: yesno
    sql: ${TABLE}."ARCHIVED" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: overdue {
    type: yesno
    sql: ${TABLE}."OVERDUE" ;;
  }

  dimension: project_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."PROJECT_ID" ;;
  }

  dimension_group: release {
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
    datatype: date
    sql: ${TABLE}."RELEASE_DATE" ;;
  }

  dimension: released {
    type: yesno
    sql: ${TABLE}."RELEASED" ;;
  }

  dimension_group: start {
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
    datatype: date
    sql: ${TABLE}."START_DATE" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, project.name, project.id]
  }
}