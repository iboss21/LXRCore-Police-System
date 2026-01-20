--[[
    ██╗     ██╗  ██╗██████╗  ██████╗ ██████╗ ██████╗ ███████╗
    ██║     ╚██╗██╔╝██╔══██╗██╔════╝██╔═══██╗██╔══██╗██╔════╝
    ██║      ╚███╔╝ ██████╔╝██║     ██║   ██║██████╔╝█████╗  
    ██║      ██╔██╗ ██╔══██╗██║     ██║   ██║██╔══██╗██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║╚██████╗╚██████╔╝██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
                                                              
    🐺 The Land of Wolves - LXRCore Police System
    "Professional Law Enforcement & Management System"
    
    Version: 1.0.0
    Author: iBoss
    Website: www.wolves.land
    Server: The Land of Wolves
    
    SQL MIGRATION - JOURNAL & LEDGER SYSTEM
    Simplified, period-accurate database schema for 1899 law enforcement.
    Replaces complex modern MDT tables with simple ledger-style records.
    
    © 2026 iBoss | The Land of Wolves | www.wolves.land
    License: All Rights Reserved
]]

-- ══════════════════════════════════════════════════════════════
-- JOURNAL SYSTEM - Officer's Personal Notes
-- ══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `leo_journal_entries` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `officer_id` VARCHAR(50) NOT NULL,
    `note` TEXT NOT NULL,
    `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_officer` (`officer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ══════════════════════════════════════════════════════════════
-- CITIZEN LEDGER - Simplified Record Book
-- ══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `leo_citizens` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `date_of_birth` DATE DEFAULT NULL,
    `last_known_address` VARCHAR(255) DEFAULT NULL,
    `notes` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `idx_identifier` (`identifier`),
    INDEX `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ══════════════════════════════════════════════════════════════
-- ARREST RECORDS - Station Ledger Entries
-- ══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `leo_arrests` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizen_id` INT(11) NOT NULL,
    `officer_id` VARCHAR(50) NOT NULL,
    `station` VARCHAR(50) NOT NULL,
    `charges` TEXT NOT NULL,
    `jail_time` INT(11) DEFAULT 0,
    `fine` INT(11) DEFAULT 0,
    `date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `released` TINYINT(1) DEFAULT 0,
    PRIMARY KEY (`id`),
    INDEX `idx_citizen` (`citizen_id`),
    INDEX `idx_station` (`station`),
    INDEX `idx_date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ══════════════════════════════════════════════════════════════
-- WARRANTS - Active Legal Orders
-- ══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `leo_warrants` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizen_id` INT(11) NOT NULL,
    `issuing_officer` VARCHAR(50) NOT NULL,
    `station` VARCHAR(50) NOT NULL,
    `charges` TEXT NOT NULL,
    `bail_amount` INT(11) DEFAULT 0,
    `status` ENUM('active', 'served', 'dismissed') DEFAULT 'active',
    `issue_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `served_date` TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_citizen_status` (`citizen_id`, `status`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ══════════════════════════════════════════════════════════════
-- WANTED POSTERS - Physical Bulletin Board Items
-- ══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `leo_wanted_posters` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizen_id` INT(11) NOT NULL,
    `bounty` INT(11) DEFAULT 0,
    `crimes` TEXT NOT NULL,
    `station` VARCHAR(50) NOT NULL,
    `status` ENUM('active', 'captured', 'removed') DEFAULT 'active',
    `date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_citizen_status` (`citizen_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ══════════════════════════════════════════════════════════════
-- EVIDENCE STORAGE - Physical Evidence Tracking
-- ══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `leo_evidence_storage` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `case_number` VARCHAR(50) NOT NULL,
    `station` VARCHAR(50) NOT NULL,
    `container` VARCHAR(50) NOT NULL,
    `item_description` TEXT NOT NULL,
    `collected_by` VARCHAR(50) NOT NULL,
    `collection_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `status` ENUM('stored', 'court', 'destroyed') DEFAULT 'stored',
    PRIMARY KEY (`id`),
    INDEX `idx_case` (`case_number`),
    INDEX `idx_station` (`station`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ══════════════════════════════════════════════════════════════
-- AUDIT LOG - Security Tracking (Optimized)
-- ══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `leo_audit_log` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `officer_id` VARCHAR(50) NOT NULL,
    `action` VARCHAR(50) NOT NULL,
    `target_type` VARCHAR(50) DEFAULT NULL,
    `target_id` INT(11) DEFAULT NULL,
    `details` TEXT DEFAULT NULL,
    `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_officer_action` (`officer_id`, `action`),
    INDEX `idx_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ══════════════════════════════════════════════════════════════
-- DUTY ROSTER - Officer Attendance
-- ══════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `leo_roster` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `officer_id` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `department` VARCHAR(50) NOT NULL,
    `grade` INT(11) DEFAULT 0,
    `last_seen` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `total_arrests` INT(11) DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `idx_officer` (`officer_id`),
    INDEX `idx_department` (`department`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ══════════════════════════════════════════════════════════════
-- PERFORMANCE OPTIMIZATION INDICES
-- ══════════════════════════════════════════════════════════════

-- Additional composite indices for common queries
ALTER TABLE `leo_arrests` ADD INDEX `idx_citizen_date` (`citizen_id`, `date`);
-- Note: MySQL doesn't support filtered indexes. Use views or application-level filtering for active warrants.
ALTER TABLE `leo_audit_log` ADD INDEX `idx_recent_actions` (`timestamp` DESC, `action`);

-- ══════════════════════════════════════════════════════════════
-- CLEANUP OLD MDT TABLES (OPTIONAL - Backup first!)
-- ══════════════════════════════════════════════════════════════

-- Uncomment these if you want to remove old MDT tables after migration
-- Make sure to backup your data first!

-- DROP TABLE IF EXISTS `mdt_citizens`;
-- DROP TABLE IF EXISTS `mdt_reports`;
-- DROP TABLE IF EXISTS `mdt_warrants`;
-- DROP TABLE IF EXISTS `mdt_arrests`;
-- DROP TABLE IF EXISTS `mdt_convictions`;
-- DROP TABLE IF EXISTS `mdt_evidence`;
-- DROP TABLE IF EXISTS `mdt_dispatch`;
-- DROP TABLE IF EXISTS `mdt_audit`;
-- DROP TABLE IF EXISTS `mdt_officer_notes`;
-- DROP TABLE IF EXISTS `mdt_citizen_files`;
-- DROP TABLE IF EXISTS `mdt_bounties`;
