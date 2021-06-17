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
  dimension: id {primary_key:yes}
}
