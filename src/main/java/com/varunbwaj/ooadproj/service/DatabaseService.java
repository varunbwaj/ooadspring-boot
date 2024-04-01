package com.varunbwaj.ooadproj.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class DatabaseService {
    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public DatabaseService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Map<String, Object>> queryForList(String query) {
        return jdbcTemplate.queryForList(query);
    }

    public List<Map<String, Object>> queryForList(String query, Object... args) {
        return jdbcTemplate.queryForList(query, args);
    }

    public void update(String query, Object... args) {
        jdbcTemplate.update(query, args);
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
