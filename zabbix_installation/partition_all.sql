DELIMITER $$
CREATE PROCEDURE `partition_maintenance_all`(SCHEMA_NAME VARCHAR(32))
BEGIN
    CALL partition_maintenance(SCHEMA_NAME, 'history', 24, 720, 12);
    CALL partition_maintenance(SCHEMA_NAME, 'history_log', 24, 720, 12);
    CALL partition_maintenance(SCHEMA_NAME, 'history_str', 24, 720, 12);
    CALL partition_maintenance(SCHEMA_NAME, 'history_text', 24, 720, 12);
    CALL partition_maintenance(SCHEMA_NAME, 'history_uint', 24, 720, 12);
    CALL partition_maintenance(SCHEMA_NAME, 'trends', 48, 720, 12);
    CALL partition_maintenance(SCHEMA_NAME, 'trends_uint', 48, 720, 12);
END$$
DELIMITER ;
