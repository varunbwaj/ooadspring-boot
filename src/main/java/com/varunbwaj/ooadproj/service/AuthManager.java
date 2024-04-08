package com.varunbwaj.ooadproj.service;

//public class AuthManager {
//}

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class AuthManager {
    private final DatabaseService databaseService;

    @Autowired
    public AuthManager(DatabaseService databaseService) {
        this.databaseService = databaseService;
    }

    public List<Map<String, Object>> getAuthData() {
        return databaseService.queryForList("SELECT username, hashed_pass as password, CONCAT(f_name, ' ', l_name) as names FROM usr_info");
    }

    public List<Map<String, Object>> getAuthLevel(String username) {
        String sqlQuery = "SELECT auth_level FROM usr_info WHERE username = ?";
        return databaseService.queryForList(sqlQuery, username);
    }

    public String addUser(Map<String, Object> requestBody) {
        String sqlQuery = "INSERT INTO usr_info (f_name, minit, l_name, username, hashed_pass, auth_level) VALUES (?, ?, ?, ?, ?, ?)";
        String sqlQuery1 = "INSERT INTO usr_info1 (f_name, minit, l_name, username, hashed_pass, auth_level) VALUES (?, ?, ?, ?, ?, ?)";

        List<Object> values = List.of(
                requestBody.get("fname"),
                requestBody.get("minit"),
                requestBody.get("lname"),
                requestBody.get("username"),
                requestBody.get("hpass"),
                requestBody.get("authlvl")
        );

        List<Object> values1 = List.of(
                requestBody.get("fname"),
                requestBody.get("minit"),
                requestBody.get("lname"),
                requestBody.get("username"),
                requestBody.get("pass"),
                requestBody.get("authlvl")
        );

        // Perform database operations within a transaction
        databaseService.update("START TRANSACTION");
        databaseService.update(sqlQuery, values.toArray());
        databaseService.update(sqlQuery1, values1.toArray());
        databaseService.update("COMMIT");

        return "User added successfully";
    }
}