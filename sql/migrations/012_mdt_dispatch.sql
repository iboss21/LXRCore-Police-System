CREATE TABLE IF NOT EXISTS mdt_dispatch (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dispatch_id VARCHAR(20) NOT NULL UNIQUE,
    type VARCHAR(10) NOT NULL,
    message TEXT NOT NULL,
    location TEXT,
    sender INT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active','responding','completed','cancelled') DEFAULT 'active',
    completed_by INT NULL,
    completed_at DATETIME NULL,
    responding_officers TEXT,
    INDEX(status),
    INDEX(sender),
    INDEX(timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
