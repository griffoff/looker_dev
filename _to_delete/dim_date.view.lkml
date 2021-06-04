# view: dim_date {
#   sql_table_name: DW_GA.DIM_DATE ;; # table DW_DEVMATH.DIM_DATE non-actual
#   set: curated_fields {fields:[datevalue_date,datevalue_week,datevalue_month,datevalue_month_name,datevalue_year,datevalue_day_of_week,count]}

#   dimension: calendarmonthid {
#     type: string
#     sql: ${TABLE}.CALENDARMONTHID ;;
#   }

#   dimension: calendarmonthname {
#     type: string
#     sql: ${TABLE}.CALENDARMONTHNAME ;;
#   }

#   dimension: calendarmonthofyearid {
#     type: string
#     sql: ${TABLE}.CALENDARMONTHOFYEARID ;;
#   }

#   dimension: calendarmonthofyearname {
#     type: string
#     sql: ${TABLE}.CALENDARMONTHOFYEARNAME ;;
#   }

#   dimension: calendarmonthofyearnameshort {
#     type: string
#     sql: ${TABLE}.CALENDARMONTHOFYEARNAMESHORT ;;
#   }

#   dimension: calendaryearvalue {
#     type: string
#     sql: ${TABLE}.CALENDARYEARVALUE ;;
#   }

#   dimension: cengageacademicterm {
#     type: string
#     sql: ${TABLE}.CENGAGEACADEMICTERM ;;
#   }

#   dimension: cengageacademictermid {
#     type: string
#     sql: ${TABLE}.CENGAGEACADEMICTERMID ;;
#   }

#   dimension: cengageacademicyear {
#     type: string
#     sql: ${TABLE}.CENGAGEACADEMICYEAR ;;
#   }

#   dimension: datekey {
#     type: string
#     sql: ${TABLE}.DATEKEY ;;
#   }

#   dimension_group: datevalue {
#     type: time
#     timeframes: [
#       raw,
#       date,
#       week,
#       month,
#       quarter,
#       year,
#       week_of_year,
#       month_name,
#       day_of_week,
#       day_of_year
#     ]
#     convert_tz: no
#     sql: ${TABLE}.DATEVALUE ;;
#   }

#   dimension: dayofweekid {
#     type: string
#     sql: ${TABLE}.DAYOFWEEKID ;;
#   }

#   dimension: dayofweekname {
#     type: string
#     sql: ${TABLE}.DAYOFWEEKNAME ;;
#   }

#   dimension: dayofweeknameshort {
#     type: string
#     sql: ${TABLE}.DAYOFWEEKNAMESHORT ;;
#   }

#   dimension: governmentdefinedacademicterm {
#     type: string
#     sql: ${TABLE}.GOVERNMENTDEFINEDACADEMICTERM ;;
#   }

#   dimension: governmentdefinedacademicterm_description {
#     type: string
#     sql: ${TABLE}.GOVERNMENTDEFINEDACADEMICTERM_DESCRIPTION ;;
#   }

#   dimension: governmentdefinedacademictermid {
#     type: string
#     sql: ${TABLE}.GOVERNMENTDEFINEDACADEMICTERMID ;;
#   }

#   dimension: governmentdefinedacademictermyear {
#     type: string
#     sql: ${TABLE}.GOVERNMENTDEFINEDACADEMICTERMYEAR ;;
#   }

#   dimension: hed_academicterm {
#     type: string
#     sql: ${TABLE}.HED_ACADEMICTERM ;;
#   }

#   dimension: hed_academictermid {
#     type: string
#     sql: ${TABLE}.HED_ACADEMICTERMID ;;
#   }

#   dimension: hed_academictermofyear {
#     type: string
#     sql: ${TABLE}.HED_ACADEMICTERMOFYEAR ;;
#   }

#   dimension: hed_academictermofyearid {
#     type: string
#     sql: ${TABLE}.HED_ACADEMICTERMOFYEARID ;;
#   }

#   dimension: hed_academicyear {
#     type: string
#     sql: ${TABLE}.HED_ACADEMICYEAR ;;
#   }

#   dimension: isoweekid {
#     type: string
#     sql: ${TABLE}.ISOWEEKID ;;
#   }

#   dimension: isoweekname {
#     type: string
#     sql: ${TABLE}.ISOWEEKNAME ;;
#   }

#   dimension: isoweekofyearid {
#     type: string
#     sql: ${TABLE}.ISOWEEKOFYEARID ;;
#   }

#   dimension: isoweekofyearname {
#     type: string
#     sql: ${TABLE}.ISOWEEKOFYEARNAME ;;
#   }

#   dimension: isoyearvalue {
#     type: string
#     sql: ${TABLE}.ISOYEARVALUE ;;
#   }

#   dimension: isweekend {
#     type: string
#     sql: ${TABLE}.ISWEEKEND ;;
#   }

#   dimension: isweekendname {
#     type: string
#     sql: ${TABLE}.ISWEEKENDNAME ;;
#   }

#   dimension: libertyacademicterm {
#     type: string
#     sql: ${TABLE}.LIBERTYACADEMICTERM ;;
#   }

#   dimension: libertyacademictermid {
#     type: string
#     sql: ${TABLE}.LIBERTYACADEMICTERMID ;;
#   }

#   dimension: libertyacademictermofyear {
#     type: string
#     sql: ${TABLE}.LIBERTYACADEMICTERMOFYEAR ;;
#   }

#   dimension: libertyacademictermofyearid {
#     type: string
#     sql: ${TABLE}.LIBERTYACADEMICTERMOFYEARID ;;
#   }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

#   # ----- Sets of fields for drilling ------
#   set: detail {
#     fields: [
#       calendarmonthofyearname,
#       dayofweekname,
#       isoweekofyearname,
#       calendarmonthname,
#       isoweekname,
#       isweekendname
#     ]
#   }
# }
