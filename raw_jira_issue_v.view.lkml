  view: raw_jira_issue_v {
   derived_table: {
    sql: with history as(
        select
            JSONDATA:key::string as issue_key,
            value:created as date_created,
            value:items as items

        from
          JIRA.RAW_JIRA_ISSUE
        , lateral flatten ( input => JSONDATA:changelog:histories )
         where issue_key in('TRUST-991', 'TRUST-2464')



        )

      ,item as(
        select
          history.issue_key as issue_key,
          history.date_created as data_created,
          value:fromString::string as prev_status,
          value:toString::string as new_status
        from
          history
        , lateral flatten ( input => history.items )
        where value:field = 'status'
      )

      ,item_assi as(
        select
          history.issue_key as issue_key,
          history.date_created as data_created,
          value:fromString::string as prev_status,
          value:toString::string as new_status
        from
          history
        , lateral flatten ( input => history.items )
        where value:field = 'assignee'
      )

      ,pr_assi as(
      select
      item_assi.issue_key as issue_key
      , item_assi.data_created as date_change
      , item_assi.prev_status as ps
      , item_assi.new_status as ns
      from item_assi
      order by date_change
      )

      ,res_assi as(
      select pr_assi.issue_key, pr_assi.ps as status
      ,lag(pr_assi.date_change)  over (partition by pr_assi.issue_key order by pr_assi.date_change) as date_start
      , pr_assi.date_change as date_end
      from pr_assi

      )

     ,pr as(
    select
    item.issue_key as issue_key
    , item.data_created as date_change
    , item.prev_status as ps
    , item.new_status as ns
    from item
    order by date_change)

    ,res as
  (select pr.issue_key, pr.ps as status
  ,lag(pr.date_change)  over (partition by pr.issue_key order by pr.date_change) as date_start
  , pr.date_change as date_end
  from pr)

    , t2 as ( select distinct issue_key, 'Close' as status, max(res.date_end) over (partition by issue_key) as date_start , null as date_end  from res
)

  , new_res as(
  select * from res
  union
  select * from t2
  order by issue_key, date_end asc
  )

  , new_task as(
    select new_res.issue_key as issue_key
    ,new_res.date_start as status_start
    ,new_res.date_end as status_end
    , res_assi.date_start as assi_start
    , res_assi.date_end as assi_end
    from res_assi , new_res
    where res_assi.status is not null
    and new_res.status = 'QA Ready'
    and assi_end > status_start
    and assi_end < status_end
  )
  ,dc1 as (
--new_task.assi_start < new_task.status_start
    select new_task.issue_key as issue_key
    , 'Dev complete' as status
    , new_task.status_start as time_start
    , new_task.assi_end as time_end
    from new_task
    where new_task.assi_start < new_task.status_start
  )
    ,dc2 as (
    select new_task.issue_key as issue_key
    , 'Dev complete' as status
    , new_task.assi_start as time_start
    , new_task.assi_end as time_end
    from new_task
    where new_task.assi_start > new_task.status_start
  )
  ,
  dc as(
    select * from dc1
    union
    select * from dc2
    order by issue_key, time_end asc
  )
  ,qa1 as(
  select new_task.issue_key as issue_key
  , 'QA Ready' as status
  , new_task.assi_end as time_start
  , new_task.assi_start as time_end
  from new_task
  where new_task.assi_end not in (select max(new_task.assi_end) over (partition by issue_key) from new_task)
  )
  ,qa2 as(
  select new_task.issue_key as issue_key
  , 'QA Ready' as status
  , new_task.assi_end as time_start
  , new_task.status_end as time_end
  from new_task
  where new_task.assi_end in (select max(new_task.assi_end) over (partition by issue_key) from new_task)
  )
  ,  qa as(
    select * from qa1
    union
    select * from qa2
    order by issue_key, time_end asc
  )

  , rr as(

    select * from dc
    union
    select * from qa
    order by issue_key, time_end asc
  )
  , to_del as(
    select distinct new_res.issue_key, new_res.status, new_res.date_start, new_res.date_end
    from new_res , rr
    where rr.time_start >= new_res.date_start
    and rr.time_end <= new_res.date_end
  )
  , to_add as(
  select * from new_res
  except
  select * from to_del
  order by issue_key, date_end asc
  )
  ,res_res as(
  select * from to_add
  union
  select * from rr
  order by issue_key, date_end asc

  )

--select * from item_assi
--select * from res_assi
--select * from new_task
--select * from rr
--select * from to_del
--select * from to_add
select * from res_res
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: issue_key {
    type: string
    sql: ${TABLE}."ISSUE_KEY" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: date_start {
    type: string
    sql: ${TABLE}."DATE_START" ;;
  }

  dimension: date_end {
    type: string
    sql: ${TABLE}."DATE_END" ;;
  }

  set: detail {
    fields: [issue_key, status, date_start, date_end]
  }
  }
