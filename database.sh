CREATE USER apsi with encrypted password '12345';
DROP DATABASE IF EXISTS apsi_db;
CREATE DATABASE apsi_db;
\c apsi_db;
\i apsi_db.sql;
ALTER DATABASE apsi_db OWNER TO apsi;
