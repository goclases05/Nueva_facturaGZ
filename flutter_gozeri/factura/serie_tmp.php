<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

include('../conex.php');

if($accion=='read'){
    $query=$conexion->query("SELECT ID_SERIE FROM bgzeri_empresa.tblfacturas_list_temp WHERE ID_FACT_TMP='$tmp'");
    $data=$query->fetch(PDO::FETCH_ASSOC);
    if(empty($data['ID_SERIE'])){
        echo '0';
    }else{
        echo $data['ID_SERIE'];
    }
}else if($accion=='add'){
    $query=$conexion->query("UPDATE bgzeri_empresa.tblfacturas_list_temp SET `ID_SERIE` = '$serie' WHERE `tblfacturas_list_temp`.`ID_FACT_TMP` = '$tmp';");
    
    if($query){
        echo '1';
    }else{
        echo 'Error: No se pudo asignar serie';
    }
}



?>