SELECT 
    -- day(created_at),
     -- start_time,
     -- end_time,
     -- start_to_end_time.created_at,
     -- start_to_end_time.start_time,
     -- start_to_end_time.end_time,
     -- start_to_end_time.withdrawal_amount,
     -- start_to_end_time.reference_code,
     -- start_to_end_time.bank_name,
     
    -- calculates the average processing time. 
    
    CONCAT(
        FLOOR(MOD(AVG(TIMESTAMPDIFF(SECOND, created_at, end_time)), 3600 * 24) / 3600), ' hours ',
        FLOOR(MOD(AVG(TIMESTAMPDIFF(SECOND, created_at, end_time)), 3600) / 60), ' minutes ',
        FLOOR(MOD(AVG(TIMESTAMPDIFF(SECOND, created_at, end_time)), 60)), ' seconds ') AS PROCESSING_TIME 
FROM

(
select
     fund_withdrawals.id,
     payment_gateways.name AS payment_gateway, 
     fund_withdrawals.created_at,
     fund_withdrawals.updated_at,
     fund_withdrawals.withdrawal_amount,
     transactions.reference_code,
     JSON_UNQUOTE(JSON_EXTRACT(fund_withdrawals.withdrawal_details, '$.bank_name')) AS bank_name,
     countries.name As country_name,
     max(Case when updated_status = 'proccessing' then fund_withdrawal_logs.created_at end) AS start_time, -- pulls when the transaction status changes from pending to processing as the start time.
     max(Case when updated_status = 'confirmed' then fund_withdrawal_logs.created_at end) AS end_time -- pulls when the transaction status changes from processing to confirmed as the end time
                
from transactions
     left join users on users.id = transactions.user_id 
     left join countries on countries.id = users.country_id
     left join fund_withdrawals on fund_withdrawals.transaction_id = transactions.id
     left join fund_withdrawal_logs on fund_withdrawals.id = fund_withdrawal_logs.fund_withdrawal_id
     left join payment_gateways on payment_gateways.id = fund_withdrawal_logs.payment_gateway_id
        
where fund_withdrawals.status = 'confirmed' and {{date}} 


group by
    fund_withdrawals.id,payment_gateways.name,
    fund_withdrawals.created_at, countries.name, fund_withdrawals.updated_at
) AS start_to_end_time   

-- GROUP BY 1,2,3,4,5,6
-- ORDER BY PROCESSING_TIME desc
