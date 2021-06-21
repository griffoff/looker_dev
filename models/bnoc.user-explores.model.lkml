connection: "snowflake_jira"
case_sensitive: no

# extended explores
include: "/views/board.explore"
include: "/views/issue.explore"
include: "/views/project.explore"

# included for jira_boards
include: "/views/project_board.explore"
include: "/views/sprint.explore"

#included for jira_issues
include: "/views/comment.explore"
include: "/views/issue_link.explore"
include: "/views/status.explore"
include: "/views/worklog.explore"

# included for jira_projects
include: "/views/project_role_actor.explore"

# user explores
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
