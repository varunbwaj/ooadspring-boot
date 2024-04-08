-- SQLBook: Code
-- Active: 1696681355003@@127.0.0.1@3306@airport
DROP DATABASE IF EXISTS airport;

CREATE DATABASE airport;

USE airport;


CREATE TABLE usr_info(
    usrid INT AUTO_INCREMENT PRIMARY KEY,
    f_name VARCHAR(25),
    minit VARCHAR(5),
    l_name VARCHAR(25),
    username VARCHAR(25) UNIQUE,
    hashed_pass VARCHAR(255),
    auth_level ENUM('0','1','2') DEFAULT '2',
    CONSTRAINT uname_pass UNIQUE (username,hashed_pass)
);

CREATE TABLE usr_info1(
    usrid INT AUTO_INCREMENT PRIMARY KEY,
    f_name VARCHAR(25),
    minit VARCHAR(5),
    l_name VARCHAR(25),
    username VARCHAR(25) UNIQUE,
    hashed_pass VARCHAR(255),
    auth_level ENUM('0','1','2') DEFAULT '2',
    CONSTRAINT uname_pass UNIQUE (username,hashed_pass)
);

INSERT INTO usr_info1(f_name, l_name, minit, username, hashed_pass, auth_level) VALUES
('John', 'Doe', 'A', 'johndoe1', 'pass123', '1'),
('Alice', 'Smith', 'B', 'alice.smith', 'abc456', '2'),
('Bob', 'Johnson', 'C', 'bobj', 'bob789', '0'),
('Emily', 'Davis', 'D', 'emily_d', 'emily123', '1'),
('Michael', 'Wilson', 'E', 'mike.w', 'mike456', '2'),
('Sarah', 'Brown', 'F', 'sarah_b', 'sarah789', '1'),
('David', 'Lee', 'G', 'davidl', 'david123', '2'),
('Laura', 'Clark', 'H', 'laura.c', 'laura456', '1'),
('James', 'Anderson', 'I', 'james123', 'pass789', '0'),
('Sophia', 'Martinez', 'J', 'sophiam', 'sophia123', '2'),
('Admin','Admin','','admin','abc','0'),
('Peter','Parker','P','ppparker','1234567890','0'),
('James','May','','jamesmay','captainslow','1'),
('Richard','Hammond','','richardham','hamster','2');


-- Airlines table
CREATE TABLE Airlines (
  AirlineID INT NOT NULL AUTO_INCREMENT,
  AirlineName VARCHAR(255) NOT NULL,
  AirlineCode VARCHAR(3) NOT NULL,
  NumberOfEmployees INT,
  NumberOfPassengers INT,
  PRIMARY KEY (AirlineID)
);

-- Airplanes table
-- CREATE TABLE Airplanes (
--   AirplaneID INT NOT NULL AUTO_INCREMENT,
--   AirplaneType VARCHAR(255) NOT NULL,
--   AirplaneRegistration VARCHAR(100) NOT NULL,
--   PRIMARY KEY (AirplaneID)
-- );

CREATE TABLE Airplanes (
  AirplaneID INT NOT NULL AUTO_INCREMENT,
  AirplaneType VARCHAR(255) NOT NULL,
  AirplaneRegistration VARCHAR(100) NOT NULL,
  AirlineID INT NOT NULL,
  PRIMARY KEY (AirplaneID),
  FOREIGN KEY (AirlineID) REFERENCES Airlines(AirlineID)
);

-- DeIcingMethods table
CREATE TABLE DeIcingMethods (
  DeIcingMethodID INT NOT NULL AUTO_INCREMENT,
  DeIcingMethodName VARCHAR(255) NOT NULL,
  PRIMARY KEY (DeIcingMethodID)
);

-- FuelingCenters table
CREATE TABLE FuelingCenters (
  FuelingCenterID INT NOT NULL AUTO_INCREMENT,
  FuelingCenterName VARCHAR(255) NOT NULL,
  FuelingCenterLocation VARCHAR(255) NOT NULL,
  PRIMARY KEY (FuelingCenterID)
);

