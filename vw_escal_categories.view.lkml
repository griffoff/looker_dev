view: vw_escal_categories {
  view_label: "Escal Categories"
  sql_table_name: ESCAL.VW_ESCAL_CATEGORIES ;;

  dimension: category {
    type: string
    sql: ${TABLE}.CATEGORY ;;
    link: {
      label: "Show Aging"
      url: "https://cengage.looker.com/dashboards/37?Category=%25{{category}}%25"
    }
    link: {
      label: "Show Newly Opened"
      url: "https://cengage.looker.com/dashboards/39?Category=%25{{category}}%25"
    }
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
