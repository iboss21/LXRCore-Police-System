-- K9 Dog System Database Tables

CREATE TABLE IF NOT EXISTS `leo_k9_data` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL,
    `breed` VARCHAR(50) DEFAULT 'bloodhound',
    `level` INT(11) DEFAULT 1,
    `xp` INT(11) DEFAULT 0,
    `health` INT(11) DEFAULT 100,
    `stamina` INT(11) DEFAULT 100,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `leo_k9_activity` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL,
    `activity_type` ENUM('track', 'search', 'attack', 'spawn', 'dismiss') NOT NULL,
    `success` TINYINT(1) DEFAULT 0,
    `xp_gained` INT(11) DEFAULT 0,
    `location` VARCHAR(255) DEFAULT NULL,
    `details` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `activity_type` (`activity_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
