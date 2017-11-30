view: vw_twitter {
    view_label: "twitter"
  derived_table: {
    sql:
--    with all_twits as(
      SELECT
        a.value:name::string as channel
        ,b.value:date::string as dates
        ,b.value:favoriteCount::number AS favoriteCount
        ,b.value:user::string as user
        ,b.value:message::string as message
        ,b.value:time::string as time
        ,b.value:id::string as  id
        ,b.value:retwitCount::number as retwitCount
        ,c.value::string AS chainId
      FROM
        SCRAPING.TWITTER_INFORMATION,  --  TESTSCHEMAA.TWITTER_INFORMATION_copy,
        lateral flatten(input => information) a,
        lateral flatten(input => a.value:twits) b,
        lateral flatten(input => b.value:chainId, outer => true) c
--        )
--, twit_sent as (select t1.*
--,t2.positiv
--from all_twits t1
--left join TESTSCHEMAA.TWITS_SENTIMENT t2 on t1.id=t2.id)
--, twit_sent_stanford as (select t1.*
--,t2.positiv_min as positiv_min
--, t2.positiv_max as positiv_max
--from twit_sent t1
--left join TESTSCHEMAA.twits_sentiment_sentence t2 on t1.id=t2.id )
--select t1.*
--,t2.positiv_min as stanford_min
--, t2.positiv_max as stanford_max
--from twit_sent_stanford t1
--left join TESTSCHEMAA.TWITS_SENTIMENT_SENTENCE_STANFORD t2 on t1.id=t2.id
 ;;
  }

  dimension: createdatekey  {
    type: number
    sql: ${dates_year}*10000 + ${dates_month_num}*100 + ${dates_day_of_month} ;;
  }


  dimension: dialog {
    type: string
    sql: ${TABLE}.chainId ;;
  }


  dimension: dialog_start {
    type: yesno
    sql: ${dialog}<>${key} ;;  #or ${dialog} is null
  }

  measure: message_from_dialog {
    type: string
    sql:case when ${dialog_start} then ${message} else ${message}  end;;
    drill_fields: [key, channel,dialog,dates_raw,user,message]
  }

  dimension: key {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension_group: dates {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      month_name,
      quarter,
      year,
      day_of_week,
      hour_of_day,
      week_of_year,
      day_of_month,
      month_num
    ]
    sql: ${TABLE}.dates ;;
  }

  dimension_group: time {
    type: time
    timeframes: [
      raw,
      time
    ]
    sql: ${TABLE}.time ;;
    }

  dimension: user {
    type: string
    sql: ${TABLE}.user ;;
  }

  dimension: message {
    type: string
    sql: ${TABLE}.message ;;
  }

  dimension: positiv_value {
    type: number
    sql: ${TABLE}.positiv ;;
  }

  dimension: sentence_min {
    type: number
    sql: ${TABLE}.positiv_min ;;
  }

  dimension: sentence_max {
    type: number
    sql: ${TABLE}.positiv_max ;;
  }

  dimension: stanford_min {
    type: number
    sql: ${TABLE}.stanford_min ;;
  }

  dimension: stanford_max {
    type: number
    sql: ${TABLE}.stanford_max ;;
  }

  dimension: positiv_post {
    type: yesno
    sql: ( ${positiv_value} is not null) and ( ${positiv_value}>500 );;
  }

  dimension: positiv_post_by_min {
    type: yesno
    sql: ( ${sentence_min} is not null) and ( ${sentence_min}>420 and  ${positiv_value}>500) ;;
  }

  dimension: support_user {
    type: yesno
    sql:  ${user} in ('pearson','PearsonSupport','MHEducation','mhhighered');;
  }

  dimension: support_message {
    type: yesno
    sql: CONTAINS(${message}, 'Do you need help upgrading temporary') or
    CONTAINS(${message}, 'Check out our troubleshooting wizard') or
    CONTAINS(${message}, 'Check out our new troubleshooting wizard') or
    CONTAINS(${message}, 'Do you need an access code for your course?') or
    CONTAINS(${message}, 'If you receive a "cannot determine the product" message while registering, please see') or
    CONTAINS(${message}, 'Do you need help opening homework, quizzes, or tests') or
    CONTAINS(${message}, 'Some Pearson course content opens in new windows') or
    CONTAINS(${message}, 'Questions about entering answers in your course') or
    CONTAINS(${message}, 'Need help retrieving your username (login name) or password') or
    CONTAINS(${message}, 'Follow the steps listed at') or
    CONTAINS(${message}, 'Already have a pearson account, but need to enroll in') or
    CONTAINS(${message}, 'Having trouble registering for your course') or
    CONTAINS(${message}, 'Need help signing in') or
    CONTAINS(${message}, 'While registering, are you receiving a message stating your access code was not found') or
    CONTAINS(${message}, 'System status updates can be found at') or
    CONTAINS(${message}, 'Our support site can be found at') or
    CONTAINS(${message}, 'Using a Pearson website with the safari browser') or
    CONTAINS(${message}, 'If you need help getting')
    ;;
  }

  dimension: retwitCount {
    type: number
    sql: ${TABLE}.retwitCount ;;
  }

  dimension: favoriteCount {
    type: number
    sql: ${TABLE}.favoriteCount ;;
  }

  #dimension: chainId {
  #  type: number
  #  sql: ${TABLE}.chainId ;;
  #  }

  measure: count_dialog {
    type: count_distinct
    sql: ${dialog};;
    drill_fields: [key, channel,dialog,dates_raw,user,message]
  }

  measure: count {
    type: count_distinct
    sql: ${key};;
    drill_fields: [key, channel,dates_raw,user,message]
  }


}
