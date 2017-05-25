view: vw_escal_detail {
  view_label: "Escals"
  sql_table_name: ESCAL.VW_ESCAL_DETAIL ;;

  dimension: acknowledged {
    type: string
    sql: ${TABLE}.ACKNOWLEDGED ;;
  }

  dimension: resolutionTime {
    type: string
    sql: ${TABLE}.resolutionTime ;;
  }

  dimension:resolutionTime_bins {
    type: tier
    tiers: [0, 7, 14, 21, 28, 56]
    style: integer
    sql: ${TABLE}.resolutionTime ;;
  }

  dimension: resolutionStatus {
    type: yesno
    sql: ${last_resolved_raw} is not null ;;
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
    sql: ${TABLE}.CREATED ;;
  }

  dimension: key {
    type: string
    primary_key: yes
    sql: ${TABLE}.KEY ;;
  }

  dimension_group: last_closed {
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
    sql: ${TABLE}.LAST_CLOSED ;;
  }

  dimension_group: last_resolved {
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
    sql: ${TABLE}.LAST_RESOLVED ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}.PRIORITY ;;
  }

  dimension: severity {
    type: string
    sql: ${TABLE}.SEVERITY ;;
  }

  dimension: createdatekey  {
    type: number
    sql: ${created_year}*10000 + ${created_month_num}*100 + ${created_day_of_month} ;;

  }

  dimension:age {
    type: number
    sql:  ${TABLE}.age ;;
  }

  dimension:age_bins {
    type: tier
    tiers: [0, 7, 14, 21, 28, 56]
    style: integer
    sql: ${TABLE}.resolutionTime ;;
  }

  measure: count {
    type: count
    drill_fields: [key, severity, priority, created_date, resolutionStatus, last_resolved_date]
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
  #}
}
