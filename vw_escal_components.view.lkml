view: vw_escal_components {
  view_label: "Escal Components"
  #sql_table_name: ESCAL.VW_ESCAL_COMPONENTS ;;
  derived_table: {
    sql:
      select
        detail.key
        ,k.value:name::string as component
        , detail.created
      from ${vw_escal_detail_prod.SQL_TABLE_NAME} detail
        , lateral flatten(components) k;;
  }

  dimension: component {
    type: string
    sql: case when  ${TABLE}.COMPONENT='MTQ' and ${TABLE}.created< TO_DATE('20180120', 'yyyymmdd') then 'zDEP_MTQ' else ${TABLE}.COMPONENT end  ;;
  }

  dimension: key {
    type: string
    hidden: yes
    sql: ${TABLE}.KEY ;;
  }

  dimension:topSystem {
    description: "Top platform is one of 'MindTap','SSO/OLR','CL Homework','DevMath','Gradebook','Mobile','MTQ','CNOW','CNOW MindApp','CNOW v7','CNOW v8','Aplia','CXP','OWL v2','OWL v1','SAM','4LTR Press Online','CengageBrain.com','SSO Account Services', 'WebAssign', 'MyCengage'"
    type: yesno
    sql: component in ('MindTap','SSO/OLR','CL Homework','DevMath','Gradebook','Mobile','MTQ','CNOW','CNOW MindApp','CNOW v7','CNOW v8','Aplia','CXP','OWL v2','OWL v1','SAM','4LTR Press Online','CengageBrain.com','SSO Account Services', 'WebAssign', 'MyCengage') ;;
  }

  measure: count {
    label: "component count"
    type: count
    drill_fields: []
  }
}
