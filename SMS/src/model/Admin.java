package com.sms.model;
public class Admin extends BaseEntity {
    private String username;
    private String password;
    private String fullName;
    public Admin() { super(); }
    public Admin(int id, String username, String fullName) {
        super(id); this.username = username; this.fullName = fullName;
    }
    @Override
    public String getDisplayName() { return fullName + " (@" + username + ")"; }
    public String getUsername() { return username; }
    public void setUsername(String u) { this.username = u; }
    public String getPassword() { return password; }
    public void setPassword(String p) { this.password = p; }
    public String getFullName() { return fullName; }
    public void setFullName(String f) { this.fullName = f; }
}
