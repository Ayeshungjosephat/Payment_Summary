SELECT
    countries.name Country, 
    (Case    
        WHEN (time(fund_withdrawals.updated_at) >= '07:00:00' AND time(fund_withdrawals.updated_at) < '14:00:00') THEN 'Morning'
        WHEN (time(fund_withdrawals.updated_at) >= '14:00:00' AND time(fund_withdrawals.updated_at) < '20:00:00') THEN 'Afternoon'
        ELSE 'night'
     END) AS shifts, -- Creates the different shift based on the shift time.
    
    -- All necessary computations
    
    COUNT(DISTINCT CASE WHEN fund_withdrawals.status = 'confirmed' THEN fund_withdrawals.id ELSE NULL END) AS Successful_trn, 
    sum(CASE WHEN fund_withdrawals.status = 'confirmed' THEN fund_withdrawals.withdrawal_amount ELSE NULL END) AS successful_Amount,
    COUNT(DISTINCT CASE WHEN fund_withdrawals.status = 'declined' THEN fund_withdrawals.id ELSE NULL END) AS Declined_trn, 
    sum(CASE WHEN fund_withdrawals.status = 'declined' THEN fund_withdrawals.withdrawal_amount ELSE NULL END) AS Declined_Amount,
    COUNT(DISTINCT CASE WHEN fund_withdrawals.status = 'proccessing' THEN fund_withdrawals.id ELSE NULL END) AS processing_payment, 
    sum(CASE WHEN fund_withdrawals.status = 'proccessing' THEN fund_withdrawals.withdrawal_amount ELSE NULL END) AS processing_payment

from transactions
    left join users on users.id = transactions.user_id
    left join countries on countries.id = users.country_id
    left join fund_withdrawals on fund_withdrawals.transaction_id = transactions.id
where {{date}} -- Create a date filter
group by countries.name,shifts