-- Gateways table
CREATE TABLE Gateways (
  GatewayID INT NOT NULL AUTO_INCREMENT,
  GatewayName VARCHAR(255) NOT NULL,
  GatewayLocation VARCHAR(255) NOT NULL,
  PRIMARY KEY (GatewayID)
);
-- Services table
CREATE TABLE Services (
  ServiceID INT NOT NULL AUTO_INCREMENT,
  ServiceName VARCHAR(255) NOT NULL,
  PRIMARY KEY (ServiceID)
);

-- ServiceDeIcingMethodMappings table
CREATE TABLE ServiceDeIcingMethodMappings (
  ServiceID INT NOT NULL,
  DeIcingMethodID INT NOT NULL,
  PRIMARY KEY (ServiceID, DeIcingMethodID),
  FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
  FOREIGN KEY (DeIcingMethodID) REFERENCES DeIcingMethods(DeIcingMethodID)
);


-- Resource Inventory table
CREATE TABLE ResourceInventory (
  ResourceID INT NOT NULL AUTO_INCREMENT,
  ResourceType VARCHAR(255) NOT NULL,
  ResourceName VARCHAR(255) NOT NULL,
  Quantity INT NOT NULL,
  Location VARCHAR(255) NOT NULL,
  Status VARCHAR(255) NOT NULL,
  MinimumQuantity INT NOT NULL,
  MaximumQuantity INT NOT NULL,
  LastUpdated DATETIME NOT NULL,
  NextScheduledMaintenance DATETIME DEFAULT (DATE_ADD(LastUpdated, INTERVAL 1 WEEK)),
  ServiceID INT NOT NULL,
  FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
  PRIMARY KEY (ResourceID)
);
-- Resource Request table
CREATE TABLE ResourceRequests (
  RequestID INT NOT NULL AUTO_INCREMENT,
  ResourceID INT NOT NULL,
  Quantity INT NOT NULL,
  RequestedBy VARCHAR(255) NOT NULL,
  RequestDate DATETIME NOT NULL,
  Status VARCHAR(255) NOT NULL,
  ServiceID INT NOT NULL,
  FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
  PRIMARY KEY (RequestID),
  FOREIGN KEY (ResourceID) REFERENCES ResourceInventory(ResourceID)
);

-- Maintenance Schedule table
CREATE TABLE MaintenanceSchedule (
  ScheduleID INT NOT NULL AUTO_INCREMENT,
  AirplaneID INT NOT NULL,
  MaintenanceType VARCHAR(255) NOT NULL,
  ScheduledDate DATETIME NOT NULL,
  Status VARCHAR(255) NOT NULL,
  ServiceID INT NOT NULL,
  FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
  PRIMARY KEY (ScheduleID),
  FOREIGN KEY (AirplaneID) REFERENCES Airplanes(AirplaneID)
);

-- Maintenance Request table
CREATE TABLE MaintenanceRequests (
  RequestID INT NOT NULL AUTO_INCREMENT,
  AirplaneID INT NOT NULL,
  MaintenanceType VARCHAR(255) NOT NULL,
  RequestedBy VARCHAR(255) NOT NULL,
  RequestDate DATETIME NOT NULL,
  Status VARCHAR(255) NOT NULL,
  ServiceID INT NOT NULL,
  FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
  PRIMARY KEY (RequestID),
  FOREIGN KEY (AirplaneID) REFERENCES Airplanes(AirplaneID)
);

-- Gate Allocation table
CREATE TABLE GateAllocation (
  GateID INT NOT NULL,
  AirplaneID INT NOT NULL,
  AirlineID INT NOT NULL,
  FlightNumber VARCHAR(10) NOT NULL,
  ArrivalDate DATETIME NOT NULL,
  DepartureDate DATETIME NOT NULL,
  ServiceID INT NOT NULL,
  FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
  PRIMARY KEY (GateID, AirplaneID)
);


