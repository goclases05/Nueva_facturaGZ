<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include('../conex.php');

$fecha=date('Y-m-d H:i:s');

if($accion=='add'){
    $select=$conexion->query("SELECT ID_RECIBO_SERIE FROM bgzeri_empresa.tblrecibos_series WHERE ID_SUCURSAL='0' AND SERIE_PRED='1' AND ID_EMPRESA='$empresa'");
    $serie_recibo=$select->fetch(PDO::FETCH_ASSOC);
    $serie_recibo=$serie_recibo['ID_RECIBO_SERIE'];

    $insert=$conexion->query("INSERT INTO bgzeri_empresa.tbltransacciones (ID_FACT, TIPO_DOC, ID_CIERRE, ABONO, FECHA, ID_USU_CANCELA, ID_PAGO, ID_SERIE, NO_TRANSACCION, ID_BANK, DOCU, ESTADO) VALUES ('$tmp', '-1', '0','$abono', '$fecha', '$id_usuario', '$metodo', '0', '$serie_recibo', '$cuenta', '$referencia', '0')");

    if($insert){
        echo '1';
    }
}else if($accion=='delete'){
    $delete=$conexion->query("DELETE FROM bgzeri_empresa.tbltransacciones WHERE ID_FACT='$id_tmp' AND TIPO_DOC='-1' AND ID_TRANS='$id_trans';");
    if($delete){
        echo 'OK';
    }else{
        echo 'ERROR';
    }


}



?>