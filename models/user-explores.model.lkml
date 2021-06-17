connection: "snowflake_jira"

include: "/views/issue.explore"
include: "/views/project.explore"
include: "/views/board.explore"

explore: jira_issues {
  group_label: "JIRA"
  extends: [issue]
  hidden: no
}

explore: jira_projects {
  group_label: "JIRA"
  extends: [project]
  hidden: no
}

explore: jira_boards {
  group_label: "JIRA"
  extends: [board]
  hidden: no
}
