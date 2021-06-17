include: "//core/root.lkml"

explore: explore_level_parameters {
  hidden:yes
  extends: [root]

  join: explore_level_parameters {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: explore_level_parameters {
  view_label: "** Explore Parameters **"

  parameter: schema_name {
    label: "Environment"
    hidden: no
    type: unquoted
    allowed_value: {
      label: "Development"
      value: "JIRADEV"
    }

    allowed_value: {
      label: "Development"
      value: "JIRADEV2"
    }

    allowed_value: {
      label: "Development"
      value: "JIRADEV3"
    }

    default_value: "JIRADEV3"
    description: "Schema name"
  }

  parameter: database_name {
    label: "Environment"
    hidden: yes
    type: unquoted
    allowed_value: {
      label: "Production"
      value: "JIRA"
    }

    default_value: "JIRA"
    description: "Database name"
  }


}
