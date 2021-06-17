include: "epic.base"
include: "/base/common_includes.lkml"

explore: epic{
  hidden: yes
  extends: [root]

  join:epic {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +epic{
  dimension: id {primary_key:yes}
}
