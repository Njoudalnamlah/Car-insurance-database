# 🚗 Car Insurance Management System

A full-featured **MySQL database project** for managing car insurance data.  
This system simulates how insurance companies handle vehicles, customers, policies, and accident records.  
It includes logic for ensuring data accuracy using SQL triggers, procedures, and functions.

## 📌 Features

- Manage **Customers**, **Employees**, **Cars**, **Insurances**, and **Accidents**
- Built-in **data validation** using triggers and stored procedures
- Check if a car is insured before assigning an accident
- Prevent inserting expired insurance policies
- Prevent setting car manufacturing year beyond 2022
- Calculate total number of accidents for a specific vehicle
- Optimized using **indexes** for fast querying

## 🧰 Tools & Technologies
- **SQL**
- **MySQL Workbench**

## 📂 Database Structure

- `Customer`: Stores personal info and license numbers  
- `Employee`: Stores employee roles and departments  
- `Car`: Registered cars linked to customers  
- `Insurance`: Policies issued by employees for cars  
- `Accident`: Records of accidents with location and description  
- `Car_Accident`: Relationship between cars and accidents  

