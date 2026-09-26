# Customer Cohort Retention Analysis
### Olist Brazilian E-Commerce Dataset

## Project Summary
A cohort-based retention analysis of ~99,000 orders from Olist, a Brazilian 
e-commerce marketplace. The project traces customer purchasing behavior over 
time to answer a core business question: **do customers come back?**

Built end-to-end — from raw CSV ingestion through SQL-based data modeling to 
a visual, interactive dashboard.

## Key Finding
Retention drops from 100% to under 1% within a single month across nearly 
every cohort. Olist functions as a **one-time-purchase marketplace** rather 
than a repeat-customer business — a pattern that has direct implications for 
how the company should think about growth, marketing spend, and customer 
lifetime value.

*Note: Cohorts from the first and last two months of the dataset (Sept–Oct 
2016 and Sept–Oct 2018) contain very small sample sizes (as low as a single 
customer) and were excluded from trend interpretation, since their retention 
percentages are not statistically meaningful.*

## Business Implications
- Growth on this platform is driven almost entirely by **new customer 
  acquisition**, not repeat purchases — a fundamentally different growth 
  model than subscription or SaaS businesses
- Customer Lifetime Value (LTV) should be modeled around a single-purchase 
  assumption, not multi-period retention curves
- Any investment in loyalty programs, post-purchase engagement, or 
  second-purchase incentives represents a largely untapped growth lever, 
  since almost no infrastructure currently exists to bring customers back

## Methodology
1. **Cohort assignment** — each customer (identified by `customer_unique_id`, 
   since Olist assigns a new `customer_id` per order) was assigned to a 
   cohort based on the calendar month of their first purchase
2. **Month-number calculation** — for every order, calculated the number of 
   months elapsed since that customer's first purchase (month 0 = first 
   purchase month)
3. **Retention aggregation** — counted distinct active customers per 
   (cohort, month) pair, then converted to a retention percentage relative 
   to each cohort's original size
4. **Visualization** — modeled as a color-graded heatmap, where color 
   intensity communicates retention strength at a glance

## Tools & Tech Stack
| Tool | Purpose |
|---|---|
| PostgreSQL (via Supabase) | Data storage, CTE-based SQL modeling, retention logic |
| Power BI | Interactive cohort heatmap visualization |


## Dataset
[Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) 
— ~99,441 orders spanning September 2016 to October 2018.

## Skills Demonstrated
- SQL: CTEs, window-style aggregation logic, view creation
- Data modeling: cohort analysis, a standard retention/LTV technique used 
  across SaaS, e-commerce, and subscription businesses
- Data visualization: heatmap design, conditional formatting
- Analytical judgment: identifying and excluding statistically unreliable 
  small-sample cohorts rather than blindly reporting raw numbers
