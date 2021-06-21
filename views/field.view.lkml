include: "field.base"
include: "/base/common_includes.lkml"

explore: field{
  hidden: yes
  extends: [root]

  join:field {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +field{
  extends: [common_hidden_fields]
  dimension: id {primary_key:yes}
  dimension: name {label:"Field Name"}
}
