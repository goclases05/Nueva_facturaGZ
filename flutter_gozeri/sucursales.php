<?php
    ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	error_reporting(E_ALL);

	include('conex.php');

    $sel=$conexion->query("SELECT ID_SUCURSAL, NOMBRE FROM bgzeri_empresa.tblsucursales WHERE ID_EMPRESA='$empresa'");
    $row=$sel->fetchAll();
    $matriz=[];
    $matriz2=[];
    foreach($row as $key){
        $matriz['ID_SUCURSAL']=$key['ID_SUCURSAL'];
        $matriz['NOMBRE']=$key['NOMBRE'];
        $matriz2[]=$matriz;
    }
    ECHO json_encode($matriz2);
    

?>