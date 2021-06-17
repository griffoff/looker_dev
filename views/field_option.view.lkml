include: "field_option.base"
include: "/base/common_includes.lkml"

explore: field_option{
  hidden: yes
  extends: [root]

  join:field_option {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +field_option{
  dimension: id {primary_key:yes}
}