-- Ground Handling Request table
CREATE TABLE GroundHandlingRequests (
RequestID INT NOT NULL AUTO_INCREMENT,
AirplaneID INT NOT NULL,
GroundHandlingService VARCHAR(255) NOT NULL,
RequestedBy VARCHAR(255) NOT NULL,
RequestDate DATETIME NOT NULL,
Status VARCHAR(255) NOT NULL,
ServiceID INT NOT NULL,
FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
PRIMARY KEY (RequestID),
FOREIGN KEY (AirplaneID) REFERENCES Airplanes(AirplaneID)
);

-- De-icing Request table
CREATE TABLE DeIcingRequests (
RequestID INT NOT NULL AUTO_INCREMENT,
AirplaneID INT NOT NULL,
DeIcingMethod VARCHAR(255) NOT NULL,
RequestedBy VARCHAR(255) NOT NULL,
RequestDate DATETIME NOT NULL,
Status VARCHAR(255) NOT NULL,
ServiceID INT NOT NULL,
FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
PRIMARY KEY (RequestID),
FOREIGN KEY (AirplaneID) REFERENCES Airplanes(AirplaneID)
);

-- Incident Report table
CREATE TABLE IncidentReport (
IncidentID INT NOT NULL AUTO_INCREMENT,
IncidentType VARCHAR(255) NOT NULL,
IncidentDate DATETIME NOT NULL,
IncidentLocation VARCHAR(255) NOT NULL,
IncidentDescription VARCHAR(255) NOT NULL,
ReportedBy VARCHAR(255) NOT NULL,
ServiceID INT NOT NULL,
FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
PRIMARY KEY (IncidentID)
);

-- Communication Log table
CREATE TABLE CommunicationLog (
MessageID INT NOT NULL AUTO_INCREMENT,
MessageType VARCHAR(255) NOT NULL,
MessageSubject VARCHAR(255) NOT NULL,
MessageBody VARCHAR(255) NOT NULL,
SentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (MessageID)
);

-- Airlines table
INSERT INTO Airlines (AirlineName, AirlineCode, NumberOfEmployees, NumberOfPassengers) VALUES
('Delta Airlines', 'DL', 10000, 5000000),
('American Airlines', 'AA', 12000, 6000000),
('United Airlines', 'UA', 11000, 5500000),
('Lufthansa', 'LH', 15000, 7000000),
('Emirates', 'EK', 20000, 8000000);

-- Airplanes table
-- Insert data into the new Airplanes table with AirlineID
INSERT INTO Airplanes (AirplaneType, AirplaneRegistration, AirlineID) VALUES
('Boeing 737-800', 'N123DA', 1),
('Airbus A320', 'N456AA', 2),
('Boeing 777-200', 'N789UA', 3),
('Boeing 747-400', 'N789EK', 5),
('Airbus A330', 'N321DL', 1),
('Boeing 787-9', 'N789AA', 2),
('Airbus A321', 'N456UA', 3),
('Boeing 747-8', 'N101LH', 4),
('Embraer E190', 'N456EK', 5),
('Airbus A350', 'N654AA', 2),
('Boeing 767-300', 'N222UA', 3),
('Airbus A319', 'N987LH', 4),
('Embraer E175', 'N987EK', 5),
('Boeing 737 MAX 8', 'N345DA', 1),
('Boeing 787-10', 'N345UA', 3),
('Airbus A340', 'N222LH', 4),
('Boeing 737-900', 'N456DL', 1),
('Airbus A380plus', 'N789AA', 2),
('Boeing 757', 'N777UA', 3),
('Airbus A318', 'N555LH', 4);

-- DeIcingMethods table
INSERT INTO DeIcingMethods (DeIcingMethodName) VALUES
('Type I De-Icing'),
('Type II De-Icing'),
('Type III De-Icing');

