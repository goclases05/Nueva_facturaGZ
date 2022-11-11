<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include('../conex.php');

$query_fact=$conexion->query("DELETE FROM bgzeri_empresa.tblfacturas_det_tmp WHERE ID_FACT_TMP='$id_tmp' AND ID_TMP='$id_item';");

if($query_fact){
    echo 'OK';
}else{
    echo 'ERROR';
}


?>