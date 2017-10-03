  view: vw_status_information_mgh{
    view_label: "Scraping information mgh"
    #sql_table_name: SCRAPING.vw_status_information ;;
    derived_table: {
      sql:
      with inf as (
select
name as project
, i.value:date::date as dates
, replace(i.value:message::string,'"','') as message
, replace(i.value:name::string,'"','') as name
, replace( i.value:status::string,'"','') as status
, case when contains(i.value:status_time,'am') then to_timestamp_ntz(CONCAT(i.value:status_date, i.value:status_time),'YYYY-MM-DDHH12:MI:SS am +00:00')
       when contains(i.value:status_time,'pm') then dateadd(hour, 0,to_timestamp_ntz(CONCAT(i.value:status_date, i.value:status_time),'YYYY-MM-DDHH12:MI:SS pm +00:00'))
       else null  end as status_datetime
from SCRAPING.STATUS_INFORMATION,
lateral flatten(input => INFORMATION) i
where status <> 'None'
            )
  , issue_interval as (
select
dates
, name
, min( status_datetime) as start_date
, max( status_datetime) as fix_issue
from inf
GROUP BY dates, name
                      )
, interval as (
    select calendar.general_date
        , name
        , start_date
        ,  fix_issue
      from (SELECT DATEADD(day, -seq4(), current_date) as general_date FROM
    TABLE ( GENERATOR (  ROWCOUNT => 366  ) )  ) as calendar
      left join  issue_interval
      on calendar.general_date between TIMESTAMPADD(day,-1,issue_interval.start_date) and TIMESTAMPADD(day,0,coalesce(issue_interval.fix_issue, TO_TIMESTAMP(current_date)))
      )
select general_date as date_of_message
        , name
        , SPLIT_PART( name, ' - ', 1) as group_of_product
        , SPLIT_PART(name, ' - ', 2) as name_of_product
        , start_date
        ,  fix_issue
      from interval
where name IS NOT NULL
      ;;
    }

# We need shift time from UTC to EDT ? Then use command
# dateadd(hour, -4,

    dimension_group: date_of_message {
      type: time
      timeframes: [
        raw,
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
      sql: ${TABLE}.date_of_message ;;
    }

    dimension_group: start_issue {
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
      sql: ${TABLE}.start_issue ;;
    }

    dimension_group: fix_issue {
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
      sql: ${TABLE}.fix_issue ;;
    }

    dimension: time_fix {
      type: number
      sql: datediff(hour, ${start_issue_raw},  ${fix_issue_raw}) ;;
    }


    dimension:fix_stage {
      type: tier
      tiers: [3,8, 24, 72, 1000]
      style: integer
      sql: ${time_fix} ;;
    }

    dimension: name {
      type: string
      sql: ${TABLE}.name ;;
      drill_fields:  [name, start_issue_date, fix_issue_date]
    }


    dimension: group_of_product {
      type: string
      sql: ${TABLE}.group_of_product ;;
    }

    dimension: name_of_product {
      type: string
      sql: ${TABLE}.name_of_product ;;
    }



    dimension: createdatekey  {
      type: number
      sql: ${date_of_message_year}*10000 + ${date_of_message_month_num}*100 + ${date_of_message_day_of_month} ;;
    }



    measure: count
    {
      label: "Count"
      type: count
      #sql: case when ${name} is not null then ${name} end;;
      drill_fields:  [name]
}
set: user_details {
  fields: [date_of_message_raw, name, start_issue_date, fix_issue_date]
#[date_of_message_raw, name, start_issue_raw, fix_issue_raw]
    }

}




# view: vw_status_information
# {
#     view_label: "Scraping information"
#     sql_table_name: SCRAPING.vw_status_information;;
#
#
# dimension: project
# {
#     type: string
#     sql: ${TABLE}.project;;
# }
#
# dimension_group: date_of_message
# {
#     type: time
#     timeframes: [
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
#     ]
#     sql: ${TABLE}.dates;;
# }
#
# dimension: message
# {
#     type: string
#     sql: ${TABLE}.message;;
# }
#
# dimension: name
# {
#     type: string
#     sql: ${TABLE}.name;;
# }
#
# dimension: status
# {
#     type: string
#     sql: ${TABLE}.status;;
# }
#
# dimension_group: status_date_time
# {
#     type: time
#     timeframes: [
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
#     ]
#     sql: ${TABLE}.status_datetime;;
# }
#
#
# measure: count
# {
#     label: "Count"
#     type: count
#     drill_fields: [date_of_message_date, message, name, status]
# }
# }
