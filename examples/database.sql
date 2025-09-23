CREATE DATABASE nextcloud;
CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
