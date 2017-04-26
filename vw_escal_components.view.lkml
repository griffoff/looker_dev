view: vw_escal_components {
  view_label: "Escal Components"
  sql_table_name: ESCAL.VW_ESCAL_COMPONENTS ;;

  dimension: component {
    type: string
    sql: ${TABLE}.COMPONENT ;;
  }

  dimension: key {
    type: string
    hidden: yes
    sql: ${TABLE}.KEY ;;
  }

  measure: count {
    label: "component count"
    type: count
    drill_fields: []
  }
}
