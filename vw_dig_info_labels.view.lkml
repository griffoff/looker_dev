view: vw_dig_info_labels {
view_label: "DIG"
  sql_table_name: ZSS.vw_dig_info_labels ;;

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
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
