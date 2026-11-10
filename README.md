E-Learning Platform Purchase Analytics using MySQL

📌 Project Overview

This repository contains a comprehensive database management and data analytics solution for an online e-learning platform using MySQL 8.0.

The goal of this project is to model transactional purchase data, execute multi-table joins, compute aggregation metrics, and derive actionable business insights regarding sales performance, course demand, customer spending behavior, and catalog performance.

🗄️ Database Schema Architecture

The relational database (elearning_db) consists of three primary tables structured with relational integrity, foreign key constraints, and cascading rules:

learners: Stores user profile details (learner_id, full_name, country).

courses: Contains catalog offerings (course_id, course_name, category, unit_price).

purchases: Transaction bridge/junction table (purchase_id, learner_id, course_id, quantity, purchase_date).

erDiagram
    learners ||--o{ purchases : "places"
    courses ||--o{ purchases : "contains"
    
    learners {
        int learner_id PK
        varchar full_name
        varchar country
    }
    courses {
        int course_id PK
        varchar course_name
        varchar category
        decimal unit_price
    }
    purchases {
        int purchase_id PK
        int learner_id FK
        int course_id FK
        int quantity
        date purchase_date
    }


🚀 Key Features & Analytical Queries

The SQL script (elearning_analytics.sql) provides data exploration and answers five key business questions:

Data Exploration (Multi-Table Joins):

INNER JOIN: Detailed purchase ledger with formatted pricing.

LEFT JOIN: Complete learner purchase matrix.

RIGHT JOIN: Catalog audit tracking course engagement.

Analytical Problem Solving (Q1–Q5):

Q1: Total spending per learner along with their country of origin.

Q2: Identification of the top 3 most purchased courses based on total quantity sold (LIMIT 3).

Q3: Category-wise revenue performance and count of distinct active learners.

Q4: Segmentation of learners purchasing across multiple distinct categories (HAVING COUNT(DISTINCT) > 1).

Q5: Audit of unpurchased course items (LEFT JOIN where purchase_id IS NULL).

📈 Key Insights & Financial Summary

Total Revenue Generated: ₹1,105.95 across 10 total units sold.

Top Revenue Category: Data Analytics generated ₹539.95 (48.8% of total revenue).

Highest Value Learner: RAMU spent ₹569.46 across 3 distinct course purchases.

Cross-Selling Engagement: 50% of active buyers purchased across multiple course categories.

Catalog Inefficiency: Advance Excel recorded 0 sales, representing underperforming catalog space.

📂 Project Structure

 elearning_analytics.sql               # Full SQL script (DDL, DML, Joins & Queries Q1-Q5)
 ELearning_Platform_Summary_Report.pdf # One-page PDF Executive Summary Report
  README.md                             # Project documentation
