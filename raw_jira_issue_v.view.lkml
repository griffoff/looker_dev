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
         where issue_key in('TRUST-991','TRUST-992')



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
  --,lead(pr.date_change)  over (partition by pr.issue_key order by pr.date_change) as date_enddd
  , pr.date_change as date_end
  from pr)
  --union

    , t2 as ( select distinct issue_key, 'Close' as status, max(res.date_end) over (partition by issue_key) as date_start , null as date_end  from res
--GROUP BY issue_key,status, date_start,date_end
)

  select * from res
  union
  select * from t2
  order by issue_key, date_end asc
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
