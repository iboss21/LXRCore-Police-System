-- Enhanced MDT System - Additional Fields and Tables
-- Migration: 013_mdt_enhancements.sql

-- Enhance mdt_reports table with additional fields
ALTER TABLE mdt_reports
ADD COLUMN IF NOT EXISTS title VARCHAR(255) DEFAULT NULL AFTER report_type,
ADD COLUMN IF NOT EXISTS location VARCHAR(255) DEFAULT NULL AFTER description,
ADD COLUMN IF NOT EXISTS charges TEXT DEFAULT NULL AFTER location,
ADD COLUMN IF NOT EXISTS updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
ADD COLUMN IF NOT EXISTS updated_by INT DEFAULT NULL,
ADD INDEX IF NOT EXISTS idx_report_type (report_type),
ADD INDEX IF NOT EXISTS idx_created_at (created_at),
ADD INDEX IF NOT EXISTS idx_citizen_id (citizen_id);

-- Enhance mdt_warrants table with additional fields
ALTER TABLE mdt_warrants
ADD COLUMN IF NOT EXISTS issued_by INT DEFAULT NULL AFTER officer_id,
ADD COLUMN IF NOT EXISTS warrant_type VARCHAR(50) DEFAULT 'arrest' AFTER citizen_id,
ADD COLUMN IF NOT EXISTS charges TEXT DEFAULT NULL AFTER description,
ADD COLUMN IF NOT EXISTS bail_amount INT DEFAULT 0 AFTER charges,
ADD COLUMN IF NOT EXISTS issued_at DATETIME DEFAULT CURRENT_TIMESTAMP AFTER status,
ADD COLUMN IF NOT EXISTS executed_at DATETIME DEFAULT NULL,
ADD COLUMN IF NOT EXISTS executed_by INT DEFAULT NULL,
ADD INDEX IF NOT EXISTS idx_warrant_type (warrant_type),
ADD INDEX IF NOT EXISTS idx_issued_at (issued_at);

-- Enhance mdt_citizens table with additional fields
ALTER TABLE mdt_citizens
ADD COLUMN IF NOT EXISTS date_of_birth DATE DEFAULT NULL AFTER name,
ADD COLUMN IF NOT EXISTS gender ENUM('male','female','unknown') DEFAULT 'unknown' AFTER date_of_birth,
ADD COLUMN IF NOT EXISTS address VARCHAR(255) DEFAULT NULL AFTER gender,
ADD COLUMN IF NOT EXISTS phone VARCHAR(20) DEFAULT NULL AFTER address,
ADD COLUMN IF NOT EXISTS licenses TEXT DEFAULT NULL AFTER phone,
ADD COLUMN IF NOT EXISTS tags TEXT DEFAULT NULL AFTER licenses,
ADD COLUMN IF NOT EXISTS created_at DATETIME DEFAULT CURRENT_TIMESTAMP AFTER last_seen,
ADD COLUMN IF NOT EXISTS updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP;

