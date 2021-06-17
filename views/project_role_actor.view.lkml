include: "project_role_actor.base"
include: "/base/common_includes.lkml"

explore: project_role_actor{
  hidden: yes
  extends: [root]

  join:project_role_actor {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +project_role_actor{
  dimension: id {primary_key:yes}
}
