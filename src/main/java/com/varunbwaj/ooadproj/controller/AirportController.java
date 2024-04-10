package com.varunbwaj.ooadproj.controller;

import com.varunbwaj.ooadproj.service.InventoryManager;
import com.varunbwaj.ooadproj.service.LogsManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import com.varunbwaj.ooadproj.service.DatabaseService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import com.varunbwaj.ooadproj.service.AirportManager;
import com.varunbwaj.ooadproj.service.AuthManager;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


@RestController
public class AirportController {
    private final AirportManager airportManager;
    private final InventoryManager inventoryManager;
    private final LogsManager logsManager;
    private final AuthManager authManager;

    @Autowired
    public AirportController(AirportManager airportManager, InventoryManager inventoryManager,
                             LogsManager logsManager, AuthManager authManager) {
        this.airportManager = airportManager;
        this.inventoryManager = inventoryManager;
        this.logsManager = logsManager;
        this.authManager = authManager;
    }

    @GetMapping("/airports")
    public List<Map<String, Object>> getAirports() {
        return airportManager.getAirports();
    }

    @GetMapping("/ghs/hangar")
    public List<Map<String, Object>> getMaintenanceData1() {
        return airportManager.getMaintenanceData1();
    }

    @GetMapping("/ghs/services")
    public List<Map<String, Object>> getGroundHandlingServiceData() {
        return airportManager.getGroundHandlingServiceData();
    }

    @GetMapping("/maintenance")
    public List<Map<String, Object>> getMaintenanceData() {
        return airportManager.getMaintenanceData();
    }

    @GetMapping("/inventory/{query}/{chars}")
    public List<Map<String, Object>> getInventoryData(@PathVariable String query, @PathVariable String chars) {
        return inventoryManager.getInventoryData(query, chars);
    }

    @GetMapping("/inventory/resource")
    public List<Map<String, Object>> getResourceInventory() {
        return inventoryManager.getResourceInventory();
    }

    @GetMapping("/inventory/resource/{resource_id}")
    public Map<String, Object> getResourceData(@PathVariable String resource_id) {
        return inventoryManager.getResourceData(resource_id);
    }
    

    @GetMapping("/stats/airnames")
    public List<Map<String, Object>> getAirlineNames() {
        return airportManager.getAirlineNames();
    }

    @GetMapping("/general/airnames")
    public List<Map<String, Object>> getAirlineNamesGeneral() {
        return airportManager.getAirlineNamesGeneral();
    }

    @GetMapping("/general/graph")
    public List<Map<String, Object>> getUniqueAirplanes() {
        return airportManager.getUniqueAirplanes();
    }

    @GetMapping("/stats/getCount/{query}/{chars}")
    public List<Map<String, Object>> getCount(@PathVariable String query, @PathVariable String chars) {
        return airportManager.getCount(query, chars);
    }

    @GetMapping("/logs/messages/{query}")
    public List<Map<String, Object>> getLogMessages(@PathVariable String query) {
        return logsManager.getLogMessages(query);
    }

    @GetMapping("/logs/emergency/{query}")
    public List<Map<String, Object>> getEmergencyLogs(@PathVariable String query) {
        return logsManager.getEmergencyLogs(query);
    }

    @GetMapping("/logs/notifs/{query}")
    public List<Map<String, Object>> getNotificationLogs(@PathVariable String query) {
        return logsManager.getNotificationLogs(query);
    }

    @GetMapping("/settings/{query}")
    public List<Map<String, Object>> getSettings(@PathVariable String query) {
        return airportManager.getSettings(query);
    }

    @PutMapping("/inventory/restock/{value}/{id}")
    public String restockResource(@PathVariable String value, @PathVariable String id) {
        return inventoryManager.restockResource(value, id);
    }

    @PostMapping("/logs/push/{radios}/{subject}/{body}")
    public String pushLog(@PathVariable String radios, @PathVariable String subject, @PathVariable String body) {
        return logsManager.pushLog(radios, subject, body);
    }

    @GetMapping("/auth")
    public List<Map<String, Object>> getAuthData() {
        return authManager.getAuthData();
    }

    @GetMapping("/auth/level/{username}")
    public List<Map<String, Object>> getAuthLevel(@PathVariable String username) {
        return authManager.getAuthLevel(username);
    }

    @PostMapping("/auth/add_usr")
    public String addUser(@RequestBody Map<String, Object> requestBody) {
        return authManager.addUser(requestBody);
    }

    @GetMapping("/error")
    public ResponseEntity<String> handleError() {
        return new ResponseEntity<>("An error has occurred.", HttpStatus.INTERNAL_SERVER_ERROR);
    }
}