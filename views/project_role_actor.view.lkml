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
  extends: [common_hidden_fields]
  dimension: id {primary_key:yes hidden:yes}
  dimension: project_id {hidden:yes}
  dimension: project_role_id {hidden:yes}
  dimension: user_id {hidden:yes}
  dimension: group_name {hidden:yes}
  measure: count {hidden:yes}
}
