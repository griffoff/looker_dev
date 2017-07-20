view: vw_escal_detail_dummy  {
      derived_table: {
        sql: (
  with cut_details_categories_components as(
with details_categories as (
select
    det.key,
    det.priority,
    cat.category
    from escal.vw_escal_detail det
    left join escal.vw_escal_categories cat on det.key=cat.key
                            )
select
dc.key as key,
dc.priority as priority,
case when dc.category is null then  'No Category' else  dc.category end as category,
--dc.category as category,
com.component  as component
from details_categories as dc
  left  join escal.VW_ESCAL_COMPONENTS com on dc.key=com.key
                                        )
select
 key,
 priority,
 category,
 component
from cut_details_categories_components
  )
        union
        -- create dummy issue as CROSS JOIN  category x product x priority
        -- dummy issue has prefix 'dummy-'
        (
with  category_priority_component as (
with
category_priority as (
with
    category as (select   column1 as category
        from values ('Digital Production'),('Content Development'),('Software'),('No Category')),
    priority as (   select priority
                    from escal.vw_escal_detail
                    group by priority)
select category,priority
from category
cross join priority
                    ),
    product as (select COMPONENT as product
                from escal.VW_ESCAL_COMPONENTS
                group by COMPONENT)
select
     category_priority.category, category_priority.priority, product
from category_priority
cross join product                    )
-- dummy issue has prefix 'dummy-'
select CONCAT('dummy-',(ROW_NUMBER() OVER ( ORDER BY category))::string) AS key, priority, category,  product as component
from category_priority_component
          )
      ;;
      }

      dimension: key {
        type: string
        primary_key: yes
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

  dimension:topSystem {
    type: yesno
    sql: ${TABLE}.COMPONENT in ('MindTap','SSO/OLR','CL Homework','DevMath','Gradebook','Mobile','MTQ','CNOW','CNOW MindApp','CNOW v7','CNOW v8','Aplia','CXP','OWL v2','OWL v1','SAM','4LTR Press Online','Cengagebrain.com','SSO Account Services') ;;
  }

  measure: count {
    type: count
    drill_fields: [key, priority, category, component]

  }

    }
