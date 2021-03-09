-- MySQL Error: Too many connections
USE `information_schema`;
SELECT host,count(host) FROM processlist GROUP BY host;