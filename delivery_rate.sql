SELECT 

-- Compute the number of payment by the different time interval.

COUNT(DISTINCT CASE WHEN Time_diff.diff <= 10 then Time_diff.ID ELSE null END ) AS Less_than_10mins,
COUNT(DISTINCT CASE WHEN Time_diff.diff > 15 AND Time_diff.diff <= 30 then Time_diff.ID ELSE null END ) AS Between_15mins_and_30mins,
COUNT(DISTINCT CASE WHEN Time_diff.diff > 30 then Time_diff.id else null end) More_than_30mins
-- and Time_diff.diff <= 60 then Time_diff.ID ELSE null END ) AS Between_30mins_and_1hr,
-- COUNT(DISTINCT CASE WHEN Time_diff.diff > 60 and Time_diff.diff <= 120 then Time_diff.ID ELSE null END ) AS Between_1hr_and_2hr,
-- COUNT(DISTINCT CASE WHEN Time_diff.diff > 120 then Time_diff.ID ELSE null END ) AS More_than_2hrs

FROM
(
select transactions.id as id,
timestampdiff (minute,fund_withdrawals.created_at,fund_withdrawals.updated_at) as diff -- Calculate the processing time from when created to when updated in minutes

from transactions
left join users on users.id = transactions.user_id
left join countries on countries.id = users.country_id
left join fund_withdrawals on fund_withdrawals.transaction_id = transactions.id

where fund_withdrawals.status in ('confirmed')
and {{date}} 

) AS Time_diff