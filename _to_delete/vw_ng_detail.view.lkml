# view: vw_ng_detail {
#     view_label: "NG_detail"
#     derived_table: {
#       sql:
# with detail as  (
#     select
#         JSONDATA:key::string as id
#         , JSONDATA:fields:priority:name::string as priority
#         , JSONDATA:fields:resolution:name::string as resolution
#         , JSONDATA:fields:status:name::string as status
#         , JSONDATA:fields:issuetype:name::string as issuetype
#         , JSONDATA:fields:summary::string as summary
#         , JSONDATA:fields:description::string as description
#         --cast the json value to a string to use it in the to_timestamp function
#         , to_timestamp_tz(JSONDATA:fields:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as created
#         -- you can use nullif instead of case to simplify this
#         , to_timestamp_tz(nullif(JSONDATA:fields:customfield_24430, 'null')::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as acknowledged
#         , case when JSONDATA:fields:resolutiondate='null' then null else to_timestamp(JSONDATA:fields:resolutiondate::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') end AS resolved
#         , case when JSONDATA:fields:customfield_13438='null' then null else to_timestamp(as_number(JSONDATA:fields:customfield_13438), 3) end AS last_resolved
#         , case when JSONDATA:fields:customfield_13430='null' then null else to_timestamp(as_number(JSONDATA:fields:customfield_13430), 3) end AS last_closed
#         ,JSONDATA:fields:customfield_21431 as categories
#         ,JSONDATA:fields:issuelinks as issuelinks
#         ,JSONDATA:fields:customfield_30130::string as sso_isbn
#         ,case when JSONDATA:fields:customfield_26738='null' then 'Unspecified' else trim(JSONDATA:fields:customfield_26738::string) end as discipline
#         ,JSONDATA:fields:customfield_11248::string as customer_institution
#         ,JSONDATA:fields:customfield_28633::string as course_key
#         ,array_size(JSONDATA:fields:customfield_21431) as category_count
#         ,JSONDATA:fields:components as components
#         ,array_size(JSONDATA:fields:components) as component_count
#       from
#         JIRA.RAW_JIRA_ISSUE
#     where contains(key, 'NG-')  )
#     , t_categories as (  select  detail.id,
#     i.value:value::string as category
#     from detail
#     , lateral flatten(detail.categories) i )
#     , t_components as (  select  detail.id,
#     i.value:name::string as component
#     from detail
#     , lateral flatten(detail.components) i )
#     , t_issuelinks as (  select  detail.id
#     , i.value:type:outward::string as issuelink
#     , i.value:outwardIssue:key::string as outwardIssue
#     from detail
#     , lateral flatten(detail.issuelinks) i )
# --   select * from t_issuelinks ;
# , detail_categories as (select
#     t1.*
#     , t2.category
#     --, case when i.value:value::string is null then 'null' else i.value:value::string end  as category
#     from detail t1
#     -- select * from detail_categories  ;
#     left join  t_categories t2 on t1.id=t2.id)
# --    select * from detail_categories  ;
# , detail_categ_comp as ( select
#     t1.*
#     , t2.component
#     from detail_categories t1
#     left join  t_components t2 on t1.id=t2.id )
# -- select * from detail_categ_comp  ;
# select
#     t1.*
#     , t2.issuelink
#     , t2.outwardIssue
#     from detail_categ_comp t1
#     left join  t_issuelinks t2 on t1.id=t2.id
#           ;;
#     }


#     dimension: category {
#       type: string
#       sql: case when ${TABLE}.CATEGORY is null then 'Uncategorized' else ${TABLE}.CATEGORY end ;;
#     }

#     dimension: component {
#       type: string
#       sql: ${TABLE}.COMPONENT ;;
#     }

#     dimension: course_key {
#       type: string
#       sql: ${TABLE}.course_key ;;
#     }

#     dimension: customer_institution {
#       type: string
#       sql: ${TABLE}.customer_institution ;;
#     }

#     dimension: discipline {
#       type: string
#       sql: ${TABLE}.discipline ;;
#     }

#     dimension: description {
#       type: string
#       sql: ${TABLE}.description ;;
#     }

#     dimension: outwardIssue {
#       type: string
#       sql: ${TABLE}.outwardIssue ;;
#     }

#     dimension: outwardIssue_project {
#       type: string
#       sql: case when ${TABLE}.outwardIssue is null then null else split_part( ${TABLE}.outwardIssue, '-', 1) end;;
#     }

