package com.varunbwaj.ooadproj.controller;
//
//public class AirportController {
//}
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import com.varunbwaj.ooadproj.service.DatabaseService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
public class AirportController {
//    private static final AirportController instance = new AirportController();
    private final DatabaseService databaseService;

//    private AirportController() {}
    @Autowired
    public AirportController(DatabaseService databaseService) {
        this.databaseService = databaseService;
    }
//    public static AirportController getInstance(){
//        return instance;
//    }

    @GetMapping("/airports")
    public List<Map<String, Object>> getAirports() {
        return databaseService.queryForList("SELECT * FROM usr_info1");
    }

    @GetMapping("/ghs/hangar")
    public List<Map<String, Object>> getMaintenanceData1() {
        return databaseService.queryForList("CALL GetMaintenanceData1");
    }

    @GetMapping("/ghs/services")
    public List<Map<String, Object>> getGroundHandlingServiceData() {
        return databaseService.queryForList("CALL GetGroundHandlingServiceData");
    }

    @GetMapping("/maintenance")
    public List<Map<String, Object>> getMaintenanceData() {
        return databaseService.queryForList("CALL getMaintenanceData");
    }

    @GetMapping("/inventory/{query}/{chars}")
    public List<Map<String, Object>> getInventoryData(@PathVariable String query, @PathVariable String chars) {
        String finalQuery = query.replace("%s", chars);
        return databaseService.queryForList(finalQuery);
    }

    @GetMapping("/inventory/resource")
    public List<Map<String, Object>> getResourceInventory() {
        return databaseService.queryForList("SELECT `ResourceID`, `ResourceName` FROM ResourceInventory");
    }

    @GetMapping("/stats/airnames")
    public List<Map<String, Object>> getAirlineNames() {
        return databaseService.queryForList("SELECT AirlineID, AirlineName FROM Airlines");
    }

    @GetMapping("/general/airnames")
    public List<Map<String, Object>> getAirlineNamesGeneral() {
        return databaseService.queryForList("SELECT AirlineName FROM airlines");
    }

    @GetMapping("/general/graph")
    public List<Map<String, Object>> getUniqueAirplanes() {
        return databaseService.queryForList("SELECT * FROM unique_airplanes");
    }

    @GetMapping("/stats/getCount/{query}/{chars}")
    public List<Map<String, Object>> getCount(@PathVariable String query, @PathVariable String chars) {
        String finalQuery = query.replace("%s", chars);
        return databaseService.queryForList(finalQuery);
    }

    @GetMapping("/logs/messages/{query}")
    public List<Map<String, Object>> getLogMessages(@PathVariable String query) {
        return databaseService.queryForList(query);
    }

    @GetMapping("/logs/emergency/{query}")
    public List<Map<String, Object>> getEmergencyLogs(@PathVariable String query) {
        return databaseService.queryForList(query);
    }

    @GetMapping("/logs/notifs/{query}")
    public List<Map<String, Object>> getNotificationLogs(@PathVariable String query) {
        return databaseService.queryForList(query);
    }

    @GetMapping("/settings/{query}")
    public List<Map<String, Object>> getSettings(@PathVariable String query) {
        return databaseService.queryForList(query);
    }

    @PutMapping("/inventory/restock/{value}/{id}")
    public String restockResource(@PathVariable String value, @PathVariable String id) {
        String sqlQuery = "UPDATE ResourceInventory SET Quantity = ? WHERE ResourceID = ?";
        databaseService.update(sqlQuery, value, id);
        return "Resource updated successfully";
    }

    @PostMapping("/logs/push/{radios}/{subject}/{body}")
    public String pushLog(@PathVariable String radios, @PathVariable String subject, @PathVariable String body) {
        String sqlQuery = "INSERT INTO CommunicationLog (MessageType, MessageSubject, MessageBody, SentDate) VALUES (?, ?, ?, CURRENT_TIMESTAMP)";
        databaseService.update(sqlQuery, radios, subject, body);
        return "Log added successfully";
    }

    @GetMapping("/auth")
    public List<Map<String, Object>> getAuthData() {
        return databaseService.queryForList("SELECT username, hashed_pass as password, CONCAT(f_name, ' ', l_name) as names FROM usr_info");
    }

    @GetMapping("/auth/level/{username}")
    public List<Map<String, Object>> getAuthLevel(@PathVariable String username) {
        String sqlQuery = "SELECT auth_level FROM usr_info WHERE username = ?";
        return databaseService.queryForList(sqlQuery, username);
    }

    @PostMapping("/auth/add_usr")
    public String addUser(@RequestBody Map<String, Object> requestBody) {
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

    @GetMapping("/error")
    public ResponseEntity<String> handleError() {
        return new ResponseEntity<>("An error has occurred.", HttpStatus.INTERNAL_SERVER_ERROR);
    }
}