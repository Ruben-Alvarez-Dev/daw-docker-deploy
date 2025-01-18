CREATE DATABASE IF NOT EXISTS daw_db;
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';
GRANT ALL PRIVILEGES ON daw_db.* TO 'root'@'%';
FLUSH PRIVILEGES;
