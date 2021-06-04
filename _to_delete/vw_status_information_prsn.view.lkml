# view: vw_status_information_prsn {
#   view_label: "Scraping information pearson"
#   derived_table: {
#     sql:
#     with inf as (
# select
# i.value:date::date as dates
# , case when i.value:time<>'None' then to_timestamp_ntz(CONCAT(i.value:date::date, i.value:time),'YYYY-MM-DDHH24:MI:SS +00:00') else null  end as datetime
# , i.value:message::string as message
# , replace(i.value:system::string,'"','') as system
# from SCRAPING.STATUS_INFORMATION
# , lateral flatten(input => INFORMATION) i
# where STATUS_INFORMATION.name='Pearson' and message is not null
#   )
# select
# dates
# , system
# , min( datetime) as e_datetime
# , max( datetime) as l_datetime
# from inf
# where datetime is not null
# group by  dates, system
#       ;;
#     }

# # We need shift time from UTC to EDT ? Then use command
# # dateadd(hour, -4,

#     dimension_group: date_of_message {
#       type: time
#       timeframes: [
#         raw,
#         date,
#         week,
#         month,
#         month_name,
#         quarter,
#         year,
#         day_of_week,
#         hour_of_day,
#         week_of_year,
#         day_of_month,
#         month_num
#       ]
#       sql: ${TABLE}.dates ;;
#     }



#   dimension: name {
#     type: string
#     sql: ${TABLE}.system ;;
#     drill_fields: [date_of_message_raw,  name]
#   }

#     dimension_group: datetime {
#       type: time
#       timeframes: [
#         raw,
#         time,
#         date,
#         week,
#         month,
#         month_name,
#         quarter,
#         year,
#         day_of_week,
#         hour_of_day,
#         week_of_year,
#         day_of_month,
#         month_num
#       ]
#       sql: ${TABLE}.e_datetime ;;
#     }



#     dimension: createdatekey  {
#       type: number
#       sql: ${date_of_message_year}*10000 + ${date_of_message_month_num}*100 + ${date_of_message_day_of_month} ;;
#     }



#     measure: count
#     {
#       label: "Count"
#       type: count
#       #sql: case when ${name} is not null then ${name} end;;
#       drill_fields: [date_of_message_raw,  name]

#     }

#     }
