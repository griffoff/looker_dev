connection: "snowflake_prod"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

## test
#
named_value_format: duration_hms {
  value_format: "hh:mm:ss"
}

##explore: dim_user_v{
##  label: "Dim user"
##}
#
#include: "/cube/stg_clts.activations_olr.view.lkml"
#include: "/cube/stg_clts.course_versions.view.lkml"
#include: "/cube/stg_clts.entities.view.lkml"
#include: "/cube/stg_clts.olr_courses.view.lkml"
#include: "/cube/stg_clts.products.view.lkml"
#
#
label:"Test: Source Data stg_clts on Snowflake"
#
#
## CLTS
explore:activations_olr_v {
  label: "Import CLTS - Activations_v"
 # fields: [
#    # activations_olr Dimension
#    actv_code, actv_count, activations_olr.actv_datekey,
#    actv_dt_date, actv_dt_year,
#    platform, actv_isbn, source, code_type,
#    entity_no, platform, user_guid
#    ]
    # activations_olr Counters
#    ,activations_olr.actv_counter, activations_olr.actv_code_count, activations_olr.m_actv_count
    # entities
#    ,entities.enrollment_no,entities.institution_nm
    # products
#    ,products.discipline_de,products.hed_discipline_nm,products.imprint_de,products.isbn13,products.title
    # olr_courses
 #   ,olr_courses.course_key, olr_courses.course_name,olr_courses.entity_name_course
    # dim_date
#    ,dim_date.curated_fields*]
  }

#  join: entities{
#    sql_on: ${activations_olr.entity_no} = ${entities.entity_no} ;;
#    relationship: many_to_one
#    fields: [entities.enrollment_no,entities.institution_nm]
#    }
#  join: products {
#    sql_on: ${activations_olr.isbn13} = ${products.isbn13} ;;
#    relationship: many_to_one
#    fields: [products.discipline_de,products.hed_discipline_nm,products.imprint_de,products.isbn13,products.title]
#  }
#
#  join: olr_courses {
#    sql_on: ${activations_olr.context_id}=${olr_courses.context_id} ;;
#    relationship: many_to_one
#    fields: [olr_courses.course_key, olr_courses.course_name,olr_courses.entity_name_course]
#  }
#
#  join: dim_date {
#    view_label: "Date"
#    sql_on: ${activations_olr.actv_datekey} = ${dim_date.datekey} ;;
#    relationship: many_to_one
#    fields: [dim_date.curated_fields*]
#  }
#}

## CLTS (for imported model)
#explore:activations_olr {
#  label: "Import CLTS - Activations"
#  fields: [
#    # activations_olr Dimension
#    activations_olr.actv_code, activations_olr.actv_count, activations_olr.actv_datekey,
#    activations_olr.actv_dt_date, activations_olr.actv_dt_year,
#    activations_olr.actv_entity_id, activations_olr.isbn13, activations_olr.actv_entity_name,
#    activations_olr.platform, activations_olr.actv_isbn, activations_olr.code_source, activations_olr.code_type,
#    activations_olr.context_id, activations_olr.entity_no, activations_olr.platform, activations_olr.user_guid
#    # activations_olr Counters
#    ,activations_olr.actv_counter, activations_olr.actv_code_count, activations_olr.m_actv_count
#    # entities
#    ,entities.enrollment_no,entities.institution_nm
#    # products
#    ,products.discipline_de,products.hed_discipline_nm,products.imprint_de,products.isbn13,products.title
#    # olr_courses
#    ,olr_courses.course_key, olr_courses.course_name,olr_courses.entity_name_course
#    # dim_date
#    ,dim_date.curated_fields*]
#  join: entities{
#    sql_on: ${activations_olr.entity_no} = ${entities.entity_no} ;;
#    relationship: many_to_one
#    fields: [entities.enrollment_no,entities.institution_nm]
#    }
#  join: products {
#    sql_on: ${activations_olr.isbn13} = ${products.isbn13} ;;
#    relationship: many_to_one
#    fields: [products.discipline_de,products.hed_discipline_nm,products.imprint_de,products.isbn13,products.title]
#  }
#
#  join: olr_courses {
#    sql_on: ${activations_olr.context_id}=${olr_courses.context_id} ;;
#    relationship: many_to_one
#    fields: [olr_courses.course_key, olr_courses.course_name,olr_courses.entity_name_course]
#  }
#
#  join: dim_date {
#    view_label: "Date"
#    sql_on: ${activations_olr.actv_datekey} = ${dim_date.datekey} ;;
#    relationship: many_to_one
#    fields: [dim_date.curated_fields*]
#  }
#}
