view: issue_escal_resolved {
  derived_table: {
    sql: select calendar.general_date
        , t1.key as issue_id
        , t1.resolution as resolution
      from (SELECT DATEADD(day, -seq4(), current_date) as general_date FROM
    TABLE ( GENERATOR (  ROWCOUNT => 366  ) )  ) as calendar
      left join escal.vw_escal_resolution_time_interval as t1
      on calendar.general_date between TIMESTAMPADD(day,-1,t1.start_date) and TIMESTAMPADD(day,-1,coalesce(t1.end_date, TO_TIMESTAMP(current_date)))
       ;;
  }

  dimension: general_date {
    type: date
    sql: ${TABLE}.general_date ;;
  }

  dimension: issue_id {
    type: string
    hidden: yes
    sql: ${TABLE}.issue_id ;;
  }

  dimension: resolution {
    type: string
    sql: ${TABLE}.resolution ;;
  }

}
