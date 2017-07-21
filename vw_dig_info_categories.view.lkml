view: vw_dig_info_categories {
  view_label: "DIG"
  sql_table_name: ZSS.VW_DIG_INFO_CATEGORIES ;;

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
