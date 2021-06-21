include: "component.base"
include: "/base/common_includes.lkml"

explore: component{
  hidden: yes
  extends: [root]

  join:component {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +component{
  extends: [common_hidden_fields]
  dimension: id {primary_key:yes}
  dimension: project_id {hidden:yes}
}
