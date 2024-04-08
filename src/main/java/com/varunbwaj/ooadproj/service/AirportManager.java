package com.varunbwaj.ooadproj.service;
import com.varunbwaj.ooadproj.service.DatabaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;

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
        return databaseService.queryForList("SELECT AirlineName FROM Airlines");
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
