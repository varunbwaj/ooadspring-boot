Certainly, let's refactor the code according to your requirements. Here's how the classes would look like:

1. `AirportController.java`:
```java
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
```

2. `AirportManager.java`:
```java
@Service
public class AirportManager {
    private final DatabaseService databaseService;

    @Autowired
    public AirportManager(DatabaseService databaseService) {
        this.databaseService = databaseService;
    }

    public List<Map<String, Object>> getAirports() {
        return databaseService.queryForList("SELECT * FROM usr_info1");
    }

    public List<Map<String, Object>> getMaintenanceData1() {
        return databaseService.queryForList("CALL GetMaintenanceData1");
    }

    public List<Map<String, Object>> getGroundHandlingServiceData() {
        return databaseService.queryForList("CALL GetGroundHandlingServiceData");
    }

    public List<Map<String, Object>> getMaintenanceData() {
        return databaseService.queryForList("CALL getMaintenanceData");
    }

    public List<Map<String, Object>> getAirlineNames() {
        return databaseService.queryForList("SELECT AirlineID, AirlineName FROM Airlines");
    }

    public List<Map<String, Object>> getAirlineNamesGeneral() {
        return databaseService.queryForList("SELECT AirlineName FROM airlines");
    }

    public List<Map<String, Object>> getUniqueAirplanes() {
        return databaseService.queryForList("SELECT * FROM unique_airplanes");
    }

    public List<Map<String, Object>> getCount(String query, String chars) {
        String finalQuery = query.replace("%s", chars);
        return databaseService.queryForList(finalQuery);
    }

    public List<Map<String, Object>> getSettings(String query) {
        return databaseService.queryForList(query);
    }
}
```

3. `InventoryManager.java`:
```java
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
```

4. `LogsManager.java`:
```java
@Service
public class LogsManager {
    private final DatabaseService databaseService;

    @Autowired
    public LogsManager(DatabaseService databaseService) {
        this.databaseService = databaseService;
    }

    public List<Map<String, Object>> getLogMessages(String query) {
        return databaseService.queryForList(query);
    }

    public List<Map<String, Object>> getEmergencyLogs(String query) {
        return databaseService.queryForList(query);
    }

    public List<Map<String, Object>> getNotificationLogs(String query) {
        return databaseService.queryForList(query);
    }

    public String pushLog(String radios, String subject, String body) {
        String sqlQuery = "INSERT INTO CommunicationLog (MessageType, MessageSubject, MessageBody, SentDate) VALUES (?, ?, ?, CURRENT_TIMESTAMP)";
        databaseService.update(sqlQuery, radios, subject, body);
        return "Log added successfully";
    }
}
```

5. `AuthManager.java`:
```java
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
```

6. `DatabaseService.java`:
```java
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

    public int executeUpdate(String query, Object... args) {
        return jdbcTemplate.update(query, args);
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
```

In this refactored version, the `DatabaseService` class is responsible for all the database-related operations, and the various manager classes (`AirportManager`, `InventoryManager`, `LogsManager`, and `AuthManager`) handle the specific business logic and delegate the database operations to the `DatabaseService` class.

The `AirportController` class now only calls the appropriate methods in the manager classes, keeping the controller code focused on the presentation layer and the business logic in the manager classes.

This structure provides a better separation of concerns and makes the code more maintainable and testable.