create database projectdb;
use projectdb;
show tables;
select * from finance_1_new limit 5;
show create table finance_1_new;
select * from finance_1_new;
select * from finance_2_new limit 50;

alter table finance_2_new rename column ï»¿id to id;

-- KPI- 1 Stat 
-- Total Loan Amount By Year
select year(issue_d) as Year,sum(loan_amnt) as Total_of_Loan_Amount from finance_1_new group by Year order by total_of_Loan_Amount;
select year(issue_d) as issued_year,min(loan_amnt) as min_loan_Amt from finance_1_new group by issued_year order by issued_year;
select year(issue_d) as issued_year,max(loan_amnt) as max_loan_Amt from finance_1_new group by issued_year order by issued_year;
select year(issue_d) as issued_year,round(stddev(loan_amnt),2) as Stdv_loan_Amt from finance_1_new group by issued_year order by issued_year;
select year(issue_d) as issued_year,round(Avg(loan_amnt),2) as Average_loan_Amt from finance_1_new group by issued_year order by issued_year;
select year(issue_d) as issued_year,round(var_samp(loan_amnt),2) as Variance_Loan_Amt from finance_1_new group by issued_year order by issued_year;

-- KPI-2 Grade and sub grade wise revol_bal
select f1.grade , f1.sub_grade ,sum(f2.revol_bal)  as total_revol_bal 
from finance_1_new as f1 inner join finance_2_new as f2 on f1.id= f2.id 
group by f1.grade , f1.sub_grade 
order by f1.grade;

--  KPI - 3 Total Payment for Verified Status Vs Total Payment for Non Verified Status
select f1.verification_status,concat("$",format(round(sum(total_pymnt)/1000000,2),2),"M") AS total_payment
FROM finance_1_new AS f1 INNER JOIN  finance_2_new AS f2 ON     f1.id = f2.id
WHERE f1.verification_status = 'Verified' OR f1.verification_status = 'Not Verified'
GROUP BY f1.verification_status;

-- KPI-4 State wise and month wise loan status
select f1.addr_state , f2.last_credit_pull_d , f1.loan_status,count(f1.loan_status) 
as total_loan_status from finance_1_new as f1 inner join finance_2_new as f2  on f1.id = f2.id 
group by f1.loan_status, f1.addr_state,f2.last_credit_pull_d;

-- KPI -5 Home ownership Vs last payment date stats
select home_ownership, last_pymnt_d, concat("$" , format(round(sum(last_pymnt_amnt)/1000, 2), 2), 'K') as total_amount
from finance_1_new inner join finance_2_new  on(finance_1_new.id = finance_2_new.id)
group by home_ownership, last_pymnt_d order by last_pymnt_d desc, home_ownership desc;

select home_ownership, last_pymnt_d, concat("$" ,round(AVG(last_pymnt_amnt),2)) as total_amount
from finance_1_new inner join finance_2_new  on(finance_1_new.id = finance_2_new.id)
group by home_ownership, last_pymnt_d order by last_pymnt_d desc, home_ownership desc;

select home_ownership, last_pymnt_d, concat("$" , round(MIN(last_pymnt_amnt), 2)) as MIN_amount
from finance_1_new inner join finance_2_new  on(finance_1_new.id = finance_2_new.id)
group by home_ownership, last_pymnt_d order by last_pymnt_d desc, home_ownership desc;

select home_ownership, last_pymnt_d, concat("$" ,round(MAX(last_pymnt_amnt), 2)) as Max_amount
from finance_1_new inner join finance_2_new  on(finance_1_new.id = finance_2_new.id)
group by home_ownership, last_pymnt_d order by last_pymnt_d desc, home_ownership desc;

select home_ownership, last_pymnt_d, concat("$" ,round(stddev(last_pymnt_amnt), 2)) as Standard_deviation__amount
from finance_1_new inner join finance_2_new  on(finance_1_new.id = finance_2_new.id)
group by home_ownership, last_pymnt_d order by last_pymnt_d desc, home_ownership desc;

-- # count of member from state (MAP VISUAL)
select addr_state as state_name , count(id) as total_customer from finance_1_new
group by addr_state
order by total_customer desc;

-- Top KPI -- 
-- 1) Total Funded Amount
select sum(funded_amnt) as Total_Funded_Amount from finance_1_new;

-- 2) Average Funded Amount
select round(avg(funded_amnt)) as Average_Funded_Amount from finance_1_new;

-- 3) Average Interst Rate
select concat(round(avg(int_rate),2),"%") as Avg_interest_rate from finance_1_new;

-- 4) Total Loan Amount
select sum(loan_amnt) as Total_Loan_Amount from finance_1_new;

-- 5) Total Members Applied for loan
select count(member_id) as Total_Loan_Application  from finance_1_new;

-- # /* main purpose for loan amount */
select purpose,sum(loan_amnt) as Loan_amnt,concat(round((sum(loan_amnt)*100/(select sum(loan_amnt)
from FINANCE_1_NEW)),2),"%") as Percentage from finance_1_new
group by purpose;

/* Yearly Interest Received */
select (last_pymnt_d) as received_year, cast(sum(total_rec_int) as decimal (10,2)) as interest_received
 from finance_2_new
group by received_year
order by received_year;

-- terms wise popularity 
select term, count(term) as total_term from finance_1_new 
group by term;

-- State vs revol bal:
select addr_state,sum(revol_bal) as total_revol_bal from finance_1_new
inner join finance_2_new on(finance_1_new.id = finance_2_new.id) 
group by addr_state 
order by addr_state;

