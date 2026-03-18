# Student Management System

A web-based Student Management System built with Core Java OOP principles.

## Tech Stack
- Java JSP/Servlets
- MySQL 8.x
- Apache Tomcat 10
- MVC + DAO Pattern

## OOP Concepts
- Abstraction — BaseEntity, GenericDAO
- Encapsulation — All model classes
- Inheritance — Student, Admin, Subject, Attendance extend BaseEntity
- Polymorphism — getDisplayName() overridden in each model

## Features
- Admin login with session management
- Student CRUD with search
- Subject management
- Attendance tracking with percentage stats

## Default Login
- Username: admin
- Password: admin123

## Setup
1. Import: mysql -u root -p < database/schema.sql
2. Update DB password in src/com/sms/util/DBConnection.java
3. Compile Java files
4. Deploy webapp/ to Tomcat
5. Open http://localhost:8080/SMS/LoginServlet
