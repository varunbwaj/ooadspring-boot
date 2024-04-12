package com.varunbwaj.ooadproj.controller;

import com.varunbwaj.ooadproj.facade.AirportFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


@RestController
public class AirportController {
    private final AirportFacade airportFacade;

    @Autowired
    public AirportController(AirportFacade airportFacade) {
        this.airportFacade = airportFacade;
    }

    @GetMapping("/airports")
    public List<Map<String, Object>> getAirports() {
        return airportFacade.getAirports();
    }

    @GetMapping("/ghs/hangar")
    public List<Map<String, Object>> getMaintenanceData1() {
        return airportFacade.getMaintenanceData1();
    }

    @GetMapping("/ghs/services")
    public List<Map<String, Object>> getGroundHandlingServiceData() {
        return airportFacade.getGroundHandlingServiceData();
    }

    @GetMapping("/maintenance")
    public List<Map<String, Object>> getMaintenanceData() {
        return airportFacade.getMaintenanceData();
    }

    @GetMapping("/inventory/{query}/{chars}")
    public List<Map<String, Object>> getInventoryData(@PathVariable String query, @PathVariable String chars) {
        return airportFacade.getInventoryData(query, chars);
    }

    @GetMapping("/inventory/resource")
    public List<Map<String, Object>> getResourceInventory() {
        return airportFacade.getResourceInventory();
    }

    @GetMapping("/inventory/resource/{resource_id}")
    public Map<String, Object> getResourceData(@PathVariable String resource_id) {
        return airportFacade.getResourceData(resource_id);
    }
    

    @GetMapping("/stats/airnames")
    public List<Map<String, Object>> getAirlineNames() {
        return airportFacade.getAirlineNames();
    }

    @GetMapping("/general/airnames")
    public List<Map<String, Object>> getAirlineNamesGeneral() {
        return airportFacade.getAirlineNamesGeneral();
    }

    @GetMapping("/general/graph")
    public List<Map<String, Object>> getUniqueAirplanes() {
        return airportFacade.getUniqueAirplanes();
    }

    @GetMapping("/stats/getCount/{query}/{chars}")
    public List<Map<String, Object>> getCount(@PathVariable String query, @PathVariable String chars) {
        return airportFacade.getCount(query, chars);
    }

    @GetMapping("/logs/messages/{query}")
    public List<Map<String, Object>> getLogMessages(@PathVariable String query) {
        return airportFacade.getLogMessages(query);
    }

    @GetMapping("/logs/emergency/{query}")
    public List<Map<String, Object>> getEmergencyLogs(@PathVariable String query) {
        return airportFacade.getEmergencyLogs(query);
    }

    @GetMapping("/logs/notifs/{query}")
    public List<Map<String, Object>> getNotificationLogs(@PathVariable String query) {
        return airportFacade.getNotificationLogs(query);
    }

    @GetMapping("/settings/{query}")
    public List<Map<String, Object>> getSettings(@PathVariable String query) {
        return airportFacade.getSettings(query);
    }

    @PutMapping("/inventory/restock/{value}/{id}")
    public String restockResource(@PathVariable String value, @PathVariable String id) {
        return airportFacade.restockResource(value, id);
    }

    @PostMapping("/logs/push/{radios}/{subject}/{body}")
    public String pushLog(@PathVariable String radios, @PathVariable String subject, @PathVariable String body) {
        return airportFacade.pushLog(radios, subject, body);
    }

    @GetMapping("/auth")
    public List<Map<String, Object>> getAuthData() {
        return airportFacade.getAuthData();
    }

    @GetMapping("/auth/level/{username}")
    public List<Map<String, Object>> getAuthLevel(@PathVariable String username) {
        return airportFacade.getAuthLevel(username);
    }

    @PostMapping("/auth/add_usr")
    public String addUser(@RequestBody Map<String, Object> requestBody) {
        return airportFacade.addUser(requestBody);
    }

    @GetMapping("/error")
    public ResponseEntity<String> handleError() {
        return new ResponseEntity<>("An error has occurred.", HttpStatus.INTERNAL_SERVER_ERROR);
    }
}