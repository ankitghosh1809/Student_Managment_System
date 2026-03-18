package com.sms.model;

public abstract class BaseEntity {
    private int id;

    public BaseEntity() {}
    public BaseEntity(int id) { this.id = id; }

    public int getId()         { return id; }
    public void setId(int id)  { this.id = id; }

    public abstract String getDisplayName();

    @Override
    public String toString() {
        return getClass().getSimpleName() + "{id=" + id + ", display='" + getDisplayName() + "'}";
    }
}
