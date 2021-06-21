include: "issue_multiselect_history.view"
include: "user.view"
include: "field.view"
include: "issue.view"

explore: +issue_multiselect_history {

  join: issue_multiselect_history_author {
    from: user
    sql_on: ${issue_multiselect_history.author_id} = ${issue_multiselect_history_author.id} ;;
    relationship: many_to_one
  }

  join: field {
    sql_on: ${issue_multiselect_history.field_id} = ${field.id} ;;
    relationship: many_to_one
  }

  join: issue {
    sql_on: ${issue_multiselect_history.issue_id} = ${issue.id} ;;
    relationship: many_to_one
  }
}
