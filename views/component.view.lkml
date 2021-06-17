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
  dimension: id {primary_key:yes}
}
