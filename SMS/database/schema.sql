CREATE DATABASE IF NOT EXISTS sms_db;
USE sms_db;

CREATE TABLE IF NOT EXISTS admin (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50)  NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    fullName VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS student (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    email          VARCHAR(100) NOT NULL UNIQUE,
    course         VARCHAR(100) NOT NULL,
    phone          VARCHAR(20),
    address        TEXT,
    enrollmentDate DATE DEFAULT (CURRENT_DATE),
    rollNumber     VARCHAR(20)  UNIQUE,
    password       VARCHAR(255) NOT NULL DEFAULT '$2a$12$9byuGy2p3dSJIfJ2sfu4MeGJ5lNJ5kPoDEewbNDoTap/KnaGUMP46'
);

CREATE TABLE IF NOT EXISTS subject (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    code        VARCHAR(20)  NOT NULL UNIQUE,
    credits     INT          NOT NULL DEFAULT 3,
    description TEXT
);

CREATE TABLE IF NOT EXISTS attendance (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    studentId INT  NOT NULL,
    subjectId INT  NOT NULL,
    date      DATE NOT NULL,
    status    ENUM('Present','Absent','Late') NOT NULL DEFAULT 'Present',
    FOREIGN KEY (studentId) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (subjectId) REFERENCES subject(id) ON DELETE CASCADE,
    UNIQUE KEY uq_att (studentId, subjectId, date)
);

INSERT INTO admin (username, password, fullName) VALUES ('admin','$2a$12$M2WhSdMMT3V4eaMkJtuOtOyo.e3Daml6USVNTPbQb6N8YEwRiEelu','System Administrator');

INSERT INTO student (name, email, course, phone, address, rollNumber, password) VALUES
('Arjun Sharma',  'arjun@example.com',  'B.Tech Computer Science',       '9876543210', 'Mumbai',    'CS001', '$2a$12$9byuGy2p3dSJIfJ2sfu4MeGJ5lNJ5kPoDEewbNDoTap/KnaGUMP46'),
('Priya Patel',   'priya@example.com',  'B.Tech Information Technology', '9876543211', 'Pune',      'CS002', '$2a$12$9byuGy2p3dSJIfJ2sfu4MeGJ5lNJ5kPoDEewbNDoTap/KnaGUMP46'),
('Rohan Mehta',   'rohan@example.com',  'BCA',                           '9876543212', 'Delhi',     'CS003', '$2a$12$9byuGy2p3dSJIfJ2sfu4MeGJ5lNJ5kPoDEewbNDoTap/KnaGUMP46'),
('Sneha Gupta',   'sneha@example.com',  'MCA',                           '9876543213', 'Bangalore', 'CS004', '$2a$12$9byuGy2p3dSJIfJ2sfu4MeGJ5lNJ5kPoDEewbNDoTap/KnaGUMP46'),
('Vikram Singh',  'vikram@example.com', 'B.Tech Electronics',            '9876543214', 'Ahmedabad', 'CS005', '$2a$12$9byuGy2p3dSJIfJ2sfu4MeGJ5lNJ5kPoDEewbNDoTap/KnaGUMP46');

INSERT INTO subject (name, code, credits, description) VALUES
('Data Structures & Algorithms', 'CS101', 4, 'Core data structures'),
('Database Management Systems',  'CS102', 3, 'SQL and relational DBs'),
('Web Technologies',             'CS103', 3, 'HTML, CSS, JS, Servlets'),
('Operating Systems',            'CS104', 4, 'Process and memory mgmt'),
('Computer Networks',            'CS105', 3, 'TCP/IP and protocols');

INSERT INTO attendance (studentId, subjectId, date, status) VALUES
(1,1,CURDATE(),'Present'),(1,2,CURDATE(),'Present'),
(2,1,CURDATE(),'Absent'), (2,3,CURDATE(),'Present'),
(3,1,CURDATE(),'Late'),   (3,2,CURDATE(),'Present'),
(4,2,CURDATE(),'Present'),(5,1,CURDATE(),'Present');