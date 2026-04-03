CREATE TABLE IF NOT EXISTS analyses (
    id SERIAL PRIMARY KEY,
    log_text TEXT NOT NULL,
    root_cause TEXT NOT NULL,
    suggestion TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
