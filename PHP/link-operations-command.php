<?php

    // SELECT * FROM `FastFoodMicroCaisse`.`CaisseOperationCommandClient` WHERE `FastFoodMicroCaisse`.`CaisseOperationCommandClient`.`commandClientId` NOT IN (SELECT `id` FROM `FastFoodMicroCommand`.`CmdClient`)
    // 1524297,665478,1084464


    ///CREATE TABLE IF NOT EXISTS CaisseOperationCommandClient_OLD LIKE CaisseOperationCommandClient;
    ///INSERT IGNORE INTO CaisseOperationCommandClient_OLD SELECT * FROM `CaisseOperationCommandClient` WHERE `caisseOperationId` NOT IN (SELECT `id` FROM `CaisseOperation`);
    ///DELETE FROM `CaisseOperationCommandClient` WHERE `caisseOperationId` NOT IN (SELECT `id` FROM `CaisseOperation`);

    // 593367/394792, 593372/394794, 593371/394794

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

        $commandDatabase = str_replace("Caisse", "Command", $database);

        echo("\n WORKING ON " . $table);

        $connection->query("USE $database;") or die($connection->error);

        $query = $connection->query("SELECT `caisseOperationId`, `id` FROM `CaisseOperationCommandClient` WHERE `caisseOperationId` NOT IN (SELECT `id` FROM `CaisseOperation`)") or die($connection->error);

        while($row = $query->fetch_assoc()) {


            // $oldOperationQuery = $connection->query("SELECT `localKey` FROM `CaisseOperation_OLD` WHERE `id` = " . $row["caisseOperationId"] . " AND deletedAt IS NULL LIMIT 1") or die($connection->error);

            // $oldOperation = $oldOperationQuery->fetch_object();

            // if ($oldOperation) {
            //     $currentOperationQuery = $connection->query("SELECT `*` FROM `CaisseOperation` WHERE `localKey` = " . $oldOperation["localKey"] . " LIMIT 1") or die($connection->error);
            // } else {
            //     echo("There is no caisse operation with id " . $row["caisseOperationId"]);
            // }

            $keys = explode("-",$row["localKey"]);
            if(sizeOf($keys) == 3) {
                $localKey = $keys[1] . "-" . $keys[2];
                echo("\n localKey " . $localKey);
                $cmdClientQuery = $connection->query("SELECT `id` FROM `" . $commandDatabase . "`.`CmdClient` WHERE `localKey` = '" . $localKey . "' LIMIT 1") or die($connection->error);
                $cmdClient = $cmdClientQuery->fetch_object();
                if ($cmdClient) {
                    echo("\n command id " . $cmdClient->id);
                    $connection->query("UPDATE `" . $database . "`.`CaisseOperationCommandClient` SET `commandClientId` = '". $cmdClient->id ."' WHERE `caisseOperationId` = ". $row["id"] ."") or die($connection->error);
                } else {
                    echo("\n [FAILED] there is no command with localKey " . $localKey);
                }
            } else {
                echo("\n [FAILED] localKey " . $row["localKey"]);
            }
        }

    }, array_keys($duplicated));