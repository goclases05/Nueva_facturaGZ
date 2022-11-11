<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include('../conex.php');

/*
idempresa
nombre
apellidos
idusuario
nit
*/

$insert = $conexion->query("INSERT INTO tblusuarios (TIPO_USUARIO, ID_EMPRESA, NOMBRE, APELLIDOS, FECHA_REGISTRO, CORREO, CLAVE, TIPO_REGISTRO, VALIDADO, IGRESADO_POR, PAIS) VALUES ('9', '$idempresa', '$nombre', '$apellidos', NOW(), '', '123', '3', '0', '$idusuario','GT')");

$new_id=$conexion->lastInsertId();

$login = strtoupper('GT').$new_id;
$update = $conexion->query("UPDATE tblusuarios SET USUARIO = '$login' WHERE ID_USUARIO = '$new_id'");

$update  = $conexion->query("UPDATE tblusuarios_perfil SET DIRECCION = '', TELEFONO = '', NIT = '$nit' WHERE ID_USUARIO = '$new_id'");

if($insert){
    $realizada='OK';
    $update = $conexion->query("UPDATE bgzeri_empresa.tblfacturas_list_temp SET ID_CLIENTE = '$new_id' WHERE ID_FACT_TMP = '$tmp'");
}else{
    $realizada='ERROR';
}

echo json_encode(array('MENSAJE'=>$realizada,'ID'=>$new_id));

?>