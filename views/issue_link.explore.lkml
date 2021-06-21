include: "issue_link.view"
include: "issue.view"

explore: +issue_link {

  join: issue {
    sql_on: ${issue.id} = ${issue_link.issue_id} ;;
    relationship: many_to_one
  }

  join: related_issue {
    from: issue
    sql_on: ${related_issue.id} = ${issue_link.related_issue_id} ;;
    relationship: many_to_one
  }

}