-- FuelingCenters table
INSERT INTO FuelingCenters (FuelingCenterName, FuelingCenterLocation) VALUES
('Fuel Center A', 'Terminal A'),
('Fuel Center B', 'Terminal B'),
('Fuel Center C', 'Terminal C'),
('Fuel Center D', 'Terminal D'),
('Fuel Center E', 'Terminal E');

-- Gateways table
INSERT INTO Gateways (GatewayName, GatewayLocation) VALUES
('Gate A1', 'Terminal A'),
('Gate B2', 'Terminal B'),
('Gate C3', 'Terminal C'),
('Gate D4', 'Terminal D'),
('Gate E5', 'Terminal E');



-- Services table
INSERT INTO Services (ServiceName) VALUES
('Fueling Service'),
('Aircraft Parking Gates'),
('Air Traffic Control'),
('Ground Handling Service'),
('Aircraft De-icing'),
('Emergency Services'),
('Catering Service'),
('Fueling Centre');

-- ServiceDeIcingMethodMappings table
INSERT INTO ServiceDeIcingMethodMappings (ServiceID, DeIcingMethodID) VALUES
(5, 1),
(5, 2),
(5, 3);

-- Resource Inventory table
INSERT INTO ResourceInventory (ResourceType, ResourceName, Quantity, Location, Status, MinimumQuantity, MaximumQuantity, LastUpdated, ServiceID)
VALUES
('Jet Fuel', 'Jet A1', 100000, 'Fuel Center A', 'In Service', 5000, 200000, '2023-11-01 08:00:00', 1),
('De-Icing Fluid', 'Type I De-Icer', 50, 'Hangar X', 'In Service', 10, 100, '2023-11-01 10:00:00', 5),
('Food Supplies', 'Meal Cartons', 10000, 'Catering Warehouse', 'In Service', 500, 20000, '2023-11-02 09:30:00', 7);

-- Resource Request table
INSERT INTO ResourceRequests (ResourceID, Quantity, RequestedBy, RequestDate, Status, ServiceID) VALUES
(1, 50000, 'Delta Airlines', '2023-11-02 14:15:00', 'Approved', 1),
(2, 20, 'American Airlines', '2023-11-03 10:30:00', 'Pending', 5),
(3, 2000, 'United Airlines', '2023-11-02 16:45:00', 'Pending', 7);

-- Maintenance Schedule table
INSERT INTO MaintenanceSchedule (AirplaneID, MaintenanceType, ScheduledDate, Status, ServiceID) VALUES
(1, 'Routine Inspection', '2023-11-05 08:00:00', 'Scheduled', 3),
(2, 'Repair', '2023-11-07 14:30:00', 'Scheduled', 3);

-- Maintenance Request table
INSERT INTO MaintenanceRequests (AirplaneID, MaintenanceType, RequestedBy, RequestDate, Status, ServiceID) VALUES
(3, 'Routine Inspection', 'United Airlines', '2023-11-08 09:00:00', 'Pending', 3),
(1, 'Repair', 'Delta Airlines', '2023-11-08 11:45:00', 'Pending', 3);

-- Gate Allocation table
INSERT INTO GateAllocation (GateID, AirplaneID, AirlineID, FlightNumber, ArrivalDate, DepartureDate, ServiceID) VALUES
(1, 1, 1, 'DL123', '2023-11-05 09:30:00', '2023-11-05 13:45:00', 2),
(2, 2, 2, 'AA456', '2023-11-06 10:15:00', '2023-11-06 14:30:00', 2);

-- Ground Handling Request table
INSERT INTO GroundHandlingRequests (AirplaneID, GroundHandlingService, RequestedBy, RequestDate, Status, ServiceID) VALUES
(1, 'Baggage Handling', 'Delta Airlines', '2023-11-05 09:00:00', 'Approved', 4),
(2, 'Towing', 'American Airlines', '2023-11-06 10:30:00', 'Pending', 4);

