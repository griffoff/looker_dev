connection: "snowflake_jira"

# include: "/views/issue.explore"
# include: "/views/project_board.explore"

# explore: jira_issues {
#   extends: [project_board,issue]

#   join: project_board {
#     sql_on: ${project.id} = ${project_board.project_id} ;;
#     relationship: many_to_one
#   }
# }
