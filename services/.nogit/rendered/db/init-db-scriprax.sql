CREATE USER scriprax_user WITH PASSWORD 'Sc5t0m_P@ssw0rd_2025!';
CREATE DATABASE scriprax_db OWNER scriprax_user;
GRANT ALL PRIVILEGES ON DATABASE scriprax_db TO scriprax_user;

\c scriprax_db;

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create tables for media files
CREATE TABLE IF NOT EXISTS media_files (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    filepath VARCHAR(255) NOT NULL,
    file_type VARCHAR(50) NOT NULL, -- 'video' or 'screenshot'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Grant permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO scriprax_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO scriprax_user;