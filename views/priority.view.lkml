include: "priority.base"
include: "/base/common_includes.lkml"

explore: priority{
  hidden: yes
  extends: [root]

  join:priority {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +priority{
  extends: [common_hidden_fields]
  dimension: id {primary_key:yes}
}
