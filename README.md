# 🛒 Olist E-Commerce Customer Satisfaction Analysis

> **Analyzing customer satisfaction, delivery performance, and logistics bottlenecks using Python, SQL, and Power BI.**

---

## 📌 Business Question

Management noticed that customer satisfaction has been inconsistent and wants to understand:

* What factors are associated with lower customer satisfaction?
* How strongly does delivery performance relate to review scores?
* Where do the biggest delivery bottlenecks occur?
* Is the problem primarily related to sellers, carriers, products, or geography?

**Review score was used as a proxy for customer satisfaction throughout the analysis.**

---

## 📊 Project Overview

This project analyzes the **Brazilian E-Commerce Public Dataset by Olist** to investigate factors associated with customer satisfaction and identify operational bottlenecks in the delivery process.

The analysis follows an end-to-end data analytics workflow:

**Data Cleaning → Feature Engineering → Exploratory Analysis → SQL Analysis → Hypothesis Testing → Power BI Dashboard → Business Insights**

### What I did

* Cleaned and validated raw e-commerce data using **Python/Pandas**
* Created calculated fields and categories for analytical purposes
* Used **SQL** to investigate relationships between delivery, freight cost, product price, seller handling, and review scores
* Analyzed extreme delivery delays to identify the primary bottleneck
* Built an interactive **Power BI dashboard** to communicate findings

---

## 🗂️ Dataset

**Source:** Brazilian E-Commerce Public Dataset by Olist

| Dataset     | Records |
| ----------- | ------: |
| Orders      |  99,441 |
| Products    |  32,951 |
| Order Items | 112,650 |
| Reviews     |  99,224 |
| Customers   |  99,441 |

### Tables Used

* `Orders`
* `Products`
* `Order_items`
* `Reviews`
* `Customers`

---

## 🛠️ Tools & Technologies

| Tool                        | Purpose                                         |
| --------------------------- | ----------------------------------------------- |
| **Python / Pandas / NumPy** | Data cleaning, validation & feature engineering |
| **SQL**                     | Data analysis, aggregation & hypothesis testing |
| **Power BI**                | Interactive dashboard & data visualization      |

---

# 🔍 Key Findings

## 1. 🚚 Late Delivery & Customer Satisfaction

Delivery performance showed one of the strongest relationships with customer satisfaction.

| Delivery Status | Average Review Score |
| --------------- | -------------------: |
| On-time         |             **4.29** |
| Late            |             **2.57** |

Late orders had a substantially lower average review score than on-time orders.

**Insight:** Delivery reliability appears to be an important factor associated with customer satisfaction.

---

## 2. 💰 Freight Cost & Customer Satisfaction

Average review scores declined as freight-cost categories increased.

| Freight Cost Category | Average Review Score |
| --------------------- | -------------------: |
| Low                   |             **4.11** |
| Medium                |             **4.04** |
| High                  |             **3.94** |

**Insight:** Higher freight costs were associated with slightly lower customer satisfaction.

---

## 3. 🏷️ Product Price Had Limited Relationship With Satisfaction

Product price showed little variation in average review scores across price categories.

Average review scores remained around **4.03**.

**Conclusion:** The hypothesis that higher product prices are associated with lower customer satisfaction was **not supported** by the analysis.

---

## 4. ⏱️ Seller Handling Time & Satisfaction

Longer seller handling times were associated with lower review scores.

| Seller Handling Category | Average Review Score |
| ------------------------ | -------------------: |
| Shortest                 |             **4.26** |
| Longest                  |             **3.69** |

**Insight:** Faster seller processing was associated with better customer satisfaction.

---

## 5. 🚨 Carrier Shipping Was the Main Bottleneck in Extreme Delays

To investigate the most severe delivery problems, the analysis focused on the **top 1% longest-delivery orders (965 orders)**.

| Delivery Stage   |   Average Time |
| ---------------- | -------------: |
| Seller Handling  |  **8.58 days** |
| Carrier Shipping | **53.31 days** |

Carrier shipping time was substantially higher than seller handling time.

### Carrier vs Seller Contribution

**Carrier shipping:** 86.13%
**Seller handling:** 13.87%

**Insight:** Carrier shipping was the dominant contributor to extreme delivery delays in the analyzed orders.

---

## 6. 🌎 Geographic Differences in Delivery Performance

Delivery performance varied across states.

**RR (Roraima)** recorded the highest average delivery time in the state-level analysis at approximately **29.34 days**.

**Insight:** Geographic differences may indicate areas where logistics performance requires additional investigation.

---

## 7. ⚠️ Data Quality Anomalies

During data cleaning and validation, **13,059 orders** were identified where the carrier delivery date occurred later than the approval date.

Rather than deleting these records, they were **retained and flagged for investigation**.

This prevents potentially useful records from being removed while making the data-quality issue transparent.

---

# 💡 Overall Business Insight

The analysis suggests that **delivery and logistics performance are more strongly associated with customer satisfaction than product price** in the analyzed dataset.

The largest operational concern was not product pricing but **delivery reliability**, particularly carrier shipping performance in extreme-delay orders.

### Priority Areas

1. Improve carrier shipping performance
2. Reduce extreme delivery delays
3. Improve seller processing time
4. Investigate high-delay geographic regions
5. Monitor freight costs and their relationship with customer satisfaction

---

# 📊 Power BI Dashboard

The final Power BI dashboard brings together the key KPIs, delivery performance metrics, customer satisfaction analysis, and operational insights.

![Power BI Dashboard](powerbi/Dashboard.jpg)

---

# 🔬 Analytical Approach

### Step 1 — Data Preparation

Cleaned and validated the raw Olist datasets using Python and Pandas.

### Step 2 — Feature Engineering

Created analytical variables such as:

* Delivery status
* Seller handling time
* Carrier shipping time
* Freight-cost categories
* Product-price categories

### Step 3 — Exploratory Data Analysis

Examined distributions, trends, and relationships between delivery performance and review scores.

### Step 4 — SQL Analysis

Used SQL to perform:

* Aggregations
* Grouping and filtering
* Category-level comparisons
* Delivery analysis
* Hypothesis testing
* Extreme-delay analysis

### Step 5 — Dashboard Development

Built an interactive Power BI dashboard to communicate the most important findings and KPIs.

---

# ⚠️ Limitations

* Review score was used as a **proxy for customer satisfaction** and may not capture all aspects of the customer experience.
* The analysis identifies **associations, not causation**.
* Delivery-related findings may be influenced by other factors not captured in the dataset.
* Geographic findings are based on the available state-level data.
* Data-quality anomalies were flagged rather than removed, which may affect some analyses.

---

# 📁 Project Structure

```text
olist-ecommerce-customer-satisfaction-analysis/
│
├── data/
│   └── ...
│
├── python/
│   └── data_cleaning.ipynb
│
├── sql/
│   └── analysis.sql
│
├── powerbi/
│   └── Dashboard.jpg
│
└── README.md
```

---

# 🎯 Conclusion

This project demonstrates an end-to-end analytics workflow using **Python, SQL, and Power BI** to investigate a real-world business problem.

The analysis indicates that **delivery reliability and logistics performance are key areas associated with customer satisfaction**, while product price showed relatively little relationship with review scores.

The findings can help management prioritize improvements in **carrier performance, seller processing, delivery reliability, and high-delay geographic regions**.

---

### 🔗 Tools

**Python • Pandas • NumPy • SQL • Power BI • Data Analysis • Data Visualization**
