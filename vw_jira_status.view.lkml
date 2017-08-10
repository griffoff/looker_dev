view: vw_jira_status {
    view_label: "Escals"
    sql_table_name: ESCAL.vw_jira_status ;;

    dimension_group: created {
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        month_name,
        quarter,
        year,
        day_of_week,
        hour_of_day,
        week_of_year,
        day_of_month,
        month_num
      ]
      sql: ${TABLE}.LDTS ;;
    }

  dimension: Product {
    type: string
    sql: ${TABLE}.Product ;;
  }

  dimension: Priority {
    type: string
    sql: ${TABLE}.Priority ;;
  }

  dimension: Category {
    type: string
    sql: ${TABLE}.Category ;;
  }

  dimension: Choose {
    type: string
    sql: ${TABLE}.Choose ;;
  }
  dimension: Value {
    type: number
    sql: ${TABLE}.Value ;;
  }


    measure: count_notresolved {
      label: "Max"
      type:  max
      sql:  ${Value} ;;
      drill_fields: [created_raw, Product, Priority, Category, Choose,Value]
          }

    measure: count {
      label: " # Issues"
      type: count
      drill_fields: [created_date, Product, Priority, Category, Choose,Value]
      link: {
        label: "Look at Content Aging Data"
        url: "https://cengage.looker.com/dashboards/37?Category=%25Content%20Development%25"
      }
      link: {
        label: "Look at Software Aging Data"
        url: "https://cengage.looker.com/dashboards/37?Category=%25Software%25"

      }
    }
    #measure: count2 {
    #  type: count
    #  link: {
    #    label: "‘Drill Down Test’"
    #    url: "{{ sessions.count_bounce_sessions._link }}"
    #    icon_url: "http://www.looker.com/favicon.ico"
    #  }
    #}   sql: case when ${last_resolved_raw} is null then ${key} end;;
  }
