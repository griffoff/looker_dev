  # view: raw_jira_issue_v {
  # derived_table: {
  #   sql: with history as(select
  #         JSONDATA:key::string as issue_key
  #         ,to_timestamp_tz(value:created::string, 'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as date_created
  #         ,value:items as items

  #         from
  #         JIRA.RAW_JIRA_ISSUE
  #         , lateral flatten ( input => JSONDATA:changelog:histories )
  #         where contains(issue_key, 'TRUST')
  #         )

  #         ,item_status as(
  #         select
  #         history.issue_key as issue_key,
  #         history.date_created as data_created,
  #         value:fromString::string as prev_status,
  #         value:toString::string as new_status
  #         from
  #         history
  #         , lateral flatten ( input => history.items )
  #         where value:field = 'status'

  #         )

  #         ,item_assi as(
  #         select
  #         history.issue_key as issue_key,
  #         history.date_created as data_created,
  #         value:fromString::string as prev_status,
  #         value:toString::string as new_status
  #         from
  #         history
  #         , lateral flatten ( input => history.items )
  #         where value:field = 'assignee'
  #         )
  #         ,during_assi as(
  #         select item_assi.issue_key, item_assi.prev_status as status
  #         ,lag(item_assi.data_created)  over (partition by item_assi.issue_key order by item_assi.data_created) as date_start
  #         , item_assi.data_created as date_end
  #         from item_assi

  #         )

  #         ,during_status as (
  #         select item_status.issue_key, item_status.prev_status as status
  #         ,lag(item_status.data_created)  over (partition by item_status.issue_key order by item_status.data_created) as date_start
  #         , item_status.data_created as date_end
  #         from item_status
  #         )

  #         , close_table as ( select distinct issue_key, 'Close' as status, max(during_status.date_end) over (partition by issue_key) as date_start , null as date_end  from during_status
  #         )

  #         , status_during_table as(
  #         select * from during_status
  #         union
  #         select * from close_table
  #         order by issue_key, date_end asc
  #         )

  #         , new_task as(
  #         select distinct status_during_table.issue_key as issue_key
  #         ,status_during_table.date_start as status_start
  #         ,status_during_table.date_end as status_end
  #         , during_assi.date_start as assi_start
  #         , during_assi.date_end as assi_end
  #         from during_assi , status_during_table
  #         where during_assi.status is not null
  #         and status_during_table.status = 'QA Ready'
  #         and assi_end > status_start
  #         and assi_end < status_end
  #         and status_during_table.issue_key = during_assi.issue_key
  #         )

  #         , dc1 as (
  #         select new_task.issue_key as issue_key
  #         , 'Dev complete' as status
  #         , new_task.status_start as time_start
  #         , new_task.assi_end as time_end
  #         from new_task
  #         where new_task.assi_start < new_task.status_start
  #         )


  #         ,dc2 as (
  #         select new_task.issue_key as issue_key
  #         , 'Dev complete' as status
  #         , new_task.assi_start as time_start
  #         , new_task.assi_end as time_end
  #         from new_task
  #         where new_task.assi_start > new_task.status_start
  #         )


  #         ,dc as(
  #         select * from dc1
  #         union
  #         select * from dc2
  #         order by issue_key, time_end asc
  #         )




  #         ,qa1 as(
  #         select new_task.issue_key as issue_key
  #         , 'QA Ready' as status
  #         , new_task.assi_end as time_start
  #         , new_task.assi_start as time_end
  #         from new_task
  #         where new_task.assi_end not in (select max(new_task.assi_end) over (partition by issue_key) from new_task)

  #         )
  #         ,qa2 as(
  #         select new_task.issue_key as issue_key
  #         , 'QA Ready' as status
  #         , new_task.assi_end as time_start
  #         , new_task.status_end as time_end
  #         from new_task
  #         where new_task.assi_end in (select max(new_task.assi_end) over (partition by issue_key) from new_task)
  #         )

  #         ,  qa as(
  #         select * from qa1
  #         union
  #         select * from qa2
  #         order by issue_key, time_end asc
  #         )

  #         , rr as(

  #         select * from dc
  #         union
  #         select * from qa
  #         order by issue_key, time_end asc
  #         )

  #         , to_del as(
  #         select distinct status_during_table.issue_key
  #         , status_during_table.status
  #         , status_during_table.date_start
  #         , status_during_table.date_end
  #         from status_during_table , rr
  #         where rr.time_start >= status_during_table.date_start
  #         and rr.time_end <= status_during_table.date_end
  #         and rr.issue_key = status_during_table.issue_key
  #         )


  #         , to_add as(
  #         select * from status_during_table
  #         except
  #         select * from to_del
  #         order by issue_key, date_end asc
  #         )
  #         ,new_status_during_table as(
  #         select * from to_add
  #         union
  #         select * from rr
  #         order by issue_key, date_end asc
  #         )

  #         ,item_sprint as(
  #         select
  #         history.issue_key as issue_key,
  #         history.date_created as date_change,
  #         value:fromString::string as prev_sprint,
  #         value:toString::string as new_sprint
  #         from
  #         history
  #         , lateral flatten ( input => history.items )
  #         where value:field = 'Sprint'
  #         --and contains(new_sprint, 'Sprint 29')
  #         )

  #         ,sprint_during_table as
  #         (
  #         select item_sprint.issue_key as issue_key,
  #         item_sprint.prev_sprint as sprint
  #         ,lag(item_sprint.date_change)  over (partition by item_sprint.issue_key order by item_sprint.date_change) as date_start
  #         , item_sprint.date_change as date_end
  #         from item_sprint
  #         )


  #         -------------------------------------------------------

  #         ,mod_status_during_table as(
  #         select * from new_status_during_table
  #         where new_status_during_table.date_start < new_status_during_table.date_end
  #         --and status in ('QA Ready')
  #         )

  #         ,mod_left_sprint as
  #         (
  #         select distinct sprint_during_table.issue_key as issue_key
  #         , sprint_during_table.sprint as sprint
  #         , mod_status_during_table.status as status
  #         , sprint_during_table.date_start as date_start
  #         , mod_status_during_table.date_end as date_end
  #         from sprint_during_table, mod_status_during_table
  #         where
  #         sprint_during_table.date_start > mod_status_during_table.date_start
  #         and sprint_during_table.date_start < mod_status_during_table.date_end
  #         and sprint_during_table.date_end > mod_status_during_table.date_end
  #         and sprint_during_table.issue_key = mod_status_during_table.issue_key
  #         )

  #         , mod_middle_sprint as
  #         (
  #         select distinct sprint_during_table.issue_key as issue_key
  #         , sprint_during_table.sprint as sprint
  #         , mod_status_during_table.status as status
  #         , mod_status_during_table.date_start as date_start
  #         , mod_status_during_table.date_end as date_end
  #         from sprint_during_table, mod_status_during_table
  #         where
  #         sprint_during_table.date_start < mod_status_during_table.date_start
  #         and sprint_during_table.date_end > mod_status_during_table.date_end
  #         and sprint_during_table.issue_key = mod_status_during_table.issue_key
  #         )


  #         , mod_right_sprint as
  #         (
  #         select distinct sprint_during_table.issue_key as issue_key
  #         , sprint_during_table.sprint as sprint
  #         , mod_status_during_table.status as status
  #         , mod_status_during_table.date_start as date_start
  #         , sprint_during_table.date_end as date_end
  #         from sprint_during_table, mod_status_during_table
  #         where
  #         sprint_during_table.date_start < mod_status_during_table.date_start
  #         and sprint_during_table.date_end < mod_status_during_table.date_end
  #         and sprint_during_table.date_end > mod_status_during_table.date_start
  #         and sprint_during_table.issue_key = mod_status_during_table.issue_key
  #         )

  #         , mod_big_sprint as
  #         (
  #         select distinct sprint_during_table.issue_key as issue_key
  #         , sprint_during_table.sprint as sprint
  #         , mod_status_during_table.status as status
  #         , sprint_during_table.date_start as date_start
  #         , sprint_during_table.date_end as date_end
  #         from sprint_during_table, mod_status_during_table
  #         where
  #         sprint_during_table.date_start > mod_status_during_table.date_start
  #         and sprint_during_table.date_end < mod_status_during_table.date_end
  #         and mod_status_during_table.issue_key = sprint_during_table.issue_key
  #         )

  #         , mod_all_sprint as(
  #         select * from mod_left_sprint
  #         union
  #         select * from mod_middle_sprint
  #         union
  #         select * from mod_right_sprint
  #         union
  #         select * from mod_big_sprint
  #         order by issue_key, sprint,  date_end asc
  #         )

  #         , during_table as
  #         (select mod_all_sprint.issue_key as issue_key
  #         , mod_all_sprint.sprint as sprint
  #         , mod_all_sprint.status as status
  #         , datediff(dd, mod_all_sprint.date_start, mod_all_sprint.date_end) as day_count
  #         from mod_all_sprint
  #         )

  #         , during_qa_dev_issue as(
  #           select mod_status_during_table.issue_key as issue_key
  #           , sum( case when mod_status_during_table.status in ('QA Ready', 'QA Active', 'Verifite') then datediff(dd, mod_status_during_table.date_start, mod_status_during_table.date_end) else 0 end) as qa_during
  #           , sum( case when mod_status_during_table.status in ('Dev complete', 'Reopen', 'In Progress') then datediff(dd, mod_status_during_table.date_start, mod_status_during_table.date_end) else 0 end) as dev_during

  #           from mod_status_during_table
  #           group by issue_key
  #         )


  #         select * from during_qa_dev_issue
  #     ;;
  # }

  # measure: count {
  #   type: count
  #   drill_fields: [detail*]
  # }

  # dimension: issue_key {
  #   type: string
  #   sql: ${TABLE}."ISSUE_KEY" ;;
  # }

  # dimension: qa_during {
  #   type: number
  #   sql: ${TABLE}."QA_DURING" ;;
  # }

  # dimension: dev_during {
  #   type: number
  #   sql: ${TABLE}."DEV_DURING" ;;
  # }

  # set: detail {
  #   fields: [issue_key, qa_during, dev_during]
  # }
  # }
