connection: "snowflake_prod"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

label: "MTMF"

explore:  dim_course {
  extension: required
  join: dim_institution {
    sql_on:  ${dim_course.institutionid} = ${dim_institution.institutionid} ;;
    relationship: many_to_one
  }

  join: dim_instructor {
    sql_on: ${dim_course.instructorid} = ${dim_instructor.instructorid} ;;
    relationship: one_to_many
  }

  join:  dim_product {
    sql_on: ${dim_course.productid} = ${dim_product.productid} ;;
    relationship: many_to_one
  }
}

explore: fact_learningobjective {
  label: "Learning Objectives"
  extends: [dim_course]
  join: dim_course {
    sql_on: ${fact_learningobjective.courseid} = ${dim_course.courseid} ;;
    relationship: many_to_one
  }

  join: dim_learningobjective {
    sql_on: ${fact_learningobjective.id} = ${dim_learningobjective.lobjectiveid} ;;
    relationship: many_to_one
  }

  join:  dim_activity {
    sql_on: ${fact_learningobjective.activityid} = ${dim_activity.activityid} ;;
    relationship: many_to_one
  }

  join: dim_date {
    view_label: "Activity Start Date"
    sql_on: ${fact_learningobjective.activitystartdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }

  join: dim_student {
    sql_on: ${fact_learningobjective.studentid} = ${dim_student.studentid} ;;
    relationship: many_to_one
  }

  join: fact_activity {
    sql_on: (${fact_learningobjective.courseid}, ${fact_learningobjective.studentid}, ${dim_activity.activityid}) = (${fact_activity.courseid}, ${fact_activity.studentid}, ${fact_activity.activityid}) ;;
    relationship: many_to_many
  }
}
