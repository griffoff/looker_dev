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
    tiers: [1, 7, 14, 21, 28, 56]
    style: integer
    sql: ${TABLE}.resolutionTime ;;
  }

  dimension: resolutionStatus {
    view_label: "Is Resolved?"
    type: yesno
    sql: ${last_resolved_raw} is not null ;;
  }

  dimension: resolutionIntime {
    type: yesno
    sql: ( ${last_resolved_raw} is not null) and (
           ( (${priority} = 'P4 Escalation') and (${resolutionTime}<306))
        or ( (${priority} = 'P3 Escalation') and (${resolutionTime}<186))
        or ( (${priority} = 'P2 Escalation') and (${resolutionTime}<24))
        or ( (${priority} = 'P1 Escalation') and (${resolutionTime}<8))
                                                  );;
  }

  dimension: resolutionIntimeOuttime {
    type: string
    sql: case when (${resolutionIntime}) then 'In time' else 'Out time' end;;
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

  dimension: jiraKey {
    link: {
      label: "Review in Jira"
      url: "https://jira.cengage.com/browse/{{value}}"
    }

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
    sql:  ${TABLE}.age/60 ;;
  }

  dimension:age_bins {
    type: tier
    tiers: [1, 7, 14, 21, 28, 56]
    style: integer
    sql: ${age} ;;
  }

  measure: count_resolved {
    label: "# Resolved"
    type:  count_distinct
    sql: case when ${last_resolved_raw} is not null then ${key} end ;;
  }

  measure: count_notresolved {
    label: "# Outstanding"
    type:  count_distinct
    sql: case when ${last_resolved_raw} is null then ${key} end;;
  }

  measure: count {
    label: " # Issues"
    type: count
    drill_fields: [jiraKey, severity, priority, created_date, resolutionStatus, last_resolved_date, age]
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
