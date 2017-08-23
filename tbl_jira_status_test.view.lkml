view: tbl_jira_status_test {
    view_label: "Escals_test"

    filter: fix_datetime {
      label:  "range_of_date" #"max_data"
      type: date_time
    }

  #filter: depth {
  #  label:  "Escals_test"
  #}


    # select all data depends on condition fix_datetime
    derived_table: {
      sql:
        select
            ldts,
            product,
            priority,
            Category,
            Choose,
            value
            , row_number() over (partition by product, priority, Category, Choose order by ldts desc) as row_number
        from ESCAL.JIRA_STATUS
          where {% condition fix_datetime %} ldts {% endcondition %}
        ;;
    }

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

    dimension: Status {
      type: string
      sql: ${TABLE}.Choose ;;
    }
  dimension: Value {
    type: number
    sql: ${TABLE}.Value ;;
  }

  dimension: row_number {
    hidden: yes
    type: number
    sql: ${TABLE}.row_number ;;
  }


    measure: count_max {
      label: "Max"
      type:  max
      sql:  ${Value} ;;
      drill_fields: [created_raw, Product, Priority, Category, Status,Value]
    }
    measure: count_summa {
      label: "Summa"
      type:  sum
      sql:  ${Value} ;;
      drill_fields: [created_raw, Product, Priority, Category, Status,Value,row_number]
    }
  }
