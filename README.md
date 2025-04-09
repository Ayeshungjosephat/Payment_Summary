# 🧾 Daily Payment Summary Dashboard

A dashboard created to monitor real-time/daily payment transactions across different countries and shifts, showing success rates, declined transactions, processing time, and deposit summaries.

## 📸 Screenshot

![image](https://github.com/user-attachments/assets/d99f5660-fbed-4d25-863a-28238faf0118)


## 📊 Features

- Transaction breakdown by country and shift
- Real-time payment delivery speed
- Average processing time
- Deposits tracking
- Total success and failure trends

## 🛠 Tools Used

- Metabase (for dashboard creation)
- MySQL (for querying and backend data)
- Excel / Power Query (for preprocessing — optional)

## 📁 Files
- sql query
  ```
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


## 📈 Use Case

Useful for:
- Reconciliation teams
- Operations monitoring
- Daily reporting

## 🧠 Insights

- Most successful payments occur during the night shift in Nigeria.
- Payments are processed in less than 10 minutes on average.
- Very low decline rates observed across shifts.



