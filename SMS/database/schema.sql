-- PostgreSQL schema for Student Management System
-- Compatible with Neon (neon.tech)

CREATE TABLE IF NOT EXISTS admin (
    id       SERIAL PRIMARY KEY,
    username VARCHAR(50)  NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    fullName VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS student (
    id             SERIAL PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    email          VARCHAR(100) NOT NULL UNIQUE,
    course         VARCHAR(100) NOT NULL,
    phone          VARCHAR(20),
    address        TEXT,
    enrollmentDate DATE DEFAULT CURRENT_DATE,
    rollNumber     VARCHAR(20) UNIQUE,
    password       VARCHAR(255) NOT NULL DEFAULT '$2a$12$9byuGy2p3dSJIfJ2sfu4MeGJ5lNJ5kPoDEewbNDoTap/KnaGUMP46'
);

CREATE TABLE IF NOT EXISTS subject (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    code        VARCHAR(20)  NOT NULL UNIQUE,
    credits     INT          NOT NULL DEFAULT 3,
    description TEXT
);

CREATE TABLE IF NOT EXISTS attendance (
    id        SERIAL PRIMARY KEY,
    studentId INT  NOT NULL,
    subjectId INT  NOT NULL,
    date      DATE NOT NULL,
    status    VARCHAR(10) NOT NULL DEFAULT 'Present'
                CHECK (status IN ('Present', 'Absent', 'Late')),
    FOREIGN KEY (studentId) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (subjectId) REFERENCES subject(id) ON DELETE CASCADE,
    CONSTRAINT uq_att UNIQUE (studentId, subjectId, date)
);

CREATE TABLE IF NOT EXISTS marks (
    id        SERIAL PRIMARY KEY,
    studentId INT          NOT NULL,
    subjectId INT          NOT NULL,
    marks     INT          NOT NULL DEFAULT 0,
    maxMarks  INT          NOT NULL DEFAULT 100,
    examType  VARCHAR(50)  NOT NULL DEFAULT 'Internal',
    grade     VARCHAR(5)   NOT NULL DEFAULT 'F',
    FOREIGN KEY (studentId) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (subjectId) REFERENCES subject(id) ON DELETE CASCADE,
    CONSTRAINT uq_marks UNIQUE (studentId, subjectId, examType)
);

-- Seed data
INSERT INTO admin (username, password, fullName)
VALUES ('admin','$2a$12$M2WhSdMMT3V4eaMkJtuOtOyo.e3Daml6USVNTPbQb6N8YEwRiEelu','System Administrator')
ON CONFLICT (username) DO NOTHING;

INSERT INTO student (name, email, course, phone, address, rollNumber, password) VALUES
('Arjun Sharma',  'arjun@example.com',  'B.Tech Computer Science',       '9876543210', 'Mumbai',    'CS001', '$2a$12$9byuGy2p3dSJIfJ2sfu4MeGJ5lNJ5kPoDEewbNDoTap/KnaGUMP46'),
('Priya Patel',   'priya@example.com',  'B.Tech Information Technology', '9876543211', 'Pune',      'CS002', '$2a$12$9byuGy2p3dSJIfJ2sfu4MeGJ5lNJ5kPoDEewbNDoTap/KnaGUMP46'),
('Rohan Mehta',   'rohan@example.com',  'BCA',                           '9876543212', 'Delhi',     'CS003', '$2a$12$9byuGy2p3dSJIfJ2sfu4MeGJ5lNJ5kPoDEewbNDoTap/KnaGUMP46'),
('Sneha Gupta',   'sneha@example.com',  'MCA',                           '9876543213', 'Bangalore', 'CS004', '$2a$12$9byuGy2p3dSJIfJ2sfu4MeGJ5lNJ5kPoDEewbNDoTap/KnaGUMP46'),
('Vikram Singh',  'vikram@example.com', 'B.Tech Electronics',            '9876543214', 'Ahmedabad', 'CS005', '$2a$12$9byuGy2p3dSJIfJ2sfu4MeGJ5lNJ5kPoDEewbNDoTap/KnaGUMP46')
ON CONFLICT (email) DO NOTHING;

INSERT INTO subject (name, code, credits, description) VALUES
('Data Structures & Algorithms', 'CS101', 4, 'Core data structures'),
('Database Management Systems',  'CS102', 3, 'SQL and relational DBs'),
('Web Technologies',             'CS103', 3, 'HTML, CSS, JS, Servlets'),
('Operating Systems',            'CS104', 4, 'Process and memory mgmt'),
('Computer Networks',            'CS105', 3, 'TCP/IP and protocols')
ON CONFLICT (code) DO NOTHING;

INSERT INTO attendance (studentId, subjectId, date, status) VALUES
(1,1,CURRENT_DATE,'Present'),(1,2,CURRENT_DATE,'Present'),
(2,1,CURRENT_DATE,'Absent'), (2,3,CURRENT_DATE,'Present'),
(3,1,CURRENT_DATE,'Late'),   (3,2,CURRENT_DATE,'Present'),
(4,2,CURRENT_DATE,'Present'),(5,1,CURRENT_DATE,'Present')
ON CONFLICT ON CONSTRAINT uq_att DO NOTHING;
