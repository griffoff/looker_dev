# view: vw_status_interval_prsn {
#   view_label: "Issue time interval pearson"
#   derived_table: {
#     sql:
# with inf as (
# select
# i.value:date::date as dates
# , case when i.value:time<>'None' then to_timestamp_ntz(CONCAT(i.value:date::date, i.value:time),'YYYY-MM-DDHH24:MI:SS +00:00') else null  end as datetime
# , case when contains(i.value:message::string,'We have received') or contains(i.value:message::string,'We have confirmed a technical issue') then 'start'
#       when contains(i.value:message::string,'Pearson resolved') then  'finish' end as message
# , replace(i.value:system::string,'"','') as system
# , row_number() over (partition by key order by datetime) as number_of_row
# from SCRAPING.STATUS_INFORMATION
# , lateral flatten(input => INFORMATION) i
# where STATUS_INFORMATION.name='Pearson' and message is not null
# )
# ,  all_interval as (
# select
# t1.dates as dates
# , t1.system as system
# , t1.datetime as start_issue
# , t2.datetime as fix_issue
# , t2.number_of_row as fix_number_of_row
# FROM inf as t1
# INNER JOIN inf as t2 ON t1.system=t2.system AND t1.message='start' AND  t2.message='finish' AND  t1.number_of_row < t2.number_of_row
#   )
# , min_finish as (
# select
# system
# , start_issue
# , min(fix_issue) as fix_issue
# from all_interval
# where fix_issue is not null
# group by start_issue,  system
# )
#   select
# system
# ,min (start_issue) as start_issue
# , fix_issue
# from min_finish
# where fix_issue is not null
# group by  fix_issue, system
#       ;;
#   }




#   dimension: name {
#     type: string
#     sql: ${TABLE}.system ;;
#     drill_fields: [name, start_issue_raw, fix_issue_raw ]
#   }

#   dimension_group: start_issue {
#     type: time
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       month_name,
#       quarter,
#       year,
#       day_of_week,
#       hour_of_day,
#       week_of_year,
#       day_of_month,
#       month_num
#     ]
#     sql: ${TABLE}.start_issue ;;
#   }


#   dimension_group: fix_issue {
#     type: time
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       month_name,
#       quarter,
#       year,
#       day_of_week,
#       hour_of_day,
#       week_of_year,
#       day_of_month,
#       month_num
#     ]
#     sql: ${TABLE}.fix_issue ;;
#   }



#   dimension: createdatekey  {
#     type: number
#     sql: ${start_issue_year}*10000 + ${start_issue_month_num}*100 + ${start_issue_day_of_month} ;;
#   }


#   dimension: time_fix {
#     type: number
#     sql: datediff(hour, ${start_issue_raw},  ${fix_issue_raw}) ;;
#   }


#   dimension:fix_stage {
#     type: tier
#     tiers: [3,8, 24, 72, 1000]
#     style: integer
#     sql: ${time_fix} ;;
#   }


#   measure: count
#   {
#     label: "Count"
#     type: count
#     #sql: case when ${name} is not null then ${name} end;;
#     drill_fields: [name, start_issue_raw, fix_issue_raw  ]

#   }
#   #
#   # dimension: lifetime_orders {
#   #   description: "The total number of orders for each user"
#   #   type: number
#   #   sql: ${TABLE}.lifetime_orders ;;
#   # }
#   #
#   # dimension_group: most_recent_purchase {
#   #   description: "The date when each user last ordered"
#   #   type: time
#   #   timeframes: [date, week, month, year]
#   #   sql: ${TABLE}.most_recent_purchase_at ;;
#   # }
#   #
#   # measure: total_lifetime_orders {
#   #   description: "Use this for counting lifetime orders across many users"
#   #   type: sum
#   #   sql: ${lifetime_orders} ;;
#   # }
# }

# # view: vw_status_interval_prsn {
# #   # Or, you could make this view a derived table, like this:
# #   derived_table: {
# #     sql: SELECT
# #         user_id as user_id
# #         , COUNT(*) as lifetime_orders
# #         , MAX(orders.created_at) as most_recent_purchase_at
# #       FROM orders
# #       GROUP BY user_id
# #       ;;
# #   }
# #
# #   # Define your dimensions and measures here, like this:
# #   dimension: user_id {
# #     description: "Unique ID for each user that has ordered"
# #     type: number
# #     sql: ${TABLE}.user_id ;;
# #   }
# #
# #   dimension: lifetime_orders {
# #     description: "The total number of orders for each user"
# #     type: number
# #     sql: ${TABLE}.lifetime_orders ;;
# #   }
# #
# #   dimension_group: most_recent_purchase {
# #     description: "The date when each user last ordered"
# #     type: time
# #     timeframes: [date, week, month, year]
# #     sql: ${TABLE}.most_recent_purchase_at ;;
# #   }
# #
# #   measure: total_lifetime_orders {
# #     description: "Use this for counting lifetime orders across many users"
# #     type: sum
# #     sql: ${lifetime_orders} ;;
# #   }
# # }
