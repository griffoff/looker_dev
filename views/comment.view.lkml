include: "comment.base"

include: "/base/common_includes.lkml"

explore: comment{
  hidden: yes
  extends: [root]

  join: comment {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +comment{
  extends: [common_hidden_fields]
  dimension: id {primary_key:yes}
  dimension: issue_id {hidden:yes}
  dimension: author_id {hidden:yes}
  dimension: update_author_id {hidden:yes}
}
