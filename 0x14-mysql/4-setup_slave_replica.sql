-- setup web 2 slave
-- stop the I/O thread for a default replication channel
STOP SLAVE IO_THREAD FOR CHANNEL '';

-- Start Replication on Replica Server (web-02)
CHANGE MASTER TO MASTER_HOST='54.160.120.200', MASTER_USER='replica_user', MASTER_PASSWORD='420hbtn69', MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=XXX;
START SLAVE;
