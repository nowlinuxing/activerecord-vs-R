-- Create "test_data" table
DROP TABLE IF EXISTS `test_data`;
CREATE TABLE `test_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- Create test records
DROP PROCEDURE IF EXISTS createData;

DELIMITER //
CREATE PROCEDURE createData () 
BEGIN
  DECLARE i INT DEFAULT 0;

  START TRANSACTION;
  WHILE i < 100000 DO
    INSERT INTO `test_data` (`id`, `value`) VALUES (NULL, 2.0 * (RAND() - 0.5));
    SET i = i + 1;
  END WHILE;
  COMMIT;
END //
DELIMITER ;

CALL createData();
DROP PROCEDURE createData;

-- Create "SMAs" table
DROP TABLE IF EXISTS `smas`;
CREATE TABLE `smas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
