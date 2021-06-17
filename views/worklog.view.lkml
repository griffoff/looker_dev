include: "worklog.base"
include: "/base/common_includes.lkml"

explore: worklog{
  hidden: yes
  extends: [root]

  join:worklog {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +worklog{
  dimension: id {primary_key:yes}
}