-- De-icing Request table
INSERT INTO DeIcingRequests (AirplaneID, DeIcingMethod, RequestedBy, RequestDate, Status, ServiceID) VALUES
(1, 'Type II De-Icing', 'Delta Airlines', '2023-11-05 11:15:00', 'Approved', 5),
(2, 'Type I De-Icing', 'American Airlines', '2023-11-06 12:30:00', 'Pending', 5);

-- Incident Report table
INSERT INTO IncidentReport (IncidentType, IncidentDate, IncidentLocation, IncidentDescription, ReportedBy, ServiceID) VALUES
('Safety Incident', '2023-11-04 14:45:00', 'Gate A1', 'Minor safety issue', 'Delta Airlines', 6),
('Accident', '2023-11-07 10:30:00', 'Runway C', 'Aircraft collision', 'American Airlines', 6);

-- Communication Log table
INSERT INTO CommunicationLog (MessageType, MessageSubject, MessageBody, SentDate) VALUES
('Notification', 'Gate Change', 'Gate A1 changed to Gate B2', '2023-11-05 09:15:00'),
('Emergency', 'Safety Alert', 'Emergency on Runway C, please divert flights', '2023-11-07 10:32:00');

DELIMITER //

CREATE PROCEDURE GetMaintenanceData()
BEGIN
    SELECT `RequestedBy`, `MaintenanceType`, `RequestDate`, `Status`, a0.`AirplaneType`, a0.`AirplaneRegistration`
    FROM `MaintenanceRequests` AS mr
    JOIN `Airplanes` AS a0 ON a0.`AirplaneID` = mr.`AirplaneID`
    UNION ALL
    SELECT a1.`AirlineName` AS `RequestedBy`, MaintenanceType, ScheduledDate, `Status`, a0.`AirplaneType`, a0.`AirplaneRegistration`
    FROM `MaintenanceSchedule` AS ms
    JOIN `Airplanes` AS a0 ON a0.`AirplaneID` = ms.`AirplaneID`
    JOIN `Airlines` AS a1 ON a1.`AirlineID` = a0.`AirlineID`;
END//

DELIMITER ;


DELIMITER //
CREATE PROCEDURE GetMaintenanceData1()
BEGIN
    SELECT
        GA.`ArrivalDate`, GA.`DepartureDate`, GA.`FlightNumber`,
        a0.`AirlineName`,
        a1.`AirplaneType`, a1.`AirplaneRegistration`,
        GW.`GatewayLocation`
    FROM `GateAllocation` AS GA
    JOIN `Airlines` AS a0 ON a0.`AirlineID` = GA.`AirlineID`
    JOIN `Airplanes` AS a1 ON a1.`AirplaneID` = GA.`AirplaneID`
    JOIN `Gateways` AS GW ON GW.`GatewayID` = GA.`GateID`;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetGroundHandlingServiceData()
BEGIN
    SELECT
        a0.`AirplaneType`, a0.`AirplaneRegistration`,
        GHR.`GroundHandlingService`, GHR.`RequestDate`, GHR.`Status`
    FROM `GroundHandlingRequests` AS GHR
    JOIN `Airplanes` AS a0 ON GHR.`AirplaneID` = a0.`AirplaneID`;
END//

DELIMITER ;


-- SELECT
--     AirlineName,
--     AirplaneType,
--     ScheduledDate AS FlightDate,
--     Status AS FlightStatus
-- FROM Airlines
-- JOIN Airplanes ON Airlines.AirlineID = Airplanes.AirplaneID
-- JOIN GateAllocation ON Airplanes.AirplaneID = GateAllocation.AirplaneID
-- JOIN Services ON GateAllocation.ServiceID = Services.ServiceID
-- JOIN MaintenanceSchedule ON Airplanes.AirplaneID = MaintenanceSchedule.AirplaneID
-- WHERE Airlines.AirlineName = 'Delta Airlines';


-- -- Report a safety incident
-- INSERT INTO IncidentReport (IncidentType, IncidentDate, IncidentLocation, IncidentDescription, ReportedBy, ServiceID)
-- VALUES ('Safety Incident', '2023-11-09 13:30:00', 'Gate C3', 'Minor safety issue', 'Delta Airlines', 6);


