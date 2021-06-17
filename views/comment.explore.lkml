include: "comment.view"
include: "issue.explore"
include: "user.explore"

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

view: +comment {
  dimension: issue_id {hidden:yes}
  dimension: author_id {hidden:yes}
  dimension: update_author_id {hidden:yes}
  dimension_group: _fivetran_synced {hidden:yes}
}
