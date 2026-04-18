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
| Security | BCrypt password hashing (jBCrypt 0.4) |

---

## OOP Concepts Used

| Concept | Where Applied |
|---------|--------------|
| Abstraction | `BaseEntity` (abstract class), `GenericDAO` (interface) |
| Encapsulation | All model classes with private fields and getters/setters |
| Inheritance | `Student`, `Admin`, `Subject`, `Attendance` extend `BaseEntity` |
| Polymorphism | `getDisplayName()` overridden differently in each model class |
| Generics | `GenericDAO<T>` — type-safe DAO interface |

---

## Project Structure

```
SMS/
├── src/
│   ├── model/
│   │   ├── BaseEntity.java
│   │   ├── Student.java
│   │   ├── Admin.java
│   │   ├── Subject.java
│   │   └── Attendance.java
│   ├── dao/
│   │   ├── GenericDAO.java
│   │   ├── StudentDAO.java
│   │   ├── AdminDAO.java
│   │   ├── SubjectDAO.java
│   │   ├── AttendanceDAO.java
│   │   └── MarksDAO.java
│   ├── servlet/
│   │   ├── LoginServlet.java
│   │   ├── LogoutServlet.java
│   │   ├── DashboardServlet.java
│   │   ├── StudentServlet.java
│   │   ├── SubjectServlet.java
│   │   ├── AttendanceServlet.java
│   │   ├── MarksServlet.java
│   │   ├── StudentLoginServlet.java
│   │   ├── StudentDashboardServlet.java
│   │   └── StudentLogoutServlet.java
│   └── util/
│       └── DBConnection.java
├── webapp/
│   ├── css/style.css
│   ├── js/app.js
│   ├── login.jsp
│   ├── navbar.jsp
│   ├── dashboard.jsp
│   ├── students.jsp
│   ├── add-student.jsp
│   ├── edit-student.jsp
│   ├── subjects.jsp
│   ├── attendance.jsp
│   ├── marks.jsp
│   ├── student-login.jsp
│   └── student-dashboard.jsp
└── database/
    └── schema.sql
```

---

## Database Tables

| Table | Description |
|-------|-------------|
| `admin` | Admin credentials (BCrypt hashed password) |
| `student` | Student records with roll number and BCrypt hashed password |
| `subject` | Course subjects with credits |
| `attendance` | Attendance records (Present / Absent / Late) |
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

### 1. Clone the Repository

```bash
git clone https://github.com/ankitghosh1809/Student_Managment_System.git
cd Student_Managment_System
```

### 2. Import Database

```bash
mysql -u root -p < SMS/database/schema.sql
```

### 3. Create DB Config File

Create a file at `~/sms-config/db.properties` outside the project folder:

```properties
db.url=jdbc:mysql://localhost:3306/sms_db?useSSL=false&serverTimezone=UTC
db.user=root
db.password=YOUR_MYSQL_PASSWORD
```

```bash
chmod 600 ~/sms-config/db.properties
```

### 4. Download JARs

Place the following in `SMS/webapp/WEB-INF/lib/`:
- `mysql-connector-j-8.0.33.jar`
- `jakarta.servlet-api-6.0.0.jar`
- `jbcrypt-0.4.jar`

Download BCrypt directly:

```bash
curl -L https://repo1.maven.org/maven2/org/mindrot/jbcrypt/0.4/jbcrypt-0.4.jar \
  -o SMS/webapp/WEB-INF/lib/jbcrypt-0.4.jar
```

### 5. Compile

```bash
cd SMS
JARS="webapp/WEB-INF/lib/jakarta.servlet-api-6.0.0.jar:webapp/WEB-INF/lib/mysql-connector-j-8.0.33.jar:webapp/WEB-INF/lib/jbcrypt-0.4.jar"

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

### 6. Deploy to Tomcat

```bash
cp -r webapp /path/to/tomcat/webapps/SMS
/path/to/tomcat/bin/startup.sh
```

### 7. Open in Browser

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
| Roll Number | CS001 to CS005 |
| Password | student123 |

---

## Sample Data

- 5 students with roll numbers CS001–CS005
- 5 subjects (Data Structures, DBMS, Web Technologies, Operating Systems, Computer Networks)
- Sample attendance records
- All passwords are BCrypt hashed in the database

---

## Security

- Passwords hashed with BCrypt (cost factor 12) — never stored as plain text
- DB credentials loaded from an external config file outside the project directory
- All SQL queries use PreparedStatements — no SQL injection risk
- Session-based authentication with 30-minute timeout
- Sessions invalidated on logout

---

## License

MIT License — free to use for educational purposes.