-- Create citizen files/attachments table
CREATE TABLE IF NOT EXISTS mdt_citizen_files (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizen_id INT NOT NULL,
    file_type ENUM('document','photo','note','report','evidence') DEFAULT 'note',
    title VARCHAR(255) NOT NULL,
    content TEXT,
    file_url TEXT,
    uploaded_by INT NOT NULL,
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (citizen_id) REFERENCES mdt_citizens(id) ON DELETE CASCADE,
    INDEX idx_citizen_id (citizen_id),
    INDEX idx_file_type (file_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create arrest records table
CREATE TABLE IF NOT EXISTS mdt_arrests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizen_id INT NOT NULL,
    officer_id INT NOT NULL,
    report_id INT DEFAULT NULL,
    arrest_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    location VARCHAR(255),
    charges TEXT NOT NULL,
    bail_amount INT DEFAULT 0,
    fine_amount INT DEFAULT 0,
    jail_time INT DEFAULT 0,
    plea ENUM('not_entered','guilty','not_guilty','no_contest') DEFAULT 'not_entered',
    conviction_status ENUM('pending','convicted','acquitted','dismissed') DEFAULT 'pending',
    conviction_date DATETIME DEFAULT NULL,
    notes TEXT,
    FOREIGN KEY (citizen_id) REFERENCES mdt_citizens(id),
    FOREIGN KEY (officer_id) REFERENCES mdt_citizens(id),
    FOREIGN KEY (report_id) REFERENCES mdt_reports(id),
    INDEX idx_arrest_date (arrest_date),
    INDEX idx_conviction_status (conviction_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create wanted posters table (separate from bounties)
CREATE TABLE IF NOT EXISTS mdt_wanted_posters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    poster_number VARCHAR(20) NOT NULL UNIQUE,
    citizen_id INT NOT NULL,
    created_by INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    charges TEXT NOT NULL,
    reward_amount INT DEFAULT 0,
    danger_level ENUM('low','medium','high','extreme') DEFAULT 'medium',
    last_known_location VARCHAR(255),
    physical_description TEXT,
    known_associates TEXT,
    status ENUM('active','captured','expired','cancelled') DEFAULT 'active',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    captured_at DATETIME DEFAULT NULL,
    captured_by INT DEFAULT NULL,
    FOREIGN KEY (citizen_id) REFERENCES mdt_citizens(id),
    FOREIGN KEY (created_by) REFERENCES mdt_citizens(id),
    INDEX idx_status (status),
    INDEX idx_danger_level (danger_level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create case files table
CREATE TABLE IF NOT EXISTS mdt_cases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    case_number VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    case_type ENUM('investigation','criminal','civil','missing_person') DEFAULT 'criminal',
    status ENUM('open','closed','cold','active') DEFAULT 'open',
    priority ENUM('low','medium','high','urgent') DEFAULT 'medium',
    lead_officer INT NOT NULL,
    assigned_officers TEXT,
    suspects TEXT,
    victims TEXT,
    witnesses TEXT,
    evidence_ids TEXT,
    report_ids TEXT,
    opened_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    closed_at DATETIME DEFAULT NULL,
    notes TEXT,
    FOREIGN KEY (lead_officer) REFERENCES mdt_citizens(id),
    INDEX idx_case_number (case_number),
    INDEX idx_status (status),
    INDEX idx_case_type (case_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create vehicles table for MDT
CREATE TABLE IF NOT EXISTS mdt_vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plate VARCHAR(20) NOT NULL UNIQUE,
    owner_id VARCHAR(64),
    vehicle_model VARCHAR(100),
    vehicle_type VARCHAR(50),
    color VARCHAR(50),
    registration_status ENUM('valid','expired','suspended','revoked') DEFAULT 'valid',
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    insurance_status ENUM('valid','expired','none') DEFAULT 'none',
    notes TEXT,
    flags TEXT,
    stolen BOOLEAN DEFAULT FALSE,
    INDEX idx_plate (plate),
    INDEX idx_owner_id (owner_id),
    INDEX idx_stolen (stolen)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create BOLOs (Be On the Lookout) table
CREATE TABLE IF NOT EXISTS mdt_bolos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    created_by INT NOT NULL,
    bolo_type ENUM('person','vehicle','item') DEFAULT 'person',
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    plate VARCHAR(20) DEFAULT NULL,
    suspect_name VARCHAR(128) DEFAULT NULL,
    suspect_description TEXT,
    last_seen_location VARCHAR(255),
    danger_level ENUM('none','low','medium','high','extreme') DEFAULT 'medium',
    status ENUM('active','resolved','expired') DEFAULT 'active',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    resolved_at DATETIME DEFAULT NULL,
    resolved_by INT DEFAULT NULL,
    FOREIGN KEY (created_by) REFERENCES mdt_citizens(id),
    INDEX idx_status (status),
    INDEX idx_bolo_type (bolo_type),
    INDEX idx_plate (plate)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create convictions table (separate from arrests for clarity)
CREATE TABLE IF NOT EXISTS mdt_convictions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizen_id INT NOT NULL,
    arrest_id INT DEFAULT NULL,
    charges TEXT NOT NULL,
    conviction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    sentence TEXT,
    fine_amount INT DEFAULT 0,
    jail_time INT DEFAULT 0,
    probation_months INT DEFAULT 0,
    judge_name VARCHAR(128),
    court_location VARCHAR(255),
    notes TEXT,
    FOREIGN KEY (citizen_id) REFERENCES mdt_citizens(id),
    FOREIGN KEY (arrest_id) REFERENCES mdt_arrests(id),
    INDEX idx_conviction_date (conviction_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Add performance indexes
ALTER TABLE mdt_evidence
ADD INDEX IF NOT EXISTS idx_unique_id (unique_id),
ADD INDEX IF NOT EXISTS idx_created_at (created_at);

ALTER TABLE mdt_bounties
ADD INDEX IF NOT EXISTS idx_name (name),
ADD INDEX IF NOT EXISTS idx_placed_at (placed_at);
