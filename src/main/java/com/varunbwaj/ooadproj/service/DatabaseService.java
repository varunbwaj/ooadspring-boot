//package com.varunbwaj.ooadproj.service;
////
////public class DatabaseService {
////}
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.jdbc.core.JdbcTemplate;
//import org.springframework.jdbc.core.RowMapper;
//import org.springframework.stereotype.Service;
//
//import java.util.List;
//import java.util.Map;
//
//@Service
//public class DatabaseService {
//    private static final DatabaseService instance = new DatabaseService();
//
//    @Autowired
//    private JdbcTemplate jdbcTemplate;
//
//    private DatabaseService() {}
//
//    public static DatabaseService getInstance() {
//        return instance;
//    }
//
//    public List<Map<String, Object>> queryForList(String query) {
//        return jdbcTemplate.queryForList(query);
//    }
//
//    public void update(String query, Object... args) {
//        jdbcTemplate.update(query, args);
//    }
//
//    public int executeUpdate(String query, Object... args) {
//        return jdbcTemplate.update(query, args);
//    }
//
//    public List<Map<String, Object>> queryForList(String query, Object... args) {
//        return jdbcTemplate.queryForList(query, args);
//    }
//
//    public Map<String, Object> queryForMap(String query, Object... args) {
//        return jdbcTemplate.queryForMap(query, args);
//    }
//
//    public <T> List<T> query(String query, RowMapper<T> rowMapper, Object... args) {
//        return jdbcTemplate.query(query, rowMapper, args);
//    }
//
//    public <T> T queryForObject(String query, RowMapper<T> rowMapper, Object... args) {
//        return jdbcTemplate.queryForObject(query, rowMapper, args);
//    }
//}
package com.varunbwaj.ooadproj.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class DatabaseService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Map<String, Object>> queryForList(String query) {
        return jdbcTemplate.queryForList(query);
    }

    public void update(String query, Object... args) {
        jdbcTemplate.update(query, args);
    }

    public int executeUpdate(String query, Object... args) {
        return jdbcTemplate.update(query, args);
    }

    public List<Map<String, Object>> queryForList(String query, Object... args) {
        return jdbcTemplate.queryForList(query, args);
    }

    public Map<String, Object> queryForMap(String query, Object... args) {
        return jdbcTemplate.queryForMap(query, args);
    }

    public <T> List<T> query(String query, RowMapper<T> rowMapper, Object... args) {
        return jdbcTemplate.query(query, rowMapper, args);
    }

    public <T> T queryForObject(String query, RowMapper<T> rowMapper, Object... args) {
        return jdbcTemplate.queryForObject(query, rowMapper, args);
    }
}