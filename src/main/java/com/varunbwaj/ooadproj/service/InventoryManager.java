package com.varunbwaj.ooadproj.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class InventoryManager {
    private final DatabaseService databaseService;

    @Autowired
    public InventoryManager(DatabaseService databaseService) {
        this.databaseService = databaseService;
    }

    public List<Map<String, Object>> getInventoryData(String query, String chars) {
        String finalQuery = query.replace("%s", chars);
        return databaseService.queryForList(finalQuery);
    }

    public List<Map<String, Object>> getResourceInventory() {
        return databaseService.queryForList("SELECT `ResourceID`, `ResourceName` FROM ResourceInventory");
    }

    public String restockResource(String value, String id) {
        String sqlQuery = "UPDATE ResourceInventory SET Quantity = ? WHERE ResourceID = ?";
        databaseService.update(sqlQuery, value, id);
        return "Resource updated successfully";
    }
}
