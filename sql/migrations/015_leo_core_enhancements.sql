-- ══════════════════════════════════════════════════════════════
-- LEO Core Duty Tracking System
-- Migration: 015_leo_core_duty_tracking.sql
-- ══════════════════════════════════════════════════════════════

-- Duty logs table for payroll and audit
CREATE TABLE IF NOT EXISTS `leo_duty_logs` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `officer_id` VARCHAR(50) NOT NULL,
    `duty_start` DATETIME NOT NULL,
    `duty_end` DATETIME DEFAULT NULL,
    `duration` INT(11) DEFAULT 0 COMMENT 'Duration in seconds',
    `status` ENUM('active', 'completed', 'disconnected', 'afk_timeout') DEFAULT 'active',
    `station` VARCHAR(50) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `officer_id` (`officer_id`),
    KEY `duty_start` (`duty_start`),
    KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add approval fields to warrants if not exists
ALTER TABLE `mdt_warrants` 
ADD COLUMN IF NOT EXISTS `approval_type` VARCHAR(20) DEFAULT 'auto' COMMENT 'auto, approved, judge',
ADD COLUMN IF NOT EXISTS `approval_notes` TEXT DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `approved_by` VARCHAR(50) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `approved_at` DATETIME DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `denied_by` VARCHAR(50) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `denied_at` DATETIME DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `denial_notes` TEXT DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `executed_by` INT(11) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `executed_at` DATETIME DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `expires_at` DATETIME DEFAULT NULL;

-- Add indexes for warrant queries
ALTER TABLE `mdt_warrants`
ADD KEY IF NOT EXISTS `status_expires` (`status`, `expires_at`),
ADD KEY IF NOT EXISTS `citizen_status` (`citizen_id`, `status`);

-- Update statutes table if it exists to add new fields
ALTER TABLE IF EXISTS `leo_statutes`
ADD COLUMN IF NOT EXISTS `severity` TINYINT(1) DEFAULT 1 COMMENT '1-5 scale',
ADD COLUMN IF NOT EXISTS `fine_min` INT(11) DEFAULT 0,
ADD COLUMN IF NOT EXISTS `fine_max` INT(11) DEFAULT 0,
ADD COLUMN IF NOT EXISTS `bail_eligible` BOOLEAN DEFAULT TRUE,
ADD COLUMN IF NOT EXISTS `execution_eligible` BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS `mandatory_execution` BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS `description` TEXT DEFAULT NULL;

-- Rate limit tracking (optional, can use in-memory)
CREATE TABLE IF NOT EXISTS `leo_rate_limits` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `player_id` VARCHAR(50) NOT NULL,
    `action_type` VARCHAR(50) NOT NULL,
    `action_count` INT(11) DEFAULT 1,
    `window_start` DATETIME NOT NULL,
    `last_action` DATETIME NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `player_action_window` (`player_id`, `action_type`, `window_start`),
    KEY `last_action` (`last_action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Suspicious activity log
CREATE TABLE IF NOT EXISTS `leo_suspicious_activity` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `player_id` VARCHAR(50) NOT NULL,
    `activity_type` VARCHAR(50) NOT NULL,
    `details` TEXT DEFAULT NULL,
    `timestamp` DATETIME NOT NULL,
    `action_taken` VARCHAR(50) DEFAULT NULL COMMENT 'warn, kick, ban, log',
    PRIMARY KEY (`id`),
    KEY `player_id` (`player_id`),
    KEY `timestamp` (`timestamp`),
    KEY `activity_type` (`activity_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add permission tracking to audit log
ALTER TABLE `leo_audit_log`
ADD COLUMN IF NOT EXISTS `permission` VARCHAR(50) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `on_duty` BOOLEAN DEFAULT NULL;

-- Indexes for performance
ALTER TABLE `leo_audit_log`
ADD KEY IF NOT EXISTS `action_timestamp` (`action`, `timestamp`),
ADD KEY IF NOT EXISTS `permission` (`permission`);

-- Add duty status to roster
ALTER TABLE IF EXISTS `leo_roster`
ADD COLUMN IF NOT EXISTS `duty_status` ENUM('on_duty', 'off_duty', 'afk') DEFAULT 'off_duty',
ADD COLUMN IF NOT EXISTS `duty_start_time` DATETIME DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `last_activity` DATETIME DEFAULT NULL;
