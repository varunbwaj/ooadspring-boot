package com.varunbwaj.ooadproj.service;

import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;

@Service
public class InventoryManager {
    private final DatabaseService databaseService;

    public InventoryManager(DatabaseService databaseService) {
        this.databaseService = databaseService;
    }

    public List<Map<String, Object>> getInventoryData(String query, String chars) {
        String finalQuery = query.replace("%s", chars);
        return databaseService.queryForList(finalQuery);
    }

    public Map<String, Object> getResourceData(String resourceId) {
        String sqlQuery = "SELECT `ResourceID`, `ResourceName`, `MinimumQuantity`, `Quantity`, `MaximumQuantity`, `NextScheduledMaintenance`, `LastUpdated` FROM ResourceInventory WHERE `ResourceID` = ?";
        Map<String, Object> resourceData = databaseService.queryForMap(sqlQuery, resourceId);

        // Update the maximum quantity based on the current quantity and the restock limit
        int currentQuantity = (int) resourceData.get("Quantity");
        int maxQuantity = (int) resourceData.get("MaximumQuantity");
        resourceData.put("MaximumQuantity", Math.max(currentQuantity, maxQuantity));

        return resourceData;
    }

    public String restockResource(String value, String id) {
        // Fetch the current resource data
        Map<String, Object> resourceData = getResourceData(id);
        int currentQuantity = (int) resourceData.get("Quantity");
        int maxQuantity = (int) resourceData.get("MaximumQuantity");

        // Check if the restock quantity is within the allowed range
        int restockQuantity = Integer.parseInt(value);
        if (restockQuantity + currentQuantity > maxQuantity) {
            return "Restock quantity exceeds the maximum allowed";
        }

        // Update the resource quantity
        String sqlQuery = "UPDATE ResourceInventory SET Quantity = ? WHERE ResourceID = ?";
        databaseService.update(sqlQuery, currentQuantity + restockQuantity, id);
        return "Resource updated successfully";
    }

    public List<Map<String, Object>> getResourceInventory() {
        return databaseService.queryForList("SELECT `ResourceID`, `ResourceName` FROM ResourceInventory");
    }
}