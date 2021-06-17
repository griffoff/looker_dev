include: "issue_field_history.view"
include: "user.view"
include: "field.view"
include: "issue.explore"

explore: +issue_field_history {
  extends: [issue]

  join: issue_field_history_author {
    from: user
    sql_on: ${issue_field_history_author.id} = ${issue_field_history.author_id} ;;
    relationship: many_to_one
  }

  join: field {
    sql_on: ${field.id} = ${issue_field_history.field_id} ;;
    relationship: many_to_one
  }

  join: issue {
    sql_on: ${issue.id} = ${issue_field_history.issue_id} ;;
    relationship: many_to_one
  }
}

view: +issue_field_history {
  dimension: author_id {hidden:yes}
  dimension: field_id {hidden:yes}
  dimension: issue_id {hidden:yes}
  dimension_group: _fivetran_synced {hidden:yes}
}
