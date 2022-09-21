<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include('../conex.php');


//TODO: empresa, id_usuario
//verifica si la empresa y el usuario son correctos
$salect=$conexion->query("SELECT ID_USUARIO FROM tblusuarios WHERE ID_EMPRESA='$empresa' AND ID_USUARIO='$id_usuario'");
$salect->execute();
$total_rows = $salect->rowCount();

if($total_rows<1){

    echo json_encode(array('error'=>'Acceso Denegado'));

}else{

    $preferencia = $conexion->query("SELECT CONTENIDO FROM tblempresas_prefe WHERE tblempresas_prefe.ID_EMPRESA = '$empresa' AND ID_PREFERENCIA = 12");
    $prefes= $preferencia->fetch(PDO::FETCH_ASSOC);

    $select_tmp=$conexion->query("SELECT * FROM bgzeri_empresa.tblfacturas_list_temp WHERE `ID_USUARIO` = '$id_usuario' AND `ID_CLIENTE`='' ORDER BY `tblfacturas_list_temp`.`ID_FACT_TMP` DESC LIMIT 1");
    if($select_tmp->rowCount()>0){

        $fetch=$select_tmp->fetch(PDO::FETCH_ASSOC);
        $id=$fetch['ID_FACT_TMP'];
        echo json_encode(array('id_tmp'=>$id,'clave'=>$prefes["CONTENIDO"]));

    }else{
        $insert=$conexion->query("INSERT INTO bgzeri_empresa.tblfacturas_list_temp (`ID_USUARIO`) VALUES ('$id_usuario')");
        $select_tmp=$conexion->query("SELECT * FROM bgzeri_empresa.tblfacturas_list_temp WHERE `ID_USUARIO` = '$id_usuario' AND `ID_CLIENTE`='' ORDER BY `tblfacturas_list_temp`.`ID_FACT_TMP` DESC LIMIT 1");
        $row=$select_tmp->fetch(PDO::FETCH_ASSOC);
        $id=$row['ID_FACT_TMP'];
        echo json_encode(array('id_tmp'=>$id,'clave'=>$prefes["CONTENIDO"]));
    }

}
?>