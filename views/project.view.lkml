include: "project.base"
include: "/base/common_includes.lkml"

explore: project{
  hidden: yes
  extends: [root]

  join:project {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +project{
  dimension: id {primary_key:yes}
}
