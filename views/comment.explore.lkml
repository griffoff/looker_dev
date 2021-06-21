include: "comment.view"
include: "issue.view"
include: "user.view"

explore: +comment {

  join: issue {
    sql_on: ${comment.issue_id} = ${issue.id} ;;
    relationship: many_to_one
  }

  join: comment_author {
    from: user
    sql_on: ${comment.author_id} = ${comment_author.id} ;;
    relationship: many_to_one
  }

  join: comment_update_author {
    from: user
    sql_on: ${comment.author_id} = ${comment_update_author.id} ;;
    relationship: many_to_one
  }
}
