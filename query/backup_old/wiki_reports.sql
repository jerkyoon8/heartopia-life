use heartopia_db;

CREATE TABLE wiki_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    reporter_name VARCHAR(100) NOT NULL,
    reporter_email VARCHAR(100),
    message TEXT NOT NULL,
    source_url VARCHAR(255),
    item_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE wiki_reports ADD COLUMN password VARCHAR(100) NOT NULL;