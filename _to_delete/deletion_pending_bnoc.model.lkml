connection: "snowflake_prod"



# # include all views in the views/ folder in this project
# # include: "/**/view.lkml"                   # include all views in this project
# # include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # # Select the views that should be a part of this model,
# # # and define the joins that connect them together.
# #
# # explore: order_items {
# #   join: orders {
# #     relationship: many_to_one
# #     sql_on: ${orders.id} = ${order_items.order_id} ;;
# #   }
# #
# #   join: users {
# #     relationship: many_to_one
# #     sql_on: ${users.id} = ${orders.user_id} ;;
# #   }
# # }

# # explore: fact_learningobjective {
# #   label: "Learning Objectives"
# #   extends: [dim_course]
# #   join: dim_course {
# #     sql_on: ${fact_learningobjective.courseid} = ${dim_course.courseid} ;;
# #     relationship: many_to_one
# #   }
# #
# #   join: dim_learningobjective {
# #     sql_on: ${fact_learningobjective.learningobjectiveid} = ${dim_learningobjective.learningobjectiveid} ;;
# #     relationship: many_to_one
# #   }
# #
# #   join:  dim_activity {
# #     sql_on: ${fact_learningobjective.activityid} = ${dim_activity.activityid} ;;
# #     relationship: many_to_one
# #   }
# #
# #   join: dim_date {
# #     view_label: "Activity Start Date"
# #     sql_on: ${fact_learningobjective.activitystartdatekey} = ${dim_date.datekey} ;;
# #     relationship: many_to_one
# #   }
# #
# #   join: dim_student {
# #     sql_on: ${fact_learningobjective.studentid} = ${dim_student.studentid} ;;
# #     relationship: many_to_one
# #   }
# #
# #   join: fact_activity {
# #     sql_on: (${fact_learningobjective.courseid}, ${fact_learningobjective.studentid}, ${dim_activity.activityid}) = (${fact_activity.courseid}, ${fact_activity.studentid}, ${fact_activity.activityid}) ;;
# #     relationship: many_to_many
# #   }
# # }
