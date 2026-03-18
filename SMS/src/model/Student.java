package com.sms.model;

import java.sql.Date;

public class Student extends BaseEntity {
    private String name;
    private String email;
    private String course;
    private String phone;
    private String address;
    private Date   enrollmentDate;

    public Student() { super(); }
    public Student(int id, String name, String email, String course, String phone, String address) {
        super(id);
        this.name = name; this.email = email; this.course = course;
        this.phone = phone; this.address = address;
    }

    @Override
    public String getDisplayName() { return name + " (" + course + ")"; }

    public String getName()    { return name; }
    public void setName(String n)    { this.name = n; }
    public String getEmail()   { return email; }
    public void setEmail(String e)   { this.email = e; }
    public String getCourse()  { return course; }
    public void setCourse(String c)  { this.course = c; }
    public String getPhone()   { return phone; }
    public void setPhone(String p)   { this.phone = p; }
    public String getAddress() { return address; }
    public void setAddress(String a) { this.address = a; }
    public Date getEnrollmentDate()        { return enrollmentDate; }
    public void setEnrollmentDate(Date d)  { this.enrollmentDate = d; }
}
