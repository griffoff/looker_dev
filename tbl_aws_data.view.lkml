view: tbl_aws_data {
    view_label: "AWS_DATA"
    sql_table_name: AWS_DATA.JUNE_DATA ;;

    dimension: instance_type {
      type: string
      sql: ${TABLE}.INSTANCE_TYPE ;;
    }

    dimension:  environment {
      type: string
      sql: ${TABLE}.ENVIRONMENT ;;
    }
    dimension:  monthly_cost {
      type: number
      sql:  ${TABLE}.MONTHLY_COST ;;
    }

    dimension_group: billingmonth {
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year,
        day_of_week,
        hour_of_day,
        week_of_year
      ]
      sql: ${TABLE}.MONTH ;;
    }

    measure: count {
      type: count
    }

    measure: sum {
      type:  sum
      sql: ${monthly_cost} ;;
      value_format_name: usd
    }
  }
