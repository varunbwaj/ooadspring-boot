package com.varunbwaj.ooadproj.facade;

import com.varunbwaj.ooadproj.service.AirportManager;
import com.varunbwaj.ooadproj.service.AuthManager;
import com.varunbwaj.ooadproj.service.InventoryManager;
import com.varunbwaj.ooadproj.service.LogsManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public class AirportFacade {
    private final AirportManager airportManager;
    private final AuthManager authManager;
    private final InventoryManager inventoryManager;
    private final LogsManager logsManager;

    @Autowired
    public AirportFacade(AirportManager airportManager, AuthManager authManager, InventoryManager inventoryManager, LogsManager logsManager) {
        this.airportManager = airportManager;
        this.authManager = authManager;
        this.inventoryManager = inventoryManager;
        this.logsManager = logsManager;
    }

    public List<Map<String, Object>> getAirports() {
        return airportManager.getAirports();
    }

    public List<Map<String, Object>> getMaintenanceData1() {
        return airportManager.getMaintenanceData1();
    }

    public List<Map<String, Object>> getGroundHandlingServiceData() {
        return airportManager.getGroundHandlingServiceData();
    }

    public List<Map<String, Object>> getMaintenanceData() {
        return airportManager.getMaintenanceData();
    }

    public List<Map<String, Object>> getAirlineNames() {
        return airportManager.getAirlineNames();
    }

    public List<Map<String, Object>> getAirlineNamesGeneral() {
        return airportManager.getAirlineNamesGeneral();
    }

    public List<Map<String, Object>> getUniqueAirplanes() {
        return airportManager.getUniqueAirplanes();
    }

    public List<Map<String, Object>> getCount(String query, String chars) {
        return airportManager.getCount(query, chars);
    }

    public List<Map<String, Object>> getSettings(String query) {
        return airportManager.getSettings(query);
    }

    public List<Map<String, Object>> getAuthData() {
        return authManager.getAuthData();
    }

    public List<Map<String, Object>> getAuthLevel(String username) {
        return authManager.getAuthLevel(username);
    }

    public String addUser(Map<String, Object> requestBody) {
        return authManager.addUser(requestBody);
    }

    public List<Map<String, Object>> getInventoryData(String query, String chars) {
        return inventoryManager.getInventoryData(query, chars);
    }

    public Map<String, Object> getResourceData(String resourceId) {
        return inventoryManager.getResourceData(resourceId);
    }

    public String restockResource(String value, String id) {
        return inventoryManager.restockResource(value, id);
    }

    public List<Map<String, Object>> getResourceInventory() {
        return inventoryManager.getResourceInventory();
    }

    public List<Map<String, Object>> getLogMessages(String query) {
        return logsManager.getLogMessages(query);
    }

    public List<Map<String, Object>> getEmergencyLogs(String query) {
        return logsManager.getEmergencyLogs(query);
    }

    public List<Map<String, Object>> getNotificationLogs(String query) {
        return logsManager.getNotificationLogs(query);
    }

    public String pushLog(String radios, String subject, String body) {
        return logsManager.pushLog(radios, subject, body);
    }
}