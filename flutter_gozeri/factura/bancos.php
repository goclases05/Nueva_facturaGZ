<?php
    ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	error_reporting(E_ALL);

	include('../conex.php');

    $sel=$conexion->query("SELECT * FROM bgzeri_bank.tblbank WHERE ID_EMPRESA = '$empresa' AND ID_BANK NOT IN (67,68,69,70,71)");
    $row=$sel->fetchAll();
    $matriz=[];
    $matriz2=[];
    foreach($row as $key){
        $matriz['ID_BANK']=$key['ID_BANK'];
        $matriz['ID_MONEDA']=$key['ID_MONEDA'];
        $matriz['CUENTA']=$key['CUENTA'];
        $matriz['NO_CUENTA']=$key['NO_CUENTA'];
        $matriz['BANCO']=$key['BANCO'];
        $matriz['FECHA']=$key['FECHA'];
        $matriz['VOUCHER']=$key['ID_BANK'];
        $matriz['ESTADO']=$key['ID_BANK'];

        $matriz2[]=$matriz;
    }
    ECHO json_encode($matriz2);
    

?>