CREATE DATABASE PetPals;
USE PetPals;
--creating tables
--PETS TABLE
CREATE TABLE Pets (
    PetID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Breed VARCHAR(50),
    Type VARCHAR(20),
    AvailableForAdoption BIT
);
--SHELTERS TABLE
CREATE TABLE Shelters (
    ShelterID INT PRIMARY KEY,
    Name VARCHAR(50),
    Location VARCHAR(100)
);

--DONATION TABLE
CREATE TABLE Donations (
    DonationID INT PRIMARY KEY,
    DonorName VARCHAR(50),
    DonationType VARCHAR(20),
    DonationAmount DECIMAL(10,2),
    DonationItem VARCHAR(50),
    DonationDate DATETIME
);
--ADOPTIONEVENT TABLE
CREATE TABLE AdoptionEvents (
    EventID INT PRIMARY KEY,
    EventName VARCHAR(100),
    EventDate DATETIME,
    Location VARCHAR(100)
);
--PARTICIPANTS TABLE
CREATE TABLE  Participants (
    ParticipantID INT PRIMARY KEY,
    ParticipantName VARCHAR(100),
    ParticipantType VARCHAR(20),
    EventID INT,
    FOREIGN KEY (EventID) REFERENCES AdoptionEvents(EventID)
);
-- Users Table 
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(50)
);
-- Adoption Table 
CREATE TABLE Adoption (
    AdoptionID INT PRIMARY KEY,
    PetID INT,
    UserID INT,
    ShelterID INT,
    FOREIGN KEY (PetID) REFERENCES Pets(PetID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ShelterID) REFERENCES Shelters(ShelterID)
);
ALTER TABLE Pets
ADD ShelterID INT,
    OwnerID INT NULL;

-- INSERTING VALUES INTO CREATED TABLES
-- Insert into Shelters
INSERT INTO Shelters VALUES
(1, 'Happy Tails Shelter', 'Chennai'),
(2, 'Safe Haven Pets', 'Coimbatore');
-- Insert into Pets
INSERT INTO Pets VALUES
(1, 'Tommy', 2, 'Labrador', 'Dog', 1, 1, NULL),
(2, 'Misty', 4, 'Persian', 'Cat', 0, 1, 1),
(3, 'Rocky', 1, 'Beagle', 'Dog', 1, 2, NULL),
(4, 'Luna', 6, 'Siamese', 'Cat', 1, 2, NULL);
-- Insert into Users (adopters)
INSERT INTO Users VALUES
(1, 'Ravi Kumar'),
(2, 'Sneha R');
-- Insert into Donations
INSERT INTO Donations VALUES
(1, 'John Doe', 'Cash', 500.00, NULL, '2023-06-15 10:30:00'),
(2, 'Jane Smith', 'Item', 0.00, 'Pet Food', '2023-07-20 14:00:00');
-- Insert into AdoptionEvents
INSERT INTO AdoptionEvents VALUES
(1, 'Summer Pet Fair', '2024-07-01 11:00:00', 'Chennai'),
(2, 'Paws for Love', '2024-08-15 10:00:00', 'Coimbatore');
-- Insert into Participants
INSERT INTO Participants VALUES
(1, 'Happy Tails Shelter', 'Shelter', 1),
(2, 'Safe Haven Pets', 'Shelter', 2),
(3, 'Ravi Kumar', 'Adopter', 1),
(4, 'Sneha R', 'Adopter', 2);
-- Insert into Adoption 
INSERT INTO Adoption VALUES
(1, 2, 1, 1);
--CONDITIONS
select * from Pets;
SELECT Name, Age, Breed, Type FROM  Pets WHERE AvailableForAdoption = 0;

SELECT ParticipantName, ParticipantType
FROM Participants
WHERE EventID = 1;

-- Create the procedure
CREATE PROCEDURE UpdateShelterInfo
    @ShelterID INT,
    @NewName VARCHAR(50),
    @NewLocation VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Shelters WHERE ShelterID = @ShelterID)
    BEGIN
        UPDATE Shelters
        SET Name = @NewName,
            Location = @NewLocation
        WHERE ShelterID = @ShelterID;

        PRINT 'Shelter updated successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Shelter ID not found.';
    END
END;
GO

SELECT Name, Age, Breed, Type
FROM Pets
WHERE OwnerID IS NULL; 

SELECT FORMAT(DonationDate, 'MMMM yyyy') AS MonthYear,
       SUM(DonationAmount) AS TotalDonation
FROM Donations
GROUP BY FORMAT(DonationDate, 'MMMM yyyy');;


SELECT DISTINCT Breed
FROM Pets
WHERE (Age BETWEEN 1 AND 3) OR Age > 5;

SELECT P.Name, S.Name AS ShelterName
FROM Pets P
JOIN Shelters S ON P.ShelterID = S.ShelterID
WHERE P.AvailableForAdoption = 1;

SELECT COUNT(*) AS TotalParticipants
FROM Participants P
JOIN AdoptionEvents A ON P.EventID = A.EventID
WHERE A.Location = 'Chennai';

SELECT DISTINCT Breed
FROM Pets
WHERE Age BETWEEN 1 AND 5;

SELECT *
FROM Pets
WHERE AvailableForAdoption = 1;

SELECT P.Name AS PetName, U.UserName AS Adopter 
FROM Adoption A JOIN Pets P ON A.PetID = P.PetID JOIN Users U ON A.UserID = U.UserID;

SELECT S.Name, COUNT(*) AS AvailablePets
FROM Pets P
JOIN Shelters S ON P.ShelterID = S.ShelterID
WHERE P.AvailableForAdoption = 1
GROUP BY S.Name;

SELECT P1.Name AS Pet1, P2.Name AS Pet2, P1.Breed, P1.ShelterID
FROM Pets P1
JOIN Pets P2 ON P1.Breed = P2.Breed AND P1.ShelterID = P2.ShelterID AND P1.PetID < P2.PetID;

SELECT S.Name AS ShelterName, A.EventName
FROM Shelters S
CROSS JOIN AdoptionEvents A;

SELECT ShelterID, COUNT(*) AS TotalAdoptions
FROM Adoption
GROUP BY ShelterID
ORDER BY TotalAdoptions DESC;
