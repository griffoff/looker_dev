# view: vw_sso_time_interval {
#   view_label: "SSO time interval of status"
#   derived_table: {
#     sql:
#       with histories as(
#       select
#       jsondata:key::string as id
#       , to_timestamp_tz(JSONDATA:fields:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as created
#       , JSONDATA:fields:status:name::string as current_statuss
#       ,  to_timestamp_tz(JSONDATA:fields:updated::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as updated
#       ,  to_timestamp_tz(j.value:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as modifyedtime
#       ,  j.value:items as items
#       from JIRA.RAW_JIRA_ISSUE  --, lateral flatten(input => JSONDATA:fields:customfield_12530, OUTER => TRUE) i
#       , lateral flatten(input => JSONDATA:changelog:histories, OUTER => TRUE) j
#         where  contains(jsondata:key, 'SSO-') or contains(jsondata:key, 'GATEDPTL-') or contains(jsondata:key, 'GATE-') or contains(jsondata:key, 'ACMS-'))
# , status_changes as (
#         select
#       id
#       ,modifyedtime
#       ,i.value:toString::string as toString
#       from histories, lateral flatten(input => items, OUTER => TRUE) i
#       where i.value:field::string='status'
#       group by    id     ,modifyedtime   , toString
#       union
#   select
#         id
#       ,created as modifyedtime
#       , 'Open' as toString
#       from histories
#       order by modifyedtime     )
# , status_changes_marked as ( -- marked by  modifyedtime
#         select *
#     , row_number() over (order by id, modifyedtime) as number_of_row
#   from status_changes  )
# , status_time_interval as (
#     select     t1.id
#           ,t1.toString as current_statuss
#           ,t1.modifyedtime as begin_status
#           ,t2.modifyedtime as end_status
#     FROM status_changes_marked as t1
#     LEFT  JOIN status_changes_marked as t2 ON t1.id=t2.id AND t1.number_of_row=(t2.number_of_row-1)
#     order by end_status        )
#     , last_dates as (with ttt as (select seq4() as numer
#         ,row_number() over (order by numer) as row_mun
#       from table(generator(rowcount => 180)) )
#       select
#         DATEADD(day, 1-row_mun, current_date) as general_date
#       from ttt
#     )
#     select last_dates.general_date
#         , t1.id as id
#         , t1.current_statuss as currentstatuss
#       from last_dates
#       left join status_time_interval as t1
#       on  last_dates.general_date between TIMESTAMPADD(day,-1,t1.begin_status) and TIMESTAMPADD(day,-1,coalesce(t1.end_status, TO_TIMESTAMP(current_date)))
#   ;;
#   }

#   dimension: key {
#     type: string
#     hidden: yes
#     sql: ${TABLE}.id ;;
#   }

#   dimension: currentstatuss {
#     type: string
#     sql: ${TABLE}.currentstatuss ;;
#   }



#   dimension: general_date {
#     type: date
#     sql: ${TABLE}.general_date ;;
#   }

#   measure: count_date {
#     type: count_distinct
#     sql: ${currentstatuss};;
#     drill_fields: [currentstatuss, general_date, key]
#   }

#   measure: dayli_state {
#     type: string
#     sql: max (${currentstatuss});;
#   }

#   measure: WIP_old  {
#     type: date
#     sql: max (${currentstatuss});;
#   }
# }
