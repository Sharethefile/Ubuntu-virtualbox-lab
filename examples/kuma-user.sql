CREATE DATABASE uptimekuma;
CREATE USER 'uptimekumauser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON uptimekuma.* TO 'uptimekumauser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
