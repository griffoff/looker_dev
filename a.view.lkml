view: a {
  derived_table: {
    sql: with types as (
      select pp_pid
      , pp_product_type
      , array_agg(distinct cp_product_type) as cppt
      from  prod.unlimited.RAW_OLR_EXTENDED_IAC
      group by pp_pid, pp_product_type
      )


      , c as (
      select pp.user_sso_guid
      , count(distinct pp.iac_isbn) as cc
      from prod.unlimited.RAW_OLR_PROVISIONED_PRODUCT pp
      where pp.user_sso_guid not in (select user_sso_guid from prod.unlimited.CLTS_EXCLUDED_USERS)
      group by pp.user_sso_guid
      )

      ,products as (
      select pp.user_sso_guid as user_sso_guid
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
      , types
      where user_type like 'student'
      and types.pp_pid = pp.product_id
      and sourse like 'unlimited'
      )

      select * from c
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: top {
    type: max
    sql: ${cc} ;;

  }

  dimension: user_sso_guid {
    type: string
    sql: ${TABLE}."USER_SSO_GUID" ;;
  }

  dimension: pp_tier {
    type: tier
    tiers: [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26]
    style: integer   # the default value, could be excluded
    sql: ${cc} ;;
  }

  dimension: cc {
    type: number
    sql: ${TABLE}."CC" ;;
  }

  set: detail {
    fields: [user_sso_guid, cc]
  }
}
