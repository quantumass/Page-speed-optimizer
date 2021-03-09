<?php

    // - identify the problem in the caisses
    // - fix the commands
    // - fix the caisse operations

    $servername = "localhost";
    $username = "root";
    $password = "123456789";

    // SELECT `CONSTRAINT_NAME`, `TABLE_SCHEMA`, `TABLE_NAME` FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE `REFERENCED_TABLE_NAME` LIKE "%_OLD"

    // ALTER TABLE `AshaircareMicroCaisse`.`BilletOperation` DROP FOREIGN KEY `fk:37d6c802b11c73c73749cea544c2df84d71d9089`;

    // Create connection
    $connection = new mysqli($servername, $username, $password);

    // Check connection
    if ($connection->connect_error) {
        die("Connection failed: " . $connection->connect_error);
    }

    echo("Connected successfully \n");

    $duplicated = json_decode(file_get_contents(getcwd() . "/duplicated.json"), true);

    array_map(function($table) use ($duplicated, $connection) {

        if (strpos($table, "FastFoodMicro") !== 0) return null;

        echo("\n WORKING ON " . $table);

        // $localKeys = $duplicated[$table];
        $connection->query("DROP TABLE IF EXISTS " . $table . "_CLONE")  or die($connection->error);

        $connection->query("CREATE TABLE IF NOT EXISTS " . $table . "_CLONE LIKE " . $table . ";")  or die($connection->error);

        // $connection->query("LOCK TABLES " . $table . " WRITE," . $table . "_CLONE  WRITE")  or die($connection->error);

        $deletedAtCheck = $connection->query("SHOW COLUMNS FROM " . $table . " LIKE 'deletedAt'");
        $isDeletedAtexists = (mysqli_num_rows($deletedAtCheck)) ? TRUE : FALSE;

        $uniqueKey = "er_localkey_composite_uq";

        if ($isDeletedAtexists) {
            $connection->query("CREATE UNIQUE INDEX " . $uniqueKey . " ON " . $table . "_CLONE (localKey, (CASE WHEN deletedAt IS NULL THEN '0' END))") or die($connection->error);
        } else {
            $slugedDeletedAtCheck = $connection->query("SHOW COLUMNS FROM " . $table . " LIKE 'deleted_at'");
            $isSlugedDeletedAtexists = (mysqli_num_rows($slugedDeletedAtCheck)) ? TRUE : FALSE;
            if ($isSlugedDeletedAtexists) {
                $connection->query("CREATE UNIQUE INDEX " . $uniqueKey . " ON " . $table . "_CLONE (localKey, (CASE WHEN deleted_at IS NULL THEN '0' END))") or die($connection->error);
            } else {
                $connection->query("CREATE UNIQUE INDEX " . $uniqueKey . " ON " . $table . "_CLONE (localKey)") or die($connection->error);
            }
        }

        $connection->query("INSERT IGNORE INTO " . $table . "_CLONE SELECT * FROM " . $table) or die($connection->error);
        $connection->query("ALTER TABLE " . $table . " RENAME TO " . $table . "_OLD;") or die($connection->error);
        $connection->query("ALTER TABLE " . $table . "_CLONE RENAME TO " . $table . ";") or die($connection->error);

        $connection->query("UNLOCK TABLES;") or die($connection->error);

    }, array_keys($duplicated));