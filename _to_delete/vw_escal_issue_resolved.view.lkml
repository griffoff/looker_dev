# view: vw_escal_issue_resolved {
#   derived_table: {
#     sql: with t1 as (
#     with vw_escal_resolution_time_interval as (
#     with raw_changelog as (
#   SELECT
#   case when i.value:key='null' then null else i.value:key end AS key
#     ,case when i.value:changelog='null' then null else parse_json(i.value:changelog) end AS changelog
# FROM ESCAL.RAW_DATA_JSON_CHANGELOG AS j, TABLE(FLATTEN(j.jsondata,'issues')) i
#                       )
# , raw_changelog_histories as (
#   SELECT
#   j.key::string as key,
#     case when f.value:items='null' then null else parse_json(f.value:items) end AS  item
#     , to_timestamp_tz(f.value:created::string, 'YYYY-MM-DDThh24:MI:ss.FFTZHTZM') as resolved_data_time
# FROM raw_changelog as j, LATERAL FLATTEN(input => changelog, path => 'histories')  f
#                               )
# , resolved_ordered as (
#   SELECT
# j.key as key,
#   case when f.value:toString='null' then 'unresolved' else 'resolved' end   AS resolution,
#   j.resolved_data_time as resolved_data_time
# from raw_changelog_histories as j, LATERAL FLATTEN(input => item )  f
# WHERE f.value:field='resolution'
# ORDER BY resolved_data_time ASC
#                       )
# , resolved_ordered_row as (
#   SELECT
# row_number() over (partition by key order by resolved_data_time) as number_of_row,
# key,
# resolved_data_time
# , resolution
# FROM resolved_ordered
#                           )
# SELECT
# tt1.key,
# tt1.resolved_data_time as start_date,
# tt2.resolved_data_time as end_date,
# tt1.resolution
# FROM resolved_ordered_row as tt1
# LEFT JOIN resolved_ordered_row as tt2 ON tt1.key=tt2.key AND tt1.number_of_row=(tt2.number_of_row-1)
# )
#                     select
#                         key,
#                         start_date,
#                         end_date,
#                         resolution
#                     from vw_escal_resolution_time_interval
#         union
#         -- add dummy issue as CROSS JOIN  category x product x priority
#         -- dummy issue has prefix 'dummy-'
#         (
# with
# category as (
#   select distinct
#     case when cat.category is null then  'No Category' else  cat.category end as category
#   from escal.VW_ESCAL_DETAIL det
#   LEFT OUTER JOIN escal.vw_escal_categories cat on det.key = cat.key
#             )
# ,priority as (
#   select distinct
#       priority
#   from escal.vw_escal_detail
#               )
# ,category_priority as (
#   select
#       category
#     , priority
#   from category
#   cross join priority
#                       )
# ,product as (
#   select distinct
#     COMPONENT as product
#   from escal.VW_ESCAL_COMPONENTS
#             )
# ,category_priority_component as    (
#   select
#       category_priority.category
#     , category_priority.priority
#     , product
#   from category_priority
#   cross join product
#                                     )
# -- dummy issue has prefix 'dummy-'
# select CONCAT('dummy-',(ROW_NUMBER() OVER ( ORDER BY category))::string) AS key,
# TO_TIMESTAMP_NTZ('2017-01-01') as start_date,
#   null as end_date,
#   'unresolved' as resolution
# from category_priority_component
#           )  -- end of union
#                     )
#     select calendar.general_date
#         , t1.key as issue_id
#         , t1.resolution as resolution
#       from (SELECT DATEADD(day, -seq4(), current_date) as general_date FROM
#     TABLE ( GENERATOR (  ROWCOUNT => 366  ) )  ) as calendar
#       left join  t1
#       on calendar.general_date between TIMESTAMPADD(day,-1,t1.start_date) and TIMESTAMPADD(day,-1,coalesce(t1.end_date, TO_TIMESTAMP(current_date)))
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

#   dimension: resolution {
#     type: string
#     sql: ${TABLE}.resolution ;;
#   }



# }
