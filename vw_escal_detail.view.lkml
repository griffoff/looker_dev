view: vw_escal_detail {
  view_label: "Escals"
  #sql_table_name: ESCAL.VW_ESCAL_DETAIL ;;
  derived_table: {
    sql:
    with issues as (
        select i.value:id
            ,row_number() over(partition by i.value:id order by ldts desc, coalesce(to_timestamp_tz(i.value:fields:updated::string, 'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM'), 0::timestamp) desc) as latest
            ,i.value
        from escal.RAW_DATA_JSON_INFO
        , lateral FLATTEN(jsondata, 'issues') i
    )
    ,detail as (
      select
        i.value:key::string as key
        , i.value:fields:priority:name::string as priority
        , i.value:fields:customfield_23432:value::string as severity
        , split_part(i.value:fields:customfield_23432:value, '-', 1)::int as severity_id
        --you can pass negative numbers to split_part to use relative indexing from the end of the array
        , split_part(i.value:fields:customfield_23432:value, '-', -1)::string as severity_name
        --cast the json value to a string to use it in the to_timestamp function
        , to_timestamp_tz(i.value:fields:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as created
        , to_timestamp_tz(i.value:fields:updated::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as updated
        -- you can use nullif instead of case to simplify this
        , to_timestamp_tz(nullif(i.value:fields:customfield_24430, 'null')::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as acknowledged
    --    , case when i.value:fields:customfield_24430='null' then null else to_timestamp(replace(i.value:fields:customfield_24430,'T',' '),'YYYY-MM-DD HH24:MI:SS.FFTZHTZM') end AS acknowledged
        , case when i.value:fields:customfield_13438='null' then null else to_timestamp(as_number(i.value:fields:customfield_13438), 3) end AS last_resolved
        , case when i.value:fields:customfield_13430='null' then null else to_timestamp(as_number(i.value:fields:customfield_13430), 3) end AS last_closed
        ,i.value:fields:customfield_21431 as categories
        ,array_size(i.value:fields:customfield_21431) as category_count
        ,i.value:fields:components as components
        ,array_size(i.value:fields:components) as component_count
        ,latest
       from issues i
       where latest = 1
     )
    select
    detail.key
    , detail.priority
    , detail.severity
    , detail.created
    , detail.updated
    , detail.last_resolved
    , detail.acknowledged
    , detail.last_closed
    , detail.categories
    , detail.components
    , timestampdiff(minute,detail.created,detail.last_resolved)/60 as resolutionTime
    , timestampdiff(minute,detail.created,detail.acknowledged)/60 as acknowledgedTime
    , timestampdiff(minute,detail.created,detail.last_closed)/60 as closedTime
    , timestampdiff(minute, detail.created, current_timestamp())/60 as age
    --,latest
    from detail
    ;;
    sql_trigger_value: select max(ldts) from ESCAL.RAW_JSON_DATA_INFO ;;
  }

  dimension: acknowledged {
    type: string
    sql: ${TABLE}.ACKNOWLEDGED ;;
  }

  dimension: resolutionTime {
    type: string
    sql: ${TABLE}.resolutionTime ;;
  }

  dimension:resolutionTime_bins {
    type: tier
    tiers: [1, 7, 14, 21, 28, 56]
    style: integer
    sql: ${TABLE}.resolutionTime ;;
  }

  dimension: resolutionStatus {
    view_label: "Is Resolved?"
    type: yesno
    sql: ${last_resolved_raw} is not null ;;
  }

  dimension: resolutionIntime {
    type: yesno
    sql: ( ${last_resolved_raw} is not null) and (
           ( (${priority} = 'P4 Escalation') and (${resolutionTime}<306))
        or ( (${priority} = 'P3 Escalation') and (${resolutionTime}<186))
        or ( (${priority} = 'P2 Escalation') and (${resolutionTime}<24))
        or ( (${priority} = 'P1 Escalation') and (${resolutionTime}<8))
                                                  );;
  }

  dimension: resolutionIntimeOuttime {
    type: string
    sql: case when (${resolutionIntime}) then 'In time' else 'Out time' end;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.CREATED ;;
  }

  dimension: key {
    type: string
    primary_key: yes
    sql: ${TABLE}.KEY ;;
  }

  dimension: jiraKey {
    link: {
      label: "Review in Jira"
      url: "https://jira.cengage.com/browse/{{value}}"
    }

    sql: ${TABLE}.KEY ;;
  }

  dimension_group: last_closed {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week,
      hour_of_day,
      week_of_year

    ]
    sql: ${TABLE}.LAST_CLOSED ;;
  }

  dimension_group: last_resolved {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week,
      hour_of_day,
      week_of_year
    ]
    sql: ${TABLE}.LAST_RESOLVED ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}.PRIORITY ;;
  }

  dimension: severity {
    type: string
    sql: ${TABLE}.SEVERITY ;;
  }

  dimension: createdatekey  {
    type: number
    sql: ${created_year}*10000 + ${created_month_num}*100 + ${created_day_of_month} ;;

  }

  dimension:age {
    type: number
    sql: timestampdiff(minute, ${TABLE}.CREATED, current_timestamp())/60/60 ;;
    # sql:  ${TABLE}.age/60 ;;
  }

  dimension:age_bins {
    type: tier
    tiers: [1, 7, 14, 21, 28, 56]
    style: integer
    sql: ${age} ;;
  }

  dimension: recently_created {
    type:  number
    sql: iff(datediff(day, ${TABLE}.created, current_date()) <= 2,1,0) ;;
  }

  dimension: recently_resolved {
    type:  number
    sql: iff(${TABLE}.LAST_RESOLVED is null, 0, iff(datediff(day, ${TABLE}.LAST_RESOLVED, current_date()) <= 2,1,0)) ;;
  }

  dimension: isUnresolved {
    type:  number
    sql: iff(${TABLE}.LAST_RESOLVED is null, 1, 0) ;;
  }

  measure: sum_created {
    label: "# of Recently Closed"
    type:  sum_distinct
    sql: ${recently_created} ;;
  }

  measure: sum_resolved {
    label: "# of Recently Resolved"
    type:  sum_distinct
    sql: ${recently_resolved} ;;
  }

  measure: sum_unresolved {
    label: "# of Unresolved"
    type:  sum_distinct
    sql: ${isUnresolved} ;;

  }

  measure: count_resolved {
    label: "# Resolved"
    type:  count_distinct
    sql: case when ${last_resolved_raw} is not null then ${key} end ;;
  }

  measure: count_notresolved {
    label: "# Outstanding"
    type:  count_distinct
    sql: case when ${last_resolved_raw} is null then ${key} end;;
  }

  measure: count {
    label: " # Issues"
    type: count
    drill_fields: [jiraKey, severity, priority, created_date, resolutionStatus, last_resolved_date, age]
    link: {
      label: "Look at Content Aging Data"
      url: "https://cengage.looker.com/dashboards/37?Category=%25Content%20Development%25"
    }
      link: {
        label: "Look at Software Aging Data"
        url: "https://cengage.looker.com/dashboards/37?Category=%25Software%25"

    }
  }
  #measure: count2 {
  #  type: count
  #  link: {
  #    label: "‘Drill Down Test’"
  #    url: "{{ sessions.count_bounce_sessions._link }}"
  #    icon_url: "http://www.looker.com/favicon.ico"
  #  }
  #}
}
