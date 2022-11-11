<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

include('conex.php');

$query=$conexion->query("SELECT FECHA, FECHA_V FROM tblpedidos WHERE ID_USUARIO='$empresa'");

$data=$query->fetch(PDO::FETCH_ASSOC);

$fecha=date("Y-m-d 00:00",strtotime($data['FECHA']));

$fecha_v=date("Y-m-d 00:00",strtotime($data['FECHA_V']));

$hoy=time();

if($fecha_v==date("Y-m-d 00:00",strtotime('0000-00-00 00:00:00'))){
    $fecha_v = date("Y-m-d 00:00",strtotime($fecha."+ 15 days"));
}
$mantenimiento=0;

if($version=='1.0.0'){
    if($mantenimiento==0){
        if(strtotime($fecha_v)<$hoy){
            echo 'membresia';
        }else{
            echo 'OK';
        }
    }else{
        //echo 'membresia';
        echo 'mantenimiento';
    }
    
}else{

    echo 'version';

}






?>