-- SELECT * FROM `Airlines`;

-- SELECT `AirlineID`,COUNT(*) FROM `Airplanes` GROUP BY `AirlineID`;
-- SELECT COUNT(*), a1.`AirlineName` FROM `Airplanes` as a0
-- JOIN `Airlines` as a1
-- ON a0.`AirlineID`=a1.`AirlineID`
-- GROUP BY a1.`AirlineID`;

CREATE TABLE MonthlyAirplaneCount (
  MonthlyCountID INT NOT NULL AUTO_INCREMENT,
  AirlineID INT NOT NULL,
  Year INT NOT NULL,
  Month INT NOT NULL,
  AirplaneCount INT NOT NULL,
  PRIMARY KEY (MonthlyCountID),
  FOREIGN KEY (AirlineID) REFERENCES Airlines(AirlineID)
);

-- Delta Airlines (DL) Monthly Airplane Counts for 2023
INSERT INTO MonthlyAirplaneCount (AirlineID, Year, Month, AirplaneCount)
VALUES
  (1, 2023, 6, 52),
  (1, 2023, 7, 64),
  (1, 2023, 8, 58),
  (1, 2023, 9, 71),
  (1, 2023, 10, 47),
  (1, 2023, 11, 62),
  (1, 2023, 12, 56),
  (1, 2023, 1, 68),
  (1, 2023, 2, 60),
  (1, 2023, 3, 55),
  (1, 2023, 4, 70),
  (1, 2023, 5, 50);

-- American Airlines (AA) Monthly Airplane Counts for 2023
INSERT INTO MonthlyAirplaneCount (AirlineID, Year, Month, AirplaneCount)
VALUES
  (2, 2023, 6, 75),
  (2, 2023, 7, 70),
  (2, 2023, 8, 80),
  (2, 2023, 9, 73),
  (2, 2023, 10, 85),
  (2, 2023, 11, 72),
  (2, 2023, 12, 88),
  (2, 2023, 1, 82),
  (2, 2023, 2, 78),
  (2, 2023, 3, 90),
  (2, 2023, 4, 76),
  (2, 2023, 5, 79);

-- United Airlines (UA) Monthly Airplane Counts for 2023
INSERT INTO MonthlyAirplaneCount (AirlineID, Year, Month, AirplaneCount)
VALUES
  (3, 2023, 6, 45),
  (3, 2023, 7, 49),
  (3, 2023, 8, 52),
  (3, 2023, 9, 47),
  (3, 2023, 10, 53),
  (3, 2023, 11, 48),
  (3, 2023, 12, 55),
  (3, 2023, 1, 50),
  (3, 2023, 2, 54),
  (3, 2023, 3, 51),
  (3, 2023, 4, 56),
  (3, 2023, 5, 53);

-- Lufthansa (LH) Monthly Airplane Counts for 2023
INSERT INTO MonthlyAirplaneCount (AirlineID, Year, Month, AirplaneCount)
VALUES
  (4, 2023, 6, 35),
  (4, 2023, 7, 42),
  (4, 2023, 8, 37),
  (4, 2023, 9, 41),
  (4, 2023, 10, 39),
  (4, 2023, 11, 38),
  (4, 2023, 12, 43),
  (4, 2023, 1, 40),
  (4, 2023, 2, 45),
  (4, 2023, 3, 39),
  (4, 2023, 4, 44),
  (4, 2023, 5, 41);

-- Emirates (EK) Monthly Airplane Counts for 2023
INSERT INTO MonthlyAirplaneCount (AirlineID, Year, Month, AirplaneCount)
VALUES
  (5, 2023, 6, 62),
  (5, 2023, 7, 68),
  (5, 2023, 8, 65),
  (5, 2023, 9, 70),
  (5, 2023, 10, 75),
  (5, 2023, 11, 69),
  (5, 2023, 12, 78),
  (5, 2023, 1, 73),
  (5, 2023, 2, 76),
  (5, 2023, 3, 80),
  (5, 2023, 4, 79),
  (5, 2023, 5, 82);


