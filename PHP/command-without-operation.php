<?php

    ///SELECT * FROM `FastFoodMicroCommand`.`CmdClient` WHERE `deletedAt` IS NULL AND `id` NOT IN (SELECT `commandClientId` FROM `FastFoodMicroCaisse`.`CaisseOperationCommandClient`) ORDER BY `CmdClient`.`localCreatedAt` DESC

    // Create connection
    $connection = new mysqli($servername, $username, $password);

    // Check connection
    if ($connection->connect_error) {
        die("Connection failed: " . $connection->connect_error);
    }

    echo("Connected successfully \n");

    array_map(function($table) use ($duplicated, $connection) {

        $database = explode(".", $table)[0];
        if ($database !== "FastFoodMicroCommand") return null;

        $caisseDatabase = str_replace("Command", "Caisse", $database);

        echo("\n WORKING ON " . $table);

        $connection->query("USE $database;") or die($connection->error);

        $query = $connection->query("SELECT * FROM `" . $database . "`.`CmdClient` WHERE `" . $database . "`.`CmdClient`.`deletedAt` IS NULL AND `" . $database . "`.`CmdClient`.`id` NOT IN (SELECT `commandClientId` FROM `" . $caisseDatabase . "`.`CaisseOperationCommandClient`) ORDER BY `" . $database . "`.`localCreatedAt` DESC") or die($connection->error);

        while($row = $query->fetch_assoc()) {

            $keys = explode("-",$row["localKey"]);
            if(sizeOf($keys) == 3) {

                $deviceId = $keys[0];

                $operationQuery = $connection->query("SELECT `calendarDayEntityId` FROM `" . $caisseDatabase . "`.`CaisseOperation` WHERE `localKey` LIKE '" . $deviceId . "-%' AND `caisseOperationTypeId` = 10 AND `localCreatedAt` < '" . $row["localCreatedAt"] . "' AND `deletedAt` IS NULL ORDER BY `localCreatedAt` DESC LIMIT 1") or die($connection->error);

                $operation = $operationQuery->fetch_object();

                if ($operation) {
                    $connection->query("INSERT INTO `CmdClientExtension` (`id`, `cmdClientId`, `total`, `paymentModes`, `unknownInformations`, `created_at`, `updated_at`) VALUES (NULL, " . $row["id"] . ", '0', '{}', '{calendarDayEntityId: '" . $operation["calendarDayEntityId"] . "'}', NOW(), NOW())") or die($connection->error);
                } else {
                    echo("There is no openning with this criteria " . "`localKey` LIKE '" . $deviceId . "-%' AND `caisseOperationTypeId` = 10 AND `localCreatedAt` < '" . $row["localCreatedAt"] . "' AND `deletedAt` IS NULL");
                }

            }

        }

    }, array_keys($duplicated));