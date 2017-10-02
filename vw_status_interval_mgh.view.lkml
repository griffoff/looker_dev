view: vw_status_interval_mgh {
  view_label: "Issue time interval Mc-Graw Hill"
  derived_table: {
    sql:
    with inf as (
select
STATUS_INFORMATION.name as project
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
select
dates
, name
, min( status_datetime) as start_issue
, max( status_datetime) as fix_issue
, datediff(hour, start_issue, fix_issue) as fix_time_hour
from inf
GROUP BY dates, name
          ;;
  }


    dimension: name {
      type: string
      sql: ${TABLE}.name ;;
      drill_fields: [name, start_issue_raw, fix_issue_raw ]
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



    dimension: createdatekey  {
      type: number
      sql: ${start_issue_year}*10000 + ${start_issue_month_num}*100 + ${start_issue_day_of_month} ;;
    }


    dimension: time_fix {
      type: number
      sql: datediff(hour, ${start_issue_raw},  ${fix_issue_raw}) ;;
    }


    dimension:fix_stage {
      type: tier
      tiers: [3,8, 24, 72]
      style: integer
      sql: ${time_fix} ;;
    }


    measure: count
    {
      label: "Count"
      type: count
      drill_fields: [name, start_issue_raw, fix_issue_raw  ]
    }
    }
