# view: vw_dig_info_inwardissue {
#   view_label: "DIG Inward Issues"
#   sql_table_name: ZSS.vw_dig_info_inwardissue ;;

#   dimension: key {
#     type: string
#     hidden: yes
#     sql: ${TABLE}.KEY ;;
#   }

#   dimension: inward_issue_key {
#     type: string
#     sql: ${TABLE}.issuelinks_key ;;
#   }

#   dimension: inward_issue_status {
#     type: string
#     sql: ${TABLE}.status ;;
#   }
#   dimension: inward_issue_status_grouped_by_Defect_Fixing {
#     type: string
#     sql: case when ${inward_issue_status}='Master Defect Fixing'
#                 OR ${inward_issue_status}='Snapshot Defect Fixing'
#                 OR ${inward_issue_status}='Product Defect Fixing'
#                 then 'Defect Fixing' else ${inward_issue_status} end;;
#   }

#   dimension: inward_issue_summary {
#     type: string
#     sql: ${TABLE}.summary ;;
#   }

#   dimension: inward_issue_status_category {
#     type: string
#     sql: ${TABLE}.status_category ;;
#   }

#   dimension: inward_issue_priority {
#     type: string
#     sql: ${TABLE}.priority ;;
#   }

#   dimension: inward_issue_issuetype {
#     type: string
#     sql: ${TABLE}.issuetype ;;
#   }



# }
