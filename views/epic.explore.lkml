include: "epic.view"
include: "issue.view"

explore: +epic {
  join: issue {
    sql_on: ${epic.id} = ${issue.parent_id} ;;
    relationship: one_to_many
  }
}
