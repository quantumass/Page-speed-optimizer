<?php

    // - identify the problem in the caisses
    // - fix the commands
    // - fix the caisse operations

    $servername = "localhost";
    $username = "root";
    $password = "123456789";

    // Create connection
    $connection = new mysqli($servername, $username, $password);

    // Check connection
    if ($connection->connect_error) {
        die("Connection failed: " . $connection->connect_error);
    }

    file_put_contents('php://stderr', "Connected successfully");

    $query = $connection->query("SELECT `TABLE_SCHEMA`, `TABLE_NAME` FROM `INFORMATION_SCHEMA`.`COLUMNS` WHERE `COLUMN_NAME` LIKE 'localKey'") or die($connection->error);

    $duplicated = [];

    while($row = $query->fetch_assoc()) {

        $table = $row["TABLE_SCHEMA"] . "." . $row["TABLE_NAME"];

        $deletedAtCheck = $connection->query("SHOW COLUMNS FROM " . $table . " LIKE 'deletedAt'");
        $isDeletedAtexists = (mysqli_num_rows($deletedAtCheck)) ? TRUE : FALSE;

        $whereQuery = "";
        if ($isDeletedAtexists) {
            $whereQuery = "WHERE `deletedAt` IS NULL";
        } else {
            $slugedDeletedAtCheck = $connection->query("SHOW COLUMNS FROM " . $table . " LIKE 'deleted_at'");
            $isSlugedDeletedAtexists = (mysqli_num_rows($slugedDeletedAtCheck)) ? TRUE : FALSE;
            if ($isSlugedDeletedAtexists) {
                $whereQuery = "WHERE `deleted_at` IS NULL";
            } else {
                $whereQuery = "";
            }
        }

        $localKeyQuery = $connection->query("SELECT `localKey` FROM " . $table . " " . $whereQuery ." GROUP BY `localKey` HAVING COUNT(`localKey`) > 1")  or die($connection->error);

        $localKeys = [];

        while($localKeyRow = $localKeyQuery->fetch_assoc())
            array_push($localKeys, $localKeyRow["localKey"]);

        if (sizeOf($localKeys) > 0)
            $duplicated[$table] = $localKeys;

    }

    file_put_contents('php://stderr', print_r(json_encode($duplicated), TRUE));

?>
