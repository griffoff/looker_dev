view: project {
  sql_table_name: {% parameter explore_level_parameters.database_name %}.{% parameter explore_level_parameters.schema_name %}."PROJECT"
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

  dimension: key {
    type: string
    sql: ${TABLE}."KEY" ;;
  }

  dimension: lead_id {
    type: string
    sql: ${TABLE}."LEAD_ID" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: permission_scheme_id {
    type: number
    sql: ${TABLE}."PERMISSION_SCHEME_ID" ;;
  }

  dimension: project_category_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."PROJECT_CATEGORY_ID" ;;
  }

  dimension: project_type_key {
    type: string
    sql: ${TABLE}."PROJECT_TYPE_KEY" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      name,
      project_category.name,
      project_category.id,
      component.count,
      project_board.count,
      project_role_actor.count,
      version.count
    ]
  }
}