USE BANKLOAN;

-- 1. Display all records from Customer
select * from customer;

-- 2. Show only customer_id, customer_name, and annual_income from Customer_new.
select customer_id, customer_name, annual_income from customer;

-- 3. Find customers whose annual_income is greater than 600000.
select customer_name, annual_income from customer where annual_income > 600000;

-- 4. Display all loans where loan_amount > 300000.
select loan_id, loan_amount from loan where loan_amount >300000;

-- 5. Show all customers who belong to a particular state.
select * from customer where state ='maharashtra';

-- 6. Display customers ordered by annual_income in descending order.
select * from customer order by annual_income desc;

-- 7. Show loans ordered by interest_rate from lowest to highest.
select * from loan order by interest_rate asc;

-- 8. Display the top 5 highest loan amounts.
select loan_amount from loan order by loan_amount desc limit 5;

-- 9. Count the total number of customers.
select count(*) from customer;

-- 10. Find the average loan amount.
select avg(loan_amount) as avg_loan_amount from loan;

-- 11. Find the maximum and minimum credit score.
select max(credit_score) as max_credit_sc, min(credit_score) as min_credit_sc from credit;

-- 12. Calculate the total loan amount issued.
select sum(loan_amount) as sum_loan_amount from loan;

-- 13. Find customers where credit_score is NULL.
select * from credit where credit_score is null;
# select * from credit;

-- 14. Replace NULL interest_rate with 0 using COALESCE().
select coalesce(interest_rate, 0) from loan;
select ifnull(interest_rate, 0) from loan;

-- 15. Count how many customers do not have credit data.
select count(distinct c.customer_id) as customer_without_credit from customer c 
left join loan l on c.customer_id= l.customer_id  
left join credit cr on l.credit_profile_id=cr.credit_profile_id
where cr.credit_profile_id is null;

-- 16. Find total loan amount issued per state.
select sum(loan_amount) as total_loan_amount, state from loan l join customer c on l.customer_id = c.customer_id group by state;

-- 17. Count number of loans per tenure_months.
select count(*) as count_of_loans, tenure_months from loan group by tenure_months;

-- 18. Find average loan amount per employment type.
select avg(loan_amount) as avg_loan_amount from loan l join customer c on l.customer_id= c.customer_id group by employment_type;

-- 19. Calculate average credit score per state.
select avg(credit_score), state as avg_credit_sc from credit cr 
join loan l on cr.credit_profile_id = l.CREDIT_PROFILE_ID
join customer c on c.customer_id = l.customer_id
group by state;

-- 20. Show states where average income > 1300000.
select  avg(annual_income) as avg_annual_income, state from customer group by state having avg_annual_income > 1300000;

-- 21. Find states having more than 50 customers.
select count(customer_id) as count_of_customer, state from customer group by state having count_of_customer > 50;

-- 22. Show loan status where average loan amount > 1200000.
select loan_status, loan_amount from loan where loan_amount > 1200000;

-- 23. Join Customer and Loan to display customer name with loan amount.
select customer_name, loan_amount from customer c join loan l on c.customer_id = l.customer_id;

-- 24. Join Customer and Credit to show customer name and credit score.
select c.customer_name, cr.credit_score from customer c 
join loan l on c.customer_id = l.customer_id
join credit cr on cr.credit_profile_id = l.credit_profile_id;

-- 25. Display customer name, loan amount, and credit score using 3-table join.
select c.customer_name, l.loan_amount, cr.credit_score from customer c 
join loan l on c.customer_id = l.customer_id
join credit cr on cr.credit_profile_id = l.credit_profile_id;

-- 26. Find customers who have taken more than one loan.
select count(loan_id) as total_loan, customer_id from loan group by customer_id having total_loan > 1;

-- 27. Find customers who have not taken any loan .
select distinct c.customer_id,c.customer_name from customer c left join loan l on c.customer_id = l.customer_id where loan_id is null;

