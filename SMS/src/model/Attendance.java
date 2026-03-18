package com.sms.model;

import java.sql.Date;

public class Attendance extends BaseEntity {
    private int    studentId;
    private int    subjectId;
    private Date   date;
    private String status;
    private String studentName;
    private String subjectName;
    private String subjectCode;

    public Attendance() { super(); }
    public Attendance(int studentId, int subjectId, Date date, String status) {
        super(); this.studentId = studentId; this.subjectId = subjectId;
        this.date = date; this.status = status;
    }

    @Override
    public String getDisplayName() {
        return studentName + " -> " + subjectCode + " on " + date + " [" + status + "]";
    }

    public int    getStudentId()           { return studentId; }
    public void   setStudentId(int v)      { this.studentId = v; }
    public int    getSubjectId()           { return subjectId; }
    public void   setSubjectId(int v)      { this.subjectId = v; }
    public Date   getDate()                { return date; }
    public void   setDate(Date d)          { this.date = d; }
    public String getStatus()              { return status; }
    public void   setStatus(String s)      { this.status = s; }
    public String getStudentName()         { return studentName; }
    public void   setStudentName(String n) { this.studentName = n; }
    public String getSubjectName()         { return subjectName; }
    public void   setSubjectName(String n) { this.subjectName = n; }
    public String getSubjectCode()         { return subjectCode; }
    public void   setSubjectCode(String c) { this.subjectCode = c; }
}
