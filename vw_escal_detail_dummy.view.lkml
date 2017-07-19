view: vw_escal_detail_dummy  {
      derived_table: {
        sql: (
  with cut_detail as(
select
det.key as key,
det.priority as priority,
cat.value:value::string  as category,
comp.value:name::string  as component
from escal.vw_escal_detail as det, LATERAL FLATTEN(input => categories )  cat, LATERAL FLATTEN(input => components )  comp
where component in  ('MindTap','SSO/OLR','CL Homework','DevMath','Gradebook','Mobile','MTQ','CNOW','CNOW MindApp','CNOW v7','CNOW v8','Aplia','CXP','OWL v2','OWL v1','SAM','4LTR Press Online','Cengagebrain.com','SSO Account Services')
and priority in ('P1 Escalation','P2 Escalation','P3 Escalation')
                    )
select
 key,
 priority,
 category,
 component
from cut_detail
  )
        union
        (
with  category_priority_component as (
with
category_priority as (
with
    category as (select   column1 as category
        from values ('Digital Production'),('Content Development'),('Software'),('No Category')),
    priority as (select column1 as priority
        from values ('P1 Escalation'),('P2 Escalation'),('P3 Escalation'))
select category,priority
from category
cross join priority
                    ),
    product as (select column1 as product
        from values ('MindTap'),('CL Homework'),('DevMath'),('Gradebook'),('Mobile'),('MTQ'),('CNOW'),('CNOW MindApp'),('CNOW v7'),('CNOW v8'),('Aplia'),('CXP'),('SSO/OLR'),('OWL v2'),('OWL v1'),('SAM'),('4LTR Press Online'),('Cengagebrain.com'),('SSO Account Services') )
select
     category_priority.category, category_priority.priority, product
from category_priority
cross join product                    )
select CONCAT('dummy-',(ROW_NUMBER() OVER ( ORDER BY category))::string) AS key, priority, category,  product as component
from category_priority_component
          )
      ;;
      }

      dimension: key {
        type: string
        sql: ${TABLE}.key ;;
      }

  dimension: priority {
    type: string
    sql: ${TABLE}.priority ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: component {
    type: string
    sql: ${TABLE}.component ;;
  }

  measure: count {
    type: count
    drill_fields: [key, priority, category, component]

  }

    }
