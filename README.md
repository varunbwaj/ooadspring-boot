# Airport Staff Management System

This is a Java-based system that manages airport operations, including resource inventory, logging, and user authentication. The system is composed of several classes that work together to provide a comprehensive solution.

## Class Diagram

```mermaid
classDiagram

class AirportController {
- airport: Airport
- inventory: Inventory
- logs: Logs
- auth: Auth
+ restockResource(value: String, id: String): String
+ pushLog(radios: String, subject: String, body: String): String
+ addUser(requestBody: Map<String, Object>): String
+ handleError(): ResponseEntity<String>
}

class Airport {
- databaseService: DatabaseService
}

class Inventory {
- databaseService: DatabaseService
+ restockResource(value: String, id: String): String
}

class Logs {
- databaseService: DatabaseService
+ pushLog(radios: String, subject: String, body: String): String
}

class Auth {
- databaseService: DatabaseService
+ addUser(requestBody: Map<String, Object>): String
}

class DatabaseService {
- jdbcTemplate: JdbcTemplate
+ queryForList(query: String): List<Map<String, Object>>
+ queryForList(query: String, args: Object...): List<Map<String, Object>>
+ update(query: String, args: Object...): void
+ executeUpdate(query: String, args: Object...): int
+ queryForMap(query: String, args: Object...): Map<String, Object>
+ query(query: String, rowMapper: RowMapper, args: Object...): List<T>
+ queryForObject(query: String, rowMapper: RowMapper, args: Object...): T
}

AirportController "1" -- "1" Airport
AirportController "1" -- "1" Inventory
AirportController "1" -- "1" Logs
AirportController "1" -- "1" Auth
Airport "1" -- "1" DatabaseService
Inventory "1" -- "1" DatabaseService
Logs "1" -- "1" DatabaseService
Auth "1" -- "1" DatabaseService
```

## Class Descriptions

### AirportController

The `AirportController` class is the main entry point for the system. It provides methods for managing resources, logging operations, adding users, and handling errors.

### Airport

The `Airport` class represents the airport itself and contains a reference to the `DatabaseService`.

### Inventory

The `Inventory` class manages the inventory of resources at the airport. It provides a method for restocking resources and uses the `DatabaseService` for data persistence.

### Logs

The `Logs` class handles logging operations at the airport. It provides a method for pushing log entries and uses the `DatabaseService` for data persistence.

### Auth

The `Auth` class is responsible for user authentication and authorization. It provides a method for adding new users and uses the `DatabaseService` for data persistence.

### DatabaseService

The `DatabaseService` class is a utility class that provides methods for interacting with a database using JDBC. It includes methods for executing queries, updates, and retrieving data in various formats.
