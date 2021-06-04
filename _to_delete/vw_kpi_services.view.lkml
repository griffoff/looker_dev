# view: vw_kpi_services {
#   view_label: "KPI SERVICES"
#   derived_table: {
#     sql:
# SELECT
#   SERVISE::string as SERVICE
# , SERVICE_ID::number as SERVICE_ID
# , TARGET_ID::number as TARGET_ID
# , TARGET_URL::string as TARGET_URL
# , LOCATIONS::number as LOCATIONS
# FROM ESCAL.kpi_servises_id
#     ;;
#   }



#   dimension:CustomerSystem {
#     type: yesno
#     sql: ${TABLE}.SERVICE in ('4LTR Press Online v2 Techcheck','Aplia','Aplia Techcheck','CengageBrain DPS','CengageBrain Shop','CengageBrain SPS','CengageBrain Techcheck', 'CNOWv7 CVG Techcheck','CNOWv7 EAST Techcheck','CNOWv7 SJC Techcheck','CNOWv7 WEST Techcheck','CNOWv8 Techcheck','MindTap School Techcheck','MindTap Techcheck', 'MindTapMath-DevMath Techcheck','OWLv2 CVG Techcheck','OWLv2 EAST Techcheck','OWLv2 SJC Techcheck','OWLv2 WEST Techcheck', 'Questia Techcheck', 'SAM Techcheck', 'WebAssign Techcheck') ;;
#   }

#   dimension: SERVICE_Long {
#     type: string
#     sql: CONCAT( CONCAT(${TABLE}.SERVICE_ID,' - '),${TABLE}.SERVICE) ;;
#     drill_fields: [SERVICE_URL]
#   }

#   dimension: SERVICE {
#     type: string
#     sql: ${TABLE}.SERVICE ;;
#     drill_fields: [SERVICE_URL]
#   }

#   dimension: SERVICE_URL {
#     link: {
#       label: "Review in browser"
#       url: "{{value}}" }
#       sql: ${TABLE}.TARGET_URL ;;
#     }


#     dimension: SERVICE_ID {
#       type: string
#       sql: ${TABLE}.SERVICE_ID ;;
#       drill_fields: [SERVICE_URL]
#     }

#   dimension: TARGET_ID {
#     type: number
#     sql: ${TABLE}.TARGET_ID ;;
#   }

#   dimension: TARGET_URL {
#     type: string
#     sql: ${TABLE}.TARGET_URL ;;
#     link: {
#       label: "Review service"
#       url: "{{value}}"
#     }
#   }

#   dimension: LOCATIONS {
#     type: number
#     sql: ${TABLE}.LOCATIONS ;;
#   }


#   measure: count {
#     label: "Count"
#     type: count
#     # drill_fields: [SERVICE_URL MODIFIED_raw, MONITORED_raw, STATUS, SERVICE_ID, CHECK_UUID, LOCATION_NAME, TOTAL_TIME]
#   }

#   }
