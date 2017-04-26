view: vw_escal_categories {
  view_label: "Escal Categories"
  sql_table_name: ESCAL.VW_ESCAL_CATEGORIES ;;

  dimension: category {
    type: string
    sql: ${TABLE}.CATEGORY ;;
  }

  dimension: key {
    type: string
    hidden: yes
    sql: ${TABLE}.KEY ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