-- 28. Categorize customers as:
--   (A) High Risk (credit_score < 600)
--   (B) Medium Risk (600–750)
--   (C) Low Risk (>750)
select credit_profile_id, credit_score, 
case when credit_score < 600 then 'HIGH RISK'
     when credit_score between 600 and 750 then 'MEDIUM RISK'
     else 'LOW RISK'
end as loan_risk_category
from credit;

-- 29. Create a column showing:
--      (A) High Income if income > 2000000
--      (B) Medium Income if 1500000–800000
--      (C) Low Income otherwise.
select customer_id, annual_income,
case when annual_income > 2000000 then 'HIGH INCOME'
     when annual_income between 1500000 and 800000 then 'MEDIUM INCOME'
     else 'LOW INCOME'
end income_category
from customer;
# select * from customer;

-- 30. Find customers whose loan amount is greater than average loan amount.
select  customer_id, loan_amount from loan where loan_amount > (select avg(loan_amount) as avg_loan_amt from loan);
select avg(loan_amount) as avg_loan_amt from loan;
select loan_amount from loan;

-- 31. Find customers whose credit score is higher than the average credit score.
select credit_profile_id, credit_score from credit where credit_score > (select avg(credit_score) as avg_Credit_sc from credit);

-- 32. Find the second highest loan amount.
select max(loan_amount) from loan where loan_amount < (select max(loan_amount) as max_loan_amt from loan);
select max(loan_amount) as max_loan_amt from loan;
select  loan_amount from loan order by loan_amount desc limit 1 offset 1;

-- 33. Find customers who have loan amount greater than the average loan amount of their state.
select l.loan_amount, c.state from loan l join customer c on l.customer_id = c.customer_id where loan_amount > (select avg(loan_amount) from loan group by state);

-- 34. Rank customers based on annual_income using RANK().
select customer_id, annual_income, dense_rank() over(order by annual_income desc) as income_rank from customer group by annual_income,customer_id;

-- 35. Find top 3 highest loans in each state using window functions.
select loan_amount, loan_amt_rank, state
from (select c.state,loan_amount, rank() over(partition by c.state order by loan_amount desc) as loan_amt_rank from loan l join customer c on l.customer_id = c.customer_id)t
where loan_amt_rank <=3;

-- 36. Calculate running total of loan amount ordered by disbursal date.
select disbursal_date, loan_amount, sum(loan_amount) over(order by disbursal_date) as running_total from loan;  

-- 37. Show difference between current loan amount and previous loan amount using LAG().
select disbursal_date, loan_amount, loan_amount - lag(loan_amount) over(order by loan_amount) as loan_difference from loan;

-- 38. Using CTE, find customers whose credit score is below the average credit score of their state.
with state_avg_credit as (
     select c.state, avg(credit_score) as avg_credit_score from credit cr
     join loan l on cr.credit_profile_id = l.credit_profile_id
	 join customer c on c.customer_id = l.customer_id 
	 group by c.state
)
select c.customer_id,c.customer_name, c.state, cr.credit_score , avg_credit_score from customer c 
join loan l on c.customer_id = l.customer_id 
join credit cr on cr.credit_profile_id = l.credit_profile_id
join state_avg_credit s on c.state = s.state
where cr.credit_score < s.avg_credit_score;


-- 39. Identify high income customers with low credit score but large loan amount.
SELECT c.customer_id,c.customer_name,c.annual_income,cr.credit_score,l.loan_amount from customer c
JOIN loan l ON c.customer_id = l.customer_id
JOIN credit cr ON l.credit_profile_id = cr.credit_profile_id
WHERE c.annual_income > 2300000
AND cr.credit_score < 650
AND l.loan_amount > 1100000;

-- 40. Find customers who:
--    (A) Have loan amount greater than average loan
--    (B) Have credit score < 650
--    (C) Have annual_income < loan amount
select c.customer_id, c.customer_name, cr.credit_score, c.annual_income, l.loan_amount from customer c 
join loan l on c.customer_id = l.customer_id
join credit cr on cr.credit_profile_id = l.credit_profile_id
where l.loan_amount > (select avg(LOAN_AMOUNT) from loan)
and cr.credit_score < 650
and c.annual_income < l.loan_amount;