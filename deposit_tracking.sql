select 
    countries.name
    -- date_format(transactions.created_at,'%YM%m')  as Month
    ,COUNT(*) count
    ,sum(deposits.deposit_amount) amount
from transactions
left join users on users.id = transactions.user_id
left join countries on countries.id = users.country_id
left join deposits on deposits.transaction_id = transactions.id
where deposits.status = 'confirmed' and {{date}} and {{countries}}
group by countries.name