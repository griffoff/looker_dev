include: "worklog.view"
include: "user.view"
include: "issue.explore"

explore: +worklog {
  extends: [issue]

  join: worklog_author {
    from: user
    sql_on: ${worklog.author_id} = ${worklog_author.id} ;;
    relationship: many_to_one
  }

  join: worklog_update_author {
    from: user
    sql_on: ${worklog.update_author_id} = ${worklog_update_author.id} ;;
    relationship: many_to_one
  }

  join: issue {
    sql_on: ${worklog.issue_id} = ${issue.id} ;;
    relationship: many_to_one
  }
}

view: +worklog {
  dimension: author_id {hidden:yes}
  dimension: update_author_id {hidden:yes}
  dimension: issue_id {hidden:yes}
  dimension_group: _fivetran_synced {hidden:yes}
}
