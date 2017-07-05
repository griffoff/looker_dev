view: vw_dig_info_components {
  view_label: "DIG Components"
  sql_table_name: ESCAL.VW_DIG_INFO_COMPONENTS ;;

  dimension: component {
    type: string
    sql: ${TABLE}.COMPONENT ;;
  }

  dimension: key {
    type: string
    hidden: yes
    sql: ${TABLE}.KEY ;;
  }

  dimension:topSystem {
    type: yesno
    sql: ${TABLE}.COMPONENT in ('MindTap','SSO/OLR','CL Homework','DevMath','Gradebook','Mobile','MTQ','CNOW','CNOW MindApp','CNOW v7','CNOW v8','Aplia','CXP','OWL v2','OWL v1','SAM','4LTR Press Online','Cengagebrain.com','SSO Account Services') ;;
  }

  measure: count {
    label: "component count"
    type: count
    drill_fields: []
  }
}
