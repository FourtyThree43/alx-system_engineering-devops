-- Create the database tyrell_corp
CREATE DATABASE IF NOT EXISTS tyrell_corp;

-- Use the tyrell_corp database
USE tyrell_corp;

-- Create the table nexus6
CREATE TABLE IF NOT EXISTS nexus6 (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255),
);

-- Insert at least one entry into the nexus6 table
INSERT INTO nexus6 (name) VALUES ('Leon');

-- Grant SELECT permissions to holberton_user on the nexus6 table
GRANT SELECT ON tyrell_corp.nexus6 TO 'holberton_user'@'localhost';

-- Make sure the table contains data
SELECT * FROM nexus6;

