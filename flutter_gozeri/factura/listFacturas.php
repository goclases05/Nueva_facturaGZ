<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include('../conex.php');

if($accion=='Pendientes'){
    
    $select=$conexion->query("SELECT tblfacturas_list_temp.ID_FACT_TMP, tblfacturas_list_temp.FECHA, tblfacturas_list_temp.ID_CLIENTE, tblusuarios.NOMBRE, tblusuarios.APELLIDOS, tblusuarios_perfil.NIT FROM bgzeri_empresa.tblfacturas_list_temp LEFT JOIN tblusuarios ON tblusuarios.ID_USUARIO=tblfacturas_list_temp.ID_CLIENTE INNER JOIN tblusuarios_perfil ON tblusuarios_perfil.ID_USUARIO=tblusuarios.ID_USUARIO WHERE tblfacturas_list_temp.ID_EMPRESA='$empresa' AND tblfacturas_list_temp.ID_USUARIO='$idusuario' AND tblfacturas_list_temp.ID_SUCURSAL = '$sucu' AND tblfacturas_list_temp.ID_SUCURSAL='$sucu' ORDER BY ID_FACT_TMP DESC LIMIT $limit,10");
    $matriz_fac=array();
    $row=$select->fetchAll();

    /*while($row=$select->fetch(PDO::FETCH_ASSOC)){
        $matriz[]=$row;
    }*/
    $i=0;
    foreach($row as $key){
        $matriz_fac[$i]['ID_FACT_TMP']="{$key['ID_FACT_TMP']}";
        $matriz_fac[$i]['ID_CLIENTE']="{$key['ID_CLIENTE']}";
        $matriz_fac[$i]['NOMBRE']="{$key['NOMBRE']}";
        $matriz_fac[$i]['APELLIDOS']="{$key['APELLIDOS']}";
        $matriz_fac[$i]['NIT']="{$key['NIT']}";
        $matriz_fac[$i]['NO']="";
        $matriz_fac[$i]['FECHA']="{$key['FECHA']}";
        $matriz_fac[$i]['ESTADO']="";
        $i++;
    }
    echo json_encode($matriz_fac);

}else if($accion=='Emitidas'){

    $select=$conexion->query("SELECT tblfacturas.ID_FACT, tblfacturas.FECHA, tblfacturas.ID_USUARIO, tblusuarios.NOMBRE, tblusuarios.APELLIDOS, tblusuarios_perfil.NIT, tblfacturas.NO, tblfacturas.ESTADO FROM bgzeri_empresa.tblfacturas INNER JOIN tblusuarios ON tblusuarios.ID_USUARIO=tblfacturas.ID_USUARIO INNER JOIN tblusuarios_perfil ON tblusuarios_perfil.ID_USUARIO=tblusuarios.ID_USUARIO WHERE tblfacturas.ID_EMPRESA='$empresa' AND tblfacturas.ID_SUCURSAL = '$sucu' AND tblfacturas.ESTADO IN (0,2) ORDER BY ID_FACT DESC LIMIT $limit,10");

    $matriz_fac=array();
    $row=$select->fetchAll();

    /*while($row=$select->fetch(PDO::FETCH_ASSOC)){
        $matriz[]=$row;
    }*/
    $i=0;
    foreach($row as $key){
        $matriz_fac[$i]['ID_FACT_TMP']="{$key['ID_FACT']}";
        $matriz_fac[$i]['ID_CLIENTE']="{$key['ID_USUARIO']}";
        $matriz_fac[$i]['NOMBRE']="{$key['NOMBRE']}";
        $matriz_fac[$i]['APELLIDOS']="{$key['APELLIDOS']}";
        $matriz_fac[$i]['NIT']="{$key['NIT']}";
        $matriz_fac[$i]['NO']="{$key['NO']}";
        $matriz_fac[$i]['FECHA']="{$key['FECHA']}";
        $matriz_fac[$i]['ESTADO']="{$key['ESTADO']}";
        $i++;
    }

    echo json_encode($matriz_fac);

}


?>