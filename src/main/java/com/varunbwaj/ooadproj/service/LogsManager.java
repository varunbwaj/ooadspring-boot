package com.varunbwaj.ooadproj.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;

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

        if (radios != "" && subject != "" && body != ""){
            String sqlQuery = "INSERT INTO CommunicationLog (MessageType, MessageSubject, MessageBody, SentDate) VALUES (?, ?, ?, CURRENT_TIMESTAMP)";
            databaseService.update(sqlQuery, radios, subject, body);
            return "Log added successfully";
        }else{
            return "Please Fill All fields";
        }
    }
}
