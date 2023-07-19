-- Create the replica_user with the appropriate permissions for replication
DROP USER IF EXISTS 'replica_user'@'%';

CREATE USER 'replica_user'@'%' IDENTIFIED WITH mysql_native_password BY '420hbtn69';
GRANT REPLICATION SLAVE ON *.* TO 'replica_user'@'%';
FLUSH PRIVILEGES;

-- Grant SELECT privileges on mysql.user table to holberton_user
GRANT SELECT ON mysql.user TO 'holberton_user'@'localhost';
