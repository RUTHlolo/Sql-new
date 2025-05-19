-- The Aim is to create a database and perform some sql command.
-- Four Entity(tables) would be created with associated attributes (column names or variable) and establish relationship between them
-- Table for Animal bio-data information
CREATE TABLE Animals (
animal_id INTEGER PRIMARY KEY,
name TEXT,
species TEXT,
birth_date DATE,
farm_name TEXT
);

-- Table for clinic visits
CREATE TABLE Visits (
visit_id INTEGER PRIMARY KEY,
animal_id INTEGER,
visit_date DATE,
weight_kg REAL,
notes TEXT,
FOREIGN KEY (animal_id) REFERENCES Animals(animal_id)
);
-- Table for diagnoses
CREATE TABLE Diagnoses (
diagnosis_id INTEGER PRIMARY KEY,
visit_id INTEGER,
condition TEXT,
severity TEXT,
FOREIGN KEY (visit_id) REFERENCES Visits(visit_id)
);
-- Table for treatments
CREATE TABLE Treatments(
    treatment_id   INTEGER PRIMARY KEY,
    diagnosis_id   INTEGER,
    treatment_name TEXT,
    duration_days   INTEGER,
    successful     BOOLEAN,
    FOREIGN KEY (diagnosis_id) REFERENCES Diagnoses (diagnosis_id)
);
-- Inserting dataset
INSERT INTO Animals VALUES
(1, 'Bella', 'Cow', '2020-04-15', 'Quebec Farm'),
(2, 'Max', 'Sheep', '2021-07-01', 'Yoplait Ranch'),
(3, 'Luna', 'Goat', '2019-12-20', ' South Farm');
-- Insert visits
INSERT INTO Visits VALUES
(1, 1, '2024-12-01', 450.5, 'Routine checkup'),
(2, 2, '2025-01-10', 75.0, 'Not Applicable'),
(3, 1, '2025-02-15', 455.0, 'Appetite loss'),
(4, 3, '2025-03-05', 60.2, 'Routine vaccination');
-- Insert diagnoses
INSERT INTO Diagnoses (diagnosis_id, visit_id, condition, severity) VALUES
(1, 1, 'Mastitis', 'Moderate'),
(2, 2, 'Bovine Tuberculosis', 'High'),
(3, 3, 'Lameness', 'Low'),
(4, 4, 'Foot and Mouth Disease', 'Critical');
-- Insert treatments
INSERT INTO Treatments VALUES
(1, 1, 'Antibiotics', 7, TRUE),
(2, 2, 'Probiotics Supplement', 5, TRUE);

-- Explore the dataset using SELECT and other queries command
-- List all the animals
SELECT * FROM Animals;
--List all the unique species in teh animal table
SELECT DISTINCT(a.species) FROM Animals a;
-- View all visits with animal names
SELECT v.*, a.name
FROM VISITS v
JOIN Animals a ON a.animal_id = v.animal_id;
-- View recent visit of animals to the clinic
SELECT v.*, a.name, a.species
FROM Visits v
JOIN Animals a on a.animal_id = v.animal_id
order by v.visit_date;

SELECT v.animal_id, a.name, a.species, v.visit_date, v.notes
FROM Visits v
JOIN Animals a ON a.animal_id = v.animal_id
WHERE v.visit_date = (
    SELECT MAX(v2.visit_date)
    FROM Visits v2
    WHERE v2.animal_id = v.animal_id
);
--List all animals that had more than one clinic visit:
SELECT a.*, COUNT(v.visit_id) as no_visit
FROM Animals a
JOIN Visits v ON a.animal_id = v.animal_id
GROUP BY a.name
HAVING COUNT (v.visit_id) > 1;

SELECT a.name, COUNT(v.visit_id) as visit_count
FROM Animals a
JOIN Visits v ON a.animal_id = v.animal_id
GROUP BY a.name
HAVING COUNT(v.visit_id) > 1;

-- Correct weight entered wrongly for Visit 3 as 460.0
UPDATE Visits
SET weight_kg = 460.0
WHERE visit_id = 3;
--Find the total number of visits.
SELECT COUNT(*) FROM Visits;
--List all diagnoses along with the animal’s name.
SELECT a.name, v.visit_date,v.notes,d.condition,d.severity
FROM Visits v
JOIN Diagnoses d on V.visit_id = D.visit_id
join Animals A on A.animal_id = v.animal_id;
