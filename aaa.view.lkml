view: aaa {
  derived_table: {
    sql: with types as (
      select pp_pid
      , pp_product_type
      , array_agg(distinct cp_product_type) as cppt
      from  prod.unlimited.RAW_OLR_EXTENDED_IAC
      group by pp_pid, pp_product_type
      )


      , c as (
      select iac_isbn
      , count(_hash) as cc
      from prod.unlimited.RAW_OLR_PROVISIONED_PRODUCT
      group by iac_isbn
      )

      ,products as (
      select pp.user_sso_guid as user_sso_guid
      , c.cc
      , pp._hash as hash
      , pp.DATE_ADDED as local_time
      , pp.iac_isbn as isbn
      , pp.product_id as product_id
      , _ldts
      , code_type
      , context_id
      , core_text_isbn
      , date_added
      , expiration_date
      , institution_id
      , local_time as local_time_time
      , message_format_version
      , platform_environment
      , product_platform
      , region
      , source_id
      , user_environment
      , case when pp_product_type not like 'SMART' then pp_product_type else
      case when ARRAY_CONTAINS('MTC'::variant, cppt) then 'MTC' else
      case when ARRAY_CONTAINS('CSFI'::variant, cppt) then 'CSFI' else
      case when ARRAY_CONTAINS('4LT'::variant, cppt) then '4LT' else
      case when ARRAY_CONTAINS('APLIA'::variant, cppt) then 'APLIA' else
      case when ARRAY_CONTAINS('SAM'::variant, cppt) then 'SAM' else
      case when ARRAY_CONTAINS('CNOWV8'::variant, cppt) then 'CNOWV8' else
      case when ARRAY_CONTAINS('NATGEO'::variant, cppt) then 'NATGEO' else
      case when ARRAY_CONTAINS('MT4'::variant, cppt) then 'MT4' else
      case when ARRAY_CONTAINS('4LTV1'::variant, cppt) then '4LTV1' else
      case when ARRAY_CONTAINS('DEV-MATH'::variant, cppt) then 'DEV-MATH' else
      case when ARRAY_CONTAINS('OWLV8'::variant, cppt) then 'OWLV8' else
      case when ARRAY_CONTAINS('MTS'::variant, cppt) then 'MTS' else
      case when ARRAY_CONTAINS('WA'::variant, cppt) then 'WA' else
      case when ARRAY_CONTAINS('WA3P'::variant, cppt) then 'WA3P' else 'other' end
      end
      end
      end
      end
      end
      end
      end
      end
      end
      end
      end
      end
      end

      end as platform
      , pp."source" as sourse
      , pp.user_type as user_type
      , case when (pp."source" like 'unlimited' and pp.source_id like 'TRIAL') then 'b:TRIAL'
      else case when (pp."source" like 'unlimited' and pp.source_id not like 'TRIAL') then 'c:FULL'
      else 'a:EMPTY' end end as state
      from prod.unlimited.RAW_OLR_PROVISIONED_PRODUCT as pp
      , types, c
      where user_type like 'student'
      and types.pp_pid = pp.product_id
      and sourse like 'unlimited'
      and c.iac_isbn = pp.iac_isbn
      )

      select distinct products.cc, products.isbn from products
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: pp_tier {
    type: tier
    tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270, 280, 290, 300, 310, 320, 330, 340, 350, 360, 370, 380, 390, 400, 410, 420, 430, 440, 450, 460, 470, 480, 490, 500, 510, 520, 530, 540, 550, 560, 570, 580, 590, 600, 610, 620, 630, 640, 650, 660, 670, 680, 690, 700, 710, 720, 730, 740, 750, 760, 770, 780, 790, 800, 810, 820, 830, 840, 850, 860, 870, 880, 890, 900, 910, 920, 930, 940, 950, 960, 970, 980, 990, 1000]
    style: integer   # the default value, could be excluded
    sql: ${cc} ;;
  }

  dimension: cc {
    type: number
    sql: ${TABLE}."CC" ;;
  }

  dimension: isbn {
    type: string
    sql: ${TABLE}."ISBN" ;;
  }

  set: detail {
    fields: [cc, isbn]
  }
}
