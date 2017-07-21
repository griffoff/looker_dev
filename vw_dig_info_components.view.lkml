view: vw_dig_info_components {
    view_label: "DIG"
    sql_table_name: ZSS.VW_DIG_INFO_COMPONENTS ;;

    dimension: components {
      type: string
      sql: ${TABLE}.component ;;
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
