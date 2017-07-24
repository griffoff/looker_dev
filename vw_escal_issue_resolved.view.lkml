view: vw_escal_issue_resolved {
  derived_table: {
    sql: with t1 as (select
                        key,
                        start_date,
                        end_date,
                        resolution
                    from escal.vw_escal_resolution_time_interval
        union
        -- add dummy issue as CROSS JOIN  category x product x priority
        -- dummy issue has prefix 'dummy-'
        (
with
category as (
  select distinct
    case when cat.category is null then  'No Category' else  cat.category end as category
  from escal.VW_ESCAL_DETAIL det
  LEFT OUTER JOIN escal.vw_escal_categories cat on det.key = cat.key
            )
,priority as (
  select distinct
      priority
  from escal.vw_escal_detail
              )
,category_priority as (
  select
      category
    , priority
  from category
  cross join priority
                      )
,product as (
  select distinct
    COMPONENT as product
  from escal.VW_ESCAL_COMPONENTS
            )
,category_priority_component as    (
  select
      category_priority.category
    , category_priority.priority
    , product
  from category_priority
  cross join product
                                    )
 -- dummy issue has prefix 'dummy-'
select CONCAT('dummy-',(ROW_NUMBER() OVER ( ORDER BY category))::string) AS key,
 TO_TIMESTAMP_NTZ('2017-01-01') as start_date,
  null as end_date,
  'unresolved' as resolution
from category_priority_component
          )  -- end of union
                    )
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
