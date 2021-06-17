include: "project_role.base"
include: "/base/common_includes.lkml"

explore: project_role{
  hidden: yes
  extends: [root]

  join:project_role {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +project_role{
  dimension: id {primary_key:yes}
}
