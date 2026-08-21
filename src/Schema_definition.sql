-- ============================================================================
-- ENTERPRISE PRACTICE: Elsamag IT Solutions
-- AUTHOR & LEAD TECHNICAL CONSULTANT: Samuel Chinwendu Agu
-- REPOSITORY: sql-healthcare-encounter-sync-engine
-- FILE PATH: src/schema_definition.sql
-- OPERATIONAL DOMAIN: Healthcare Informatics & EHR Data Synchronization
-- ANALYTICAL LENS: Senior Health Informatics BI Architect
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Schema Cleanup & Environment Isolation
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS clinical_encounters CASCADE;
DROP TABLE IF EXISTS patients CASCADE;

-- ----------------------------------------------------------------------------
-- 2. Master Patient Registry Table (Parent Entity)
-- ----------------------------------------------------------------------------
CREATE TABLE patients (
    patient_id VARCHAR(16) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender CHAR(1) NOT NULL CHECK (gender IN ('M', 'F', 'O')),
    blood_group VARCHAR(5),
    record_status VARCHAR(12) DEFAULT 'ACTIVE' CHECK (record_status IN ('ACTIVE', 'INACTIVE', 'ARCHIVED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 3. Clinical Encounter Transaction Log (Child Entity)
-- ----------------------------------------------------------------------------
CREATE TABLE clinical_encounters (
    encounter_id VARCHAR(20) PRIMARY KEY,
    patient_id VARCHAR(16) NOT NULL,
    encounter_date TIMESTAMP NOT NULL,
    department_name VARCHAR(50) NOT NULL,
    provider_id VARCHAR(16) NOT NULL,
    diagnosis_code VARCHAR(10) NOT NULL,
    encounter_type VARCHAR(20) NOT NULL CHECK (encounter_type IN ('Inpatient', 'Outpatient', 'Emergency', 'Telehealth')),
    status VARCHAR(12) DEFAULT 'COMPLETED' CHECK (status IN ('COMPLETED', 'PENDING', 'CANCELLED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_encounters_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients (patient_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ----------------------------------------------------------------------------
-- 4. Relational Indexing & Join Performance Optimization
-- ----------------------------------------------------------------------------
CREATE INDEX idx_encounters_patient_id 
    ON clinical_encounters (patient_id);

CREATE INDEX idx_encounters_date_status 
    ON clinical_encounters (encounter_date DESC, status);

CREATE INDEX idx_patients_status 
    ON patients (record_status);

-- ----------------------------------------------------------------------------
-- 5. Seed Fixtures & Production Test Data
-- ----------------------------------------------------------------------------
INSERT INTO patients (patient_id, first_name, last_name, date_of_birth, gender, blood_group, record_status) VALUES
('PAT-10482', 'Chioma', 'Adeleke', '1984-06-12', 'F', 'O+', 'ACTIVE'),
('PAT-30911', 'Ibrahim', 'Musa', '1972-11-03', 'M', 'A+', 'ACTIVE'),
('PAT-04289', 'Babatunde', 'Olatunji', '1991-03-25', 'M', 'B+', 'ACTIVE'),
('PAT-88210', 'Ngozi', 'Okafor', '1968-09-17', 'F', 'O-', 'ACTIVE'),
('PAT-15604', 'Emmanuel', 'Eze', '2001-12-08', 'M', 'AB+', 'ACTIVE'),
('PAT-99120', 'Amaka', 'Danladi', '1995-04-19', 'F', 'A-', 'INACTIVE');

INSERT INTO clinical_encounters (encounter_id, patient_id, encounter_date, department_name, provider_id, diagnosis_code, encounter_type, status) VALUES
('ENC-982014', 'PAT-10482', '2026-08-18 14:32:00', 'Cardiology', 'PRV-4402', 'I10', 'Outpatient', 'COMPLETED'),
('ENC-982013', 'PAT-30911', '2026-08-18 14:15:00', 'Endocrinology', 'PRV-1189', 'E11.9', 'Outpatient', 'COMPLETED'),
('ENC-982012', 'PAT-04289', '2026-08-18 13:50:00', 'Emergency Room', 'PRV-9012', 'S82.101A', 'Emergency', 'COMPLETED'),
('ENC-982011', 'PAT-88210', '2026-08-18 13:20:00', 'Internal Medicine', 'PRV-3310', 'J45.909', 'Inpatient', 'COMPLETED'),
('ENC-982010', 'PAT-15604', '2026-08-18 12:45:00', 'Pulmonology', 'PRV-7741', 'J18.9', 'Outpatient', 'COMPLETED'),
('ENC-982009', 'PAT-99120', '2026-08-18 11:10:00', 'General Practice', 'PRV-5520', 'Z00.00', 'Outpatient', 'COMPLETED');
