# view: issue_closures {
#   derived_table: {
#     sql: select calendar.general_date
#         , t1.key as issue_id
#         , t1.ticket_status as ticket_status
#       from (SELECT DATEADD(day, -seq4(), current_date) as general_date FROM
#     TABLE ( GENERATOR (  ROWCOUNT => 366  ) )  ) as calendar
#       left join ZSS.vw_dig_status_time_interval as t1
#       on calendar.general_date between t1.start_date and coalesce(t1.end_date, TO_TIMESTAMP(current_date))
#       ;;
#   }

#   dimension: general_date {
#     type: date
#     sql: ${TABLE}.general_date ;;
#   }

#   dimension: issue_id {
#     type: string
#     hidden: yes
#     sql: ${TABLE}.issue_id ;;
#   }

#   dimension: ticket_status {
#     type: string
#     sql: ${TABLE}.ticket_status ;;
#   }

# }
