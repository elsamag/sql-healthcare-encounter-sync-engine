-- ============================================================================
-- ENTERPRISE PRACTICE: Elsamag IT Solutions
-- AUTHOR & LEAD TECHNICAL CONSULTANT: Samuel Chinwendu Agu
-- REPOSITORY: sql-healthcare-encounter-sync-engine
-- OPERATIONAL NICHE: Healthcare (Patient Profile & Clinic Visit Log Synchronization)
-- ANALYTICAL LENS: Senior Health Informatics BI Architect
-- FILE TARGET: src/sync_patient_encounters.sql
-- OBJECTIVE: Synchronize verified patient demographics with transactional
--            clinical encounter records using optimized ANSI INNER JOIN.
-- ============================================================================

SELECT
    e.encounter_id,
    p.patient_id,
    p.first_name || ' ' || p.last_name AS patient_full_name,
    p.date_of_birth,
    p.gender,
    e.encounter_date,
    e.department_name,
    e.provider_id,
    e.diagnosis_code,
    e.encounter_type
FROM
    patients AS p
INNER JOIN
    clinical_encounters AS e
    ON p.patient_id = e.patient_id
WHERE
    e.status = 'COMPLETED'
    AND p.record_status = 'ACTIVE'
ORDER BY
    e.encounter_date DESC,
    e.encounter_id ASC;
