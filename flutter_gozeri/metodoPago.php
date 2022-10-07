<?php
    ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	error_reporting(E_ALL);

	include('conex.php');

    $sel=$conexion->query("SELECT ID_PAGO_PRED, FORMA FROM tblformaspago_pred WHERE TIPO='1'");
    $row=$sel->fetchAll();
    $matriz=[];
    $matriz2=[];
    foreach($row as $key){
        $matriz['ID_PAGO_PRED']=$key['ID_PAGO_PRED'];
        $matriz['FORMA']=$key['FORMA'];
        $matriz2[]=$matriz;
    }
    ECHO json_encode($matriz2);
    

?>