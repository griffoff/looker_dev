connection: "snowflake_prod"

include: "*.view.lkml"         # include all views in this project
# include: "*.dashboard.lookml"  # include all dashboards in this project

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
