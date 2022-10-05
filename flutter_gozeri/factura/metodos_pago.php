<?php 
	ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
    include('../conex.php');

    $select = $conexion->query("SELECT * FROM tblformaspago_pred WHERE ID_PAGO_PRED != 0 AND TIPO IN (1)");
    $clients = array(); $i = 0;
    while ($row = $select->fetch(PDO::FETCH_ASSOC)) {
        $clients[$i]["id"] = $row["ID_PAGO_PRED"];
        $clients[$i]["forma"] = $row["FORMA"];
        $i++;
    }
    
    echo json_encode($clients);
 ?>