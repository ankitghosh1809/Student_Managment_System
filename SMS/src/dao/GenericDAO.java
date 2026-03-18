package com.sms.dao;

import java.util.List;

public interface GenericDAO<T> {
    List<T> getAll();
    T       getById(int id);
    boolean insert(T entity);
    boolean update(T entity);
    boolean delete(int id);
    int     count();
}
