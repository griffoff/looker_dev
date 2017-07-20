view: vw_escal_statuses  {
  derived_table: {
    sql: (
      with cut_detail as(
        select
          det.key as key
          , det.priority as priority
          , cat.category  as category
          , comp.component  as component
        from escal.vw_escal_detail as det
          , escal.vw_escal_categories as  cat
          , escal.vw_escal_components  comp
        where det.key = cat.key(+)
            and det.key = comp.key(+)
        -- this method will result in keys being counted more than once... but if they are tagged more than once
        -- they should be showed in all categories and components that they are tagged
      )
        select
          key
          , priority
          , category
          , component
        from cut_detail


      union (
        with  category_priority_component as (
          with
            category_priority as (
              with
                category as (
                    select distinct cat.category from
                      VW_ESCAL_DETAIL det,
                      vw_escal_categories cat
                      where det.key = cat.key(+)
                ),
                priority as (select distinct priority from
                              VW_ESCAL_DETAIL det
                )

              select category, priority
              from category
                    cross join priority
              ),

          product as (
            select distinct comp.component as product from
                      VW_ESCAL_DETAIL det,
                      vw_escal_components comp
                      where det.key = comp.key(+)
            )
            select
                category_priority.category
                , category_priority.priority
                , product
            from category_priority
                  cross join product
          )
      select
        CONCAT('dummy-',
          (ROW_NUMBER() OVER ( ORDER BY category))::string) AS key
          , priority
          , category
          , product as component
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
