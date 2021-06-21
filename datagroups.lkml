include: "//core/datagroups.lkml"

datagroup: issue_field_history_combined_trigger {
  sql_trigger:
    SELECT MAX(time)
    FROM (
      SELECT MAX(time) AS time
      FROM {% parameter explore_level_parameters.database_name %}.{% parameter explore_level_parameters.schema_name %}."ISSUE_FIELD_HISTORY"
      UNION ALL
      SELECT MAX(time)
      FROM {% parameter explore_level_parameters.database_name %}.{% parameter explore_level_parameters.schema_name %}."ISSUE_MULTISELECT_HISTORY"
    )
    ;;
}