#     dimension: issuelink {
#       type: string
#       sql: ${TABLE}.issuelink ;;
#     }

#     dimension: issuetype {
#       type: string
#       sql: ${TABLE}.issuetype ;;
#     }

#     dimension: resolution {
#       type: string
#       sql: ${TABLE}.resolution ;;
#     }

#     dimension: resolutionStatus {
#       # view_label: "Is Resolved?"
#       type: yesno
#       sql: ${resolved_raw} is not null ;;
#     }

#     dimension: sso_isbn {
#       type: string
#       sql: ${TABLE}.sso_isbn ;;
#     }

#     dimension: status {
#       type: string
#       sql: ${TABLE}.status ;;
#     }

#     dimension: summary {
#       type: string
#       sql: ${TABLE}.summary ;;
#     }

#     dimension_group: created {
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
#       sql: ${TABLE}.CREATED ;;
#     }

#     dimension: key {
#       type: string
#       primary_key: yes
#       sql: ${TABLE}.id ;;
#     }

#     dimension: jiraKey {
#       link: {
#         label: "Review in Jira"
#         url: "https://jira.cengage.com/browse/{{value}}"
#       }

#       sql: ${TABLE}.id ;;
#     }

#     dimension_group: last_closed {
#       type: time
#       timeframes: [
#         raw,
#         time,
#         date,
#         week,
#         month,
#         quarter,
#         year,
#         day_of_week,
#         hour_of_day,
#         week_of_year

#       ]
#       sql: ${TABLE}.LAST_CLOSED ;;
#     }

#     dimension_group: last_resolved {
#       type: time
#       timeframes: [
#         raw,
#         time,
#         date,
#         week,
#         month,
#         quarter,
#         year,
#         day_of_week,
#         hour_of_day,
#         week_of_year
#       ]
#       sql: ${TABLE}.LAST_RESOLVED ;;
#     }

#     dimension_group: resolved {
#       type: time
#       timeframes: [
#         raw,
#         time,
#         date,
#         week,
#         month,
#         quarter,
#         year,
#         day_of_week,
#         hour_of_day,
#         week_of_year
#       ]
#       sql: ${TABLE}.RESOLVED ;;
#     }

#     dimension: priority {
#       type: string
#       sql: ${TABLE}.PRIORITY ;;
#     }

#     dimension: createdatekey  {
#       type: number
#       sql: ${created_year}*10000 + ${created_month_num}*100 + ${created_day_of_month} ;;

#     }

#     dimension:topDiscipline {
#       type: yesno
#       sql: ${TABLE}.discipline in ('Accounting','Business Law','Chemistry','Decision Sciences','Economics','Health Science/Nursing','Management','Psychology & Psychotherapy','Taxation','Unspecified') ;;
#     }

#     dimension:topSystem {
#       type: yesno
#       sql: ${TABLE}.COMPONENT in ('MindTap','SSO/OLR','CL Homework','DevMath','Gradebook','Mobile','MTQ','CNOW','CNOW MindApp','CNOW v7','CNOW v8','Aplia','CXP','OWL v2','OWL v1','SAM','4LTR Press Online','CengageBrain.com','SSO Account Services', 'WebAssign', 'MyCengage') ;;
#     }

#     measure: count_resolved {
#       label: "# Resolved"
#       type:  count_distinct
#       sql: case when ${last_resolved_raw} is not null then ${key} end ;;
#     }

#     measure: count_notresolved {
#       label: "# Outstanding"
#       type:  count_distinct
#       sql: case when ${last_resolved_raw} is null then ${key} end;;
#     }

#     measure: count_distinct {
#       label: "IssuesDistinct"
#       type: count_distinct
#       sql: ${key};;
#       drill_fields: [jiraKey, priority, created_date, resolutionStatus, last_resolved_date]
#     }

#     measure: count {
#       label: "IssuesAll"
#       type: count
#       drill_fields: [jiraKey,  priority, created_date, resolutionStatus, last_resolved_date]
#       link: {
#         label: "Look at Content Aging Data"
#         url: "https://cengage.looker.com/dashboards/37?Category=%25Content%20Development%25"
#       }
#       link: {
#         label: "Look at Software Aging Data"
#         url: "https://cengage.looker.com/dashboards/37?Category=%25Software%25"

#       }
#     }
#   }
