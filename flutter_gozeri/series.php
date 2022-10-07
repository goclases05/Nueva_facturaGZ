<?php
    ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	error_reporting(E_ALL);

	include('conex.php');

    $sel=$conexion->query("SELECT ID_SERIE, SERIE FROM bgzeri_empresa.tblfacturas_series WHERE ID_SUCURSAL='$sucursal'");
    $row=$sel->fetchAll();
    $matriz=[];
    $matriz2=[];
    foreach($row as $key){
        $matriz['ID_SERIE']=$key['ID_SERIE'];
        $matriz['NOMBRE']=$key['SERIE'];
        $matriz2[]=$matriz;
    }
    ECHO json_encode($matriz2);
    

?>