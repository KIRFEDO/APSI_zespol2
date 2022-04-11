CREATE USER aspi with encrypted password '12345';
DROP DATABASE IF EXISTS aspi_db;
CREATE DATABASE aspi_db;
\c aspi_db;
\i aspi_db.sql;
ALTER DATABASE aspi_db OWNER TO aspi;
