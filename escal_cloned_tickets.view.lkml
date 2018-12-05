view: escal_cloned_tickets {
  derived_table: {
    sql: with true_escal as (
      SELECT key_jira
      , value:inwardIssue:id as id
      FROM JIRA.RAW_JIRA_DATA
      , lateral flatten ( input => jsondata:issuelinks)
      where value:type:name::string like 'Cloners'

      )

      , fake_escal as (
      SELECT key_jira
      , id_ticket as id
      FROM JIRA.RAW_JIRA_DATA
      , lateral flatten ( input => jsondata:issuelinks)
      where value:type:name::string like 'Cloners'
      )

      , keys_to_drop as (
      select f.key_jira, f.id as clone from fake_escal f inner join true_escal t on t.id like f.id
      )

      select * from keys_to_drop
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: key_jira {
    type: string
    sql: ${TABLE}."KEY_JIRA" ;;
  }

  dimension: clone {
    type: string
    sql: ${TABLE}."CLONE" ;;
  }

  set: detail {
    fields: [key_jira, clone]
  }
}
