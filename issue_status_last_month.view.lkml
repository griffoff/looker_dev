view: issue_status_last_month {
    derived_table: {
      sql: select calendar.general_date
        , t1.key as key
      from (SELECT DATEADD(day, -seq4(), current_date) as general_date FROM
    TABLE ( GENERATOR (  ROWCOUNT => 32  ) )  ) as calendar
      left join ESCAL.vw_escal_detail as t1
      on calendar.general_date between TO_DATE(t1.created) and dateadd(day,-1,TO_DATE(coalesce(t1.last_closed, dateadd(day,1,current_date))))
       ;;
    }
    # I used last 32 days to reduce production capacity
    # Day, when issue was closed, is not counting as day when problem was unresolved

    dimension: general_date {
      type: date
      sql: ${TABLE}.general_date ;;
    }

    dimension: key {
      type: string
      hidden: yes
      sql: ${TABLE}.key ;;
    }


  }
