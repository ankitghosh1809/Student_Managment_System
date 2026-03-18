package com.sms.model;

public class Subject extends BaseEntity {
    private String name;
    private String code;
    private int    credits;
    private String description;

    public Subject() { super(); }
    public Subject(int id, String name, String code, int credits, String description) {
        super(id); this.name = name; this.code = code;
        this.credits = credits; this.description = description;
    }

    @Override
    public String getDisplayName() { return name + " [" + code + "]"; }

    public String getName()              { return name; }
    public void setName(String n)        { this.name = n; }
    public String getCode()              { return code; }
    public void setCode(String c)        { this.code = c; }
    public int getCredits()              { return credits; }
    public void setCredits(int c)        { this.credits = c; }
    public String getDescription()       { return description; }
    public void setDescription(String d) { this.description = d; }
}
