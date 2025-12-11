CREATE TABLE IF NOT EXISTS mdt_bounties (
    id INT AUTO_INCREMENT PRIMARY KEY,
    poster_id VARCHAR(20) NOT NULL UNIQUE,
    identifier VARCHAR(64) NOT NULL,
    name VARCHAR(128) NOT NULL,
    bounty INT NOT NULL DEFAULT 0,
    crimes TEXT,
    description TEXT,
    placed_by INT NOT NULL,
    placed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active','claimed','expired') DEFAULT 'active',
    captured_by INT NULL,
    captured_at DATETIME NULL,
    reward_paid INT NULL,
    INDEX(identifier),
    INDEX(status),
    INDEX(placed_by)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
