view: vw_escal_components_prod {
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
    description: "Keep in mind that a ticket can have a few components."
    type: string
    sql: case when  ${TABLE}.COMPONENT='MTQ' and ${TABLE}.created< TO_DATE('20180120', 'yyyymmdd') then 'zDEP_MTQ' else ${TABLE}.COMPONENT end  ;;
   # link: {
   #   label: "Filter on this component"
   #   url: "https://cengage.looker.com/dashboards/jira::escal?Component={{component}}&f[vw_escal_categories_prod.category]={{ _filters[vw_escal_categories_prod.category] | url_encode }}"
    }
  # }

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
    description: "Keep in mind that a ticket can have a few components."
    label: "component count"
    type: count
   # drill_fields: []
  }
}
