view: tbl_jira_status {
  view_label: "Escals"

  filter: fix_datetime {
    label:  "Escals" #"max_data"
    type: date_time
  }

 # sql_table_name: ESCAL.jira_status ;;
    derived_table: {
    sql: with matrix as (
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
                 )
  select
      ldts,
      product,
      priority,
      Category,
      Choose,
      value
  from matrix
    where row_number=1
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

  dimension: Choose {
    type: string
    sql: ${TABLE}.Choose ;;
  }
  dimension: Value {
    type: number
    sql: ${TABLE}.Value ;;
  }


  measure: count_max {
    label: "Max"
    type:  max
    sql:  ${Value} ;;
    drill_fields: [created_raw, Product, Priority, Category, Choose,Value]
  }
  measure: count_summa {
    label: "Summa"
    type:  sum
    sql:  ${Value} ;;
    drill_fields: [created_raw, Product, Priority, Category, Choose,Value]
  }
  }
