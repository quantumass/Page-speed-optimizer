<?php

    ///SELECT `calendarDayEntityId`, `modePaymentId`, `caisseOperationTypeId`, COUNT(*) FROM `CaisseOperation` WHERE `caisseOperationTypeId` IN (10,14,11) AND `deletedAt` IS NULL GROUP BY `calendarDayEntityId`, `caisseOperationTypeId`, `modePaymentId` HAVING COUNT(*) > 1

    $servername = "localhost";
    $username = "root";
    $password = "123456789";

    // Create connection
    $connection = new mysqli($servername, $username, $password);

    // Check connection
    if ($connection->connect_error) {
        die("Connection failed: " . $connection->connect_error);
    }

    echo("Connected successfully \n");

    $duplicated = json_decode(file_get_contents(getcwd() . "/duplicated.json"), true);

    array_map(function($table) use ($duplicated, $connection) {

        $database = explode(".", $table)[0];
        if ($database !== "FastFoodMicroCaisse") return null;

        echo("\n WORKING ON " . $table);

        $connection->query("USE $database;") or die($connection->error);

        $query = $connection->query("SELECT MAX(`id`) AS `id`, GROUP_CONCAT(`id`) AS `duplicatedIds`, `calendarDayEntityId`, `modePaymentId`, `caisseOperationTypeId`, COUNT(*) FROM `CaisseOperation` WHERE `caisseOperationTypeId` IN (10, 14, 11) AND `deletedAt` IS NULL GROUP BY `calendarDayEntityId`, `caisseOperationTypeId`, `modePaymentId` HAVING COUNT(*) > 1") or die($connection->error);

        while($row = $query->fetch_assoc()) {

            $connection->query("UPDATE `CaisseOperation` SET `deletedAt` = '2021-03-06 15:12:06.444444' WHERE `calendarDayEntityId` = " . $row["calendarDayEntityId"] . " AND `modePaymentId` = " . $row["modePaymentId"] . " AND `caisseOperationTypeId` = " . $row["caisseOperationTypeId"] . " AND `id` != " . $row["id"] . " ");

            $connection->query("UPDATE `BilletOperation` SET `deletedAt` = '2021-03-06 15:12:06.444444' WHERE `caisseOperationId` IN (" . $row["duplicatedIds"] . ") AND `caisseOperationId` != " . $row["id"] . " ");

            echo (" \n CALENDAR DAY ENTITY ID IS " . $row["calendarDayEntityId"]);

        }

    }, array_keys($duplicated));