view: escal_cloned_tickets {
  derived_table: {
    sql: with true_escal as (
      SELECT key_jira
      , value:inwardIssue:fields:summary as link
      FROM JIRA.RAW_JIRA_DATA
      , lateral flatten ( input => jsondata:issuelinks)
      where value:type:name::string like 'Cloners'

      )

      , fake_escal as (
      SELECT key_jira
      , jsondata:summary as link
      FROM JIRA.RAW_JIRA_DATA
      , lateral flatten ( input => jsondata:issuelinks)
      where value:type:name::string like 'Cloners'
      )

      , keys_to_drop as (
      select f.key_jira as clone from fake_escal f inner join true_escal t on contains(t.link, f.link)
      )

      select * from keys_to_drop
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: clone {
    type: string
    sql: ${TABLE}."CLONE" ;;
  }

  set: detail {
    fields: [clone]
  }
}
