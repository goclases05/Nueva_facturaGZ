<?php
include('../conex.php');

$sentencia = $conexion->query("DELETE FROM bgzeri_empresa.tblfacturas_list_temp WHERE ID_FACT_TMP = '$id'");
$sentencia2 = $conexion->query("DELETE FROM bgzeri_empresa.tblfacturas_det_tmp WHERE ID_FACT_TMP = '$id'");

echo "OK";
?>