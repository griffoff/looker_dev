view: issue_escal_resolved {
  derived_table: {
    sql: with t1 as (select
                        key,
                        start_date,
                        end_date,
                        case when --P1 Escalation
                                  (key='ESCAL-12955' and end_date is null ) or
                                  (key='ESCAL-13784' and end_date is null ) or
                                  (key='ESCAL-13843' and end_date is null ) or
                                  (key='ESCAL-13686' and end_date is null ) or
                                  (key='ESCAL-15081' and end_date is null ) or
                                  (key='ESCAL-16234' and end_date is null ) or
                                  (key='ESCAL-14018' and end_date is null ) or
                                  (key='ESCAL-16755' and end_date is null ) or
                                  (key='ESCAL-23870' and end_date is null ) or
                                  (key='ESCAL-70401' and end_date is null ) or
                                  (key='ESCAL-34771' and end_date is null ) or
                                  (key='ESCAL-61483' and end_date is null ) or
                                  (key='ESCAL-78993' and end_date is null )
                                  --P2 Escalation
                                  or
                                  (key='ESCAL-12999' and end_date is null ) or
                                  (key='ESCAL-13197' and end_date is null ) or
                                  (key='ESCAL-12977' and end_date is null ) or
                                  (key='ESCAL-13325' and end_date is null ) or
                                  (key='ESCAL-13122' and end_date is null ) or
                                  (key='ESCAL-14150' and end_date is null ) or
                                  (key='ESCAL-14660' and end_date is null ) or
                                  (key='ESCAL-14860' and end_date is null ) or
                                  (key='ESCAL-31273' and end_date is null ) or
                                  (key='ESCAL-51493' and end_date is null )
                                    then 'unresolved' else resolution end as resolution
                    from escal.vw_escal_resolution_time_interval )
    select calendar.general_date
        , t1.key as issue_id
        , t1.resolution as resolution
      from (SELECT DATEADD(day, -seq4(), current_date) as general_date FROM
    TABLE ( GENERATOR (  ROWCOUNT => 366  ) )  ) as calendar
      left join  t1
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
