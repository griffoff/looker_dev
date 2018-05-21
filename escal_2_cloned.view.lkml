view: escal_2_cloned {
  view_label: "Escals"
  derived_table: {
    sql:
    WITH tickets as(
        SELECT T1.ID_TICKET
        , T2.JSONDATA
        , T2.KEY_JIRA
        , T2.COMPONENT
        FROM JIRA.JIRA_PROCS_ISSUE T1
          INNER JOIN JIRA.RAW_JIRA_DATA T2 ON T1.ID_TICKET=T2.ID_TICKET
        where PROCESS_NAME='filter-92672'
  )
  , tmp_table as (
select
     -- ID_TICKET
      KEY_JIRA
    , TO_TIMESTAMP_TZ(jsondata:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as CREATED
    , JSONDATA:priority:name::string as priority
    , jsondata:resolution:name::string  AS resolution
    , jsondata:status:name::string  AS status
    , COMPONENT
           -- ,JSONDATA:customfield_21431[0]:value::string as category
            ,JSONDATA:customfield_31335::string as salesforce_key
            --,array_size(JSONDATA:customfield_21431) as category_escal_count
from tickets
)
,  tt as(
select
*
, row_number() over (partition by salesforce_key order by KEY_JIRA) as row_number
, lead(KEY_JIRA) over (partition by salesforce_key order by KEY_JIRA) as lead
from tmp_table
where salesforce_key <> 'null'
)
select
  KEY_JIRA
, COMPONENT
, priority
, CREATED
, RESOLUTION
, SALESFORCE_KEY
from tt
where row_number>1 or lead <> 'null'
        ;;
  }

  set: detalized_set_fields {
    fields: [
      KEY_JIRA,
      priority,
      created_date,
      resolution,
      salesforce_key
    ]
  }


  dimension: component {
    type: string
    sql: ${TABLE}.COMPONENT ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date
    ]
    sql: ${TABLE}.CREATED ;;
  }

  dimension: KEY_JIRA {
    type: string
    link: {
      label: "Review in Jira"
      url: "https://s-jira.cengage.com/browse/{{value}}"
    }
    sql: ${TABLE}.KEY_JIRA ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}.PRIORITY ;;
  }

  dimension: resolution {
    type: string
    sql: ${TABLE}.resolution ;;
  }

  dimension: salesforce_key {
    link: {
      label: "Review in Jira filtered by the SalesForce key"
      url: "https://s-jira.cengage.com/issues/?jql=cf%5B31335%5D%20%3D%22{{ value }}%22"
    }
    type: string
    sql: ${TABLE}.salesforce_key ;;
  }


  measure: count {
    label: "IssuesAll"
    type: count
    drill_fields: [detalized_set_fields*]
  }
}
