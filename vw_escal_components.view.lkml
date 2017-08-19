view: vw_escal_components {
  view_label: "Escal Components"
  #sql_table_name: ESCAL.VW_ESCAL_COMPONENTS ;;
  derived_table: {
    sql:
      select
        detail.key
        ,k.value:name::string as component
      from ${vw_escal_detail.SQL_TABLE_NAME} detail
        , lateral flatten(components) k;;
  }

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
    sql: ${TABLE}.COMPONENT in ('MindTap','SSO/OLR','CL Homework','DevMath','Gradebook','Mobile','MTQ','CNOW','CNOW MindApp','CNOW v7','CNOW v8','Aplia','CXP','OWL v2','OWL v1','SAM','4LTR Press Online','CengageBrain.com','SSO Account Services') ;;
  }

  measure: count {
    label: "component count"
    type: count
    drill_fields: []
  }
}
