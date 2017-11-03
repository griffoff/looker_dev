view: vw_twitter {
    view_label: "twitter"
  derived_table: {
    sql:
with
 channels as(
   select
 i.value:name::string as channel
, i.value:twits as twits
FROM TESTSCHEMAA.TWITTER_INFORMATION_copy
, lateral flatten(input => INFORMATION) i   )
, all_twits as(
select
channel
--, i.value:chainId::number as chainId
, i.value:date::string as dates
, i.value:favoriteCount::number as favoriteCount
, i.value:id::number as  id
, i.value:message::string as message
, i.value:retwitCount::number as retwitCount
, i.value:time::string as time
, i.value:user::string as user
from channels
 , lateral flatten(input => twits) i
where dates<'2017-10-27')
, twit_sent as (select t1.*
,t2.positiv
from all_twits t1
left join TESTSCHEMAA.TWITS_SENTIMENT t2 on t1.id=t2.id)
, twit_sent_stanford as (select t1.*
,t2.positiv_min as positiv_min
, t2.positiv_max as positiv_max
from twit_sent t1
left join TESTSCHEMAA.twits_sentiment_sentence t2 on t1.id=t2.id )
select t1.*
,t2.positiv_min as stanford_min
, t2.positiv_max as stanford_max
from twit_sent_stanford t1
left join TESTSCHEMAA.TWITS_SENTIMENT_SENTENCE_STANFORD t2 on t1.id=t2.id
 ;;
  }

  dimension: createdatekey  {
    type: number
    sql: ${dates_year}*10000 + ${dates_month_num}*100 + ${dates_day_of_month} ;;
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

  measure: count {
    type: count
    drill_fields: [key, message,positiv_value,sentence_min,sentence_max]
  }


}
