# Student Management System

A full-stack web-based Student Management System built with **Core Java OOP** principles.

---

## Features

### Admin Portal
- Secure admin login with session management
- Dashboard with real-time statistics
- Student management — Add, Edit, Delete, Search
- Subject management — Add, Edit, Delete
- Attendance tracking — Mark Present / Absent / Late
- Marks & Grades management — Add/update marks, auto grade calculation
- View attendance percentage per student
- View overall grade summary for all students

### Student Portal
- Student login with Roll Number and Password
- View personal profile and details
- View attendance records and percentage
- View marks and grades per subject
- View enrolled subjects
- Overall grade calculation

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend | Java, JSP, Servlets |
| Frontend | HTML5, CSS3, JavaScript |
| Database | MySQL 8.x / 9.x |
| Server | Apache Tomcat 10 |
| Architecture | MVC Pattern |
| Design Pattern | DAO Pattern, Generic Interface |

---

## OOP Concepts Used

| Concept | Where Applied |
|---------|--------------|
| **Abstraction** | `BaseEntity` (abstract class), `GenericDAO` (interface) |
| **Encapsulation** | All model classes with private fields and getters/setters |
| **Inheritance** | `Student`, `Admin`, `Subject`, `Attendance` extend `BaseEntity` |
| **Polymorphism** | `getDisplayName()` overridden differently in each model class |
| **Generics** | `GenericDAO<T>` — type-safe DAO interface |

---

## Project Structure
```
SMS/
├── src/
│   ├── model/
│   │   ├── BaseEntity.java       ← Abstract parent (Abstraction)
│   │   ├── Student.java          ← Extends BaseEntity
│   │   ├── Admin.java            ← Extends BaseEntity
│   │   ├── Subject.java          ← Extends BaseEntity
│   │   └── Attendance.java       ← Extends BaseEntity
│   ├── dao/
│   │   ├── GenericDAO.java       ← Interface (Abstraction)
│   │   ├── StudentDAO.java       ← Implements GenericDAO
│   │   ├── AdminDAO.java         ← Implements GenericDAO
│   │   ├── SubjectDAO.java       ← Implements GenericDAO
│   │   ├── AttendanceDAO.java    ← Implements GenericDAO
│   │   └── MarksDAO.java         ← Marks & grades operations
│   ├── servlet/
│   │   ├── LoginServlet.java         ← Admin login
│   │   ├── LogoutServlet.java        ← Admin logout
│   │   ├── DashboardServlet.java     ← Admin dashboard
│   │   ├── StudentServlet.java       ← Student CRUD
│   │   ├── SubjectServlet.java       ← Subject CRUD
│   │   ├── AttendanceServlet.java    ← Attendance management
│   │   ├── MarksServlet.java         ← Marks & grades management
│   │   ├── StudentLoginServlet.java  ← Student login
│   │   ├── StudentDashboardServlet.java ← Student portal
│   │   └── StudentLogoutServlet.java ← Student logout
│   └── util/
│       └── DBConnection.java     ← DB connection utility
├── webapp/
│   ├── css/style.css             ← Responsive stylesheet
│   ├── js/app.js                 ← Client-side JavaScript
│   ├── login.jsp                 ← Admin login page
│   ├── navbar.jsp                ← Shared sidebar
│   ├── dashboard.jsp             ← Admin dashboard
│   ├── students.jsp              ← Student list
│   ├── add-student.jsp           ← Add student form
│   ├── edit-student.jsp          ← Edit student form
│   ├── subjects.jsp              ← Subject management
│   ├── attendance.jsp            ← Attendance tracking
│   ├── marks.jsp                 ← Marks & grades (admin)
│   ├── student-login.jsp         ← Student login page
│   └── student-dashboard.jsp     ← Student portal
└── database/
    └── schema.sql                ← MySQL schema + sample data
```

---

## Database Tables

| Table | Description |
|-------|-------------|
| `admin` | Admin login credentials |
| `student` | Student records with roll number and password |
| `subject` | Course subjects with credits |
| `attendance` | Attendance records (Present/Absent/Late) |
| `marks` | Student marks per subject with auto-calculated grades |

---

## Grade Scale

| Grade | Percentage |
|-------|-----------|
| A+ | 90% and above |
| A | 80 – 89% |
| B | 70 – 79% |
| C | 60 – 69% |
| D | 50 – 59% |
| F | Below 50% |

---

## Setup Instructions

### Requirements
- Java JDK 11 or higher
- MySQL 8.x or 9.x
- Apache Tomcat 10

### 1. Import Database
```bash
mysql -u root -p < database/schema.sql
```

### 2. Update DB Password
Open `src/util/DBConnection.java` and change:
```java
private static final String PASS = "your_mysql_password";
```

### 3. Download JARs
Place in `webapp/WEB-INF/lib/`:
- `mysql-connector-j-8.0.33.jar`
- `jakarta.servlet-api-6.0.0.jar`

### 4. Compile
```bash
JARS="webapp/WEB-INF/lib/jakarta.servlet-api-6.0.0.jar:webapp/WEB-INF/lib/mysql-connector-j-8.0.33.jar"

javac -cp "$JARS" -d webapp/WEB-INF/classes \
  src/util/DBConnection.java \
  src/model/BaseEntity.java \
  src/model/Admin.java \
  src/model/Student.java \
  src/model/Subject.java \
  src/model/Attendance.java \
  src/dao/GenericDAO.java \
  src/dao/AdminDAO.java \
  src/dao/StudentDAO.java \
  src/dao/SubjectDAO.java \
  src/dao/AttendanceDAO.java \
  src/dao/MarksDAO.java \
  src/servlet/LoginServlet.java \
  src/servlet/LogoutServlet.java \
  src/servlet/DashboardServlet.java \
  src/servlet/StudentServlet.java \
  src/servlet/SubjectServlet.java \
  src/servlet/AttendanceServlet.java \
  src/servlet/MarksServlet.java \
  src/servlet/StudentLoginServlet.java \
  src/servlet/StudentDashboardServlet.java \
  src/servlet/StudentLogoutServlet.java
```

### 5. Deploy to Tomcat
```bash
cp -r webapp /path/to/tomcat/webapps/SMS
/path/to/tomcat/bin/startup.sh
```

### 6. Open in Browser
```
http://localhost:8080/SMS/LoginServlet
```

---

## Login Credentials

### Admin
| Field | Value |
|-------|-------|
| URL | http://localhost:8080/SMS/LoginServlet |
| Username | admin |
| Password | admin123 |

### Students
| Field | Value |
|-------|-------|
| URL | http://localhost:8080/SMS/StudentLoginServlet |
| Roll Number | CS001 to CS010 |
| Password | student123 |

---

## Sample Data Included

- 10 students with roll numbers CS001–CS010
- 6 subjects (Data Structures, DBMS, Web Tech, OS, Networks, Software Engg)
- Attendance records for last 5 days
- Marks for all students across all subjects with auto-calculated grades

---

## License

MIT License — free to use for educational purposes.