CREATE VIEW unique_airplanes AS
select count(*) as UniqueAirLines, a1.AirlineName 
  from airplanes as a0 join airlines 
  as a1 on a0.AirlineID=a1.AirlineID group by a1.AirlineID;

-- DROP FUNCTION `UpdateResourceInventory`;

-- DELIMITER //
-- CREATE FUNCTION GetResourceInventory()
-- RETURNS TEXT
-- DETERMINISTIC
-- READS SQL DATA
-- BEGIN
--     DECLARE result TEXT;

--     SET result = (
--         SELECT GROUP_CONCAT(CONCAT(ResourceID, ':', ResourceName) SEPARATOR '\n')
--         FROM ResourceInventory
--     );

--     RETURN result;
-- END;
-- //
-- DELIMITER ;

DELIMITER //

CREATE FUNCTION GetRoundedAverageAirplaneCount(p_AirlineID INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE avg_airplane_count INT;
    
    SELECT ROUND(AVG(mac.`AirplaneCount`))
    INTO avg_airplane_count
    FROM MonthlyAirplaneCount AS mac
    JOIN Airlines AS a0 ON mac.AirlineID = a0.AirlineID
    WHERE mac.AirlineID = p_AirlineID;
    
    RETURN avg_airplane_count;
END;
//
DELIMITER ;

-- SELECT GetRoundedAverageAirplaneCount(1);
DELIMITER //
CREATE FUNCTION GetNumberOfPassengersForAirline(p_AirlineID INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE num_passengers INT;
    
    SELECT NumberOfPassengers
    INTO num_passengers
    FROM Airlines AS a
    WHERE AirlineID = p_AirlineID;
    
    RETURN num_passengers;
END;
//
DELIMITER ;

-- SELECT GetNumberOfPassengersForAirline(%s);
DELIMITER //
CREATE FUNCTION GetNumberOfEmployeesForAirline(p_AirlineID INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE num_employees INT;
    
    SELECT NumberOfEmployees
    INTO num_employees
    FROM Airlines AS a
    WHERE AirlineID = p_AirlineID;
    
    RETURN num_employees;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER CommunicationLog_InsertTrigger
BEFORE INSERT ON CommunicationLog
FOR EACH ROW
BEGIN
    -- Check if any of the values being inserted are NULL
    IF (
        NEW.MessageType IS NULL OR
        NEW.MessageSubject IS NULL OR
        NEW.MessageBody IS NULL
    ) THEN
        -- Raise an error or handle as needed
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'One or more values being inserted are NULL';
    END IF;
END;
//
DELIMITER ;

-- SELECT GetNumberOfEmployeesForAirline(%s);


-- SELECT * FROM `CommunicationLog`;

-- DROP FUNCTION `GetResourceInventory`;
-- SHOW TABLES;
-- SELECT * FROM `Airplanes`;
-- SELECT  a0.`AirplaneRegistration`, a0.`AirplaneType`
-- FROM `Airplanes` as a0
-- JOIN `Airlines` as a1
-- ON a0.`AirlineID`=a1.`AirlineID`
-- WHERE a0.`AirlineID` = 4;



-- SELECT * FROM `MonthlyAirplaneCount` as mac
-- JOIN `Airlines` as a0
-- ON mac.`AirlineID` = a0.`AirlineID`
-- WHERE mac.`AirlineID` = 1
-- ORDER BY `Month`;


-- SELECT mac.`AirplaneCount`, mac.`Year`,mac.`Month`
-- FROM MonthlyAirplaneCount as mac
-- JOIN Airlines as a0 ON mac.AirlineID = a0.AirlineID
-- WHERE mac.AirlineID = 1
-- ORDER BY YEAR(mac.Month), MONTH(mac.Month);


-- -- Month airplane count

-- SELECT * FROM ResourceInventory;

-- SELECT * FROM GroundHandlingRequests;
-- SELECT * FROM FuelingCenters;

-- SHOW TABLES;



-- Graveyard

-- SELECT  `MinimumQuantity`, `Quantity`,`MaximumQuantity` FROM `ResourceInventory`
-- WHERE `ResourceID` = %s;



-- SELECT * FROM ResourceInventory;

-- SELECT MinimumQuantity,  Quantity as `current quantity`, MaximumQuantity FROM `ResourceInventory` WHERE `ResourceID`=1;


-- SELECT NextScheduledMaintenance FROM ResourceInventory WHERE `ResourceID`=1;

-- SELECT LastUpdated FROM ResourceInventory WHERE `ResourceID`=%s;

-- SELECT * FROM `ResourceInventory` WHERE `ResourceID` = 1;

-- -- 100000

-- UPDATE ResourceInventory
-- SET Quantity = Quantity + 2
-- WHERE ResourceID = 1;


-- SHOW TABLES;


-- SELECT * FROM `CommunicationLog`;

-- SELECT * FROM `IncidentReport`;

-- SELECT `IncidentDescription` FROM `IncidentReport` ORDER BY `IncidentDate` DESC LIMIT 3;


-- SELECT `MessageSubject`, `MessageBody` FROM `CommunicationLog` WHERE `MessageType` LIKE ('%Emergency%') ORDER BY `SentDate` DESC LIMIT 5;
-- SELECT `MessageSubject`, `MessageBody` FROM `CommunicationLog` WHERE `MessageType` LIKE ('%Notification%') ORDER BY `SentDate` DESC LIMIT 5;

-- INSERT INTO CommunicationLog (SenderID, RecipientID, MessageType, MessageSubject, MessageBody, SentDate) VALUES
-- (%s,%s,%s,%s,%s,%s);

-- SELECT DISTINCT `MessageType` FROM `CommunicationLog`;
-- SELECT * FROM `CommunicationLog`;
-- SHOW TABLES;

-- SELECT * FROM `GateAllocation`;



-- SELECT * from `Services`;
	
-- SELECT 
-- 	a0.`AirplaneType`, a0.`AirplaneRegistration`,  
-- 	GHR.`GroundHandlingService`, GHR.`RequestDate`, GHR.`Status`
-- FROM `GroundHandlingRequests` as GHR
-- JOIN `Airplanes` as a0
-- ON GHR.`AirplaneID` = a0.`AirplaneID`;

-- SELECT 
-- 	GA.`ArrivalDate`, GA.`DepartureDate`, GA.`FlightNumber`, 
-- 	a0.`AirlineName`, 
-- 	a1.`AirplaneType`, a1.`AirplaneRegistration`, 
-- 	GW.`GatewayLocation`
-- FROM `GateAllocation` as GA
-- JOIN `Airlines` as a0
-- ON a0.`AirlineID` = GA.`AirlineID`
-- JOIN `Airplanes` as a1
-- ON a1.`AirplaneID` = GA.`AirplaneID`
-- JOIN `Gateways` as GW
-- ON GW.`GatewayID` = GA.`GateID`;

-- SELECT NOW() AS current_datetime;

-- SELECT CURRENT_TIMESTAMP;

-- select * from CommunicationLog;

-- SELECT * FROM usr_info1;
-- SELECT * FROM `Airlines`;
-- SELECT `NumberOfEmployees`, `NumberOfPassengers`as `Total Passengers Flown` FROM `Airlines` WHERE `AirlineID` = 1;
-- SELECT * FROM usr_info1;

START TRANSACTION;

DROP USER IF EXISTS 'ooadproj'@'localhost';
CREATE USER 'ooadproj'@'localhost' IDENTIFIED BY 'ooadproj';


GRANT ALL PRIVILEGES ON airport.* TO 'ooadproj'@'localhost';


FLUSH PRIVILEGES;
SHOW GRANTS FOR 'ooadproj'@'localhost';

COMMIT;