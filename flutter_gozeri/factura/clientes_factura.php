<?php
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
    include('../conex.php');

    $select = $conexion->query("SELECT ID_PREFERENCIA, CONTENIDO FROM tblempresas_prefe WHERE ID_EMPRESA = '$empresa' AND ID_PREFERENCIA = 98");
    $prefes = array();
    while ($row = $select->fetch(PDO::FETCH_ASSOC)) {
    $id = $row["ID_PREFERENCIA"];
    $prefes[$id] = $row["CONTENIDO"];
    }
    $cartera = $prefes[98];
    $select->closeCursor();

    if ($cartera == 1 && $tipo >= 4) {
    $CARTERA = "AND tblclientes.ID_VENDEDOR = '$idusuario'";
    }else{
    $CARTERA = "";
    }

    $search = addslashes($_GET['clientes']);

    $select = $conexion->query("SELECT tblusuarios.ID_USUARIO,tblclientes.ID_EMPRESA, tblusuarios.USUARIO, tblusuarios.NOMBRE, tblusuarios.APELLIDOS, tblusuarios.CORREO, tblusuarios_perfil.TELEFONO, tblusuarios_perfil.NIT FROM bgzeri_empresa.tblclientes INNER JOIN tblusuarios ON tblclientes.ID_USUARIO = tblusuarios.ID_USUARIO INNER JOIN tblusuarios_perfil ON tblclientes.ID_USUARIO = tblusuarios_perfil.ID_USUARIO WHERE tblclientes.ID_EMPRESA = '$empresa' AND (tblusuarios.NOMBRE LIKE '%$search%' OR tblusuarios.APELLIDOS LIKE '%$search%' OR tblusuarios.USUARIO LIKE '%$search%' OR tblusuarios_perfil.TELEFONO LIKE '%$search%' OR tblusuarios_perfil.NIT LIKE '%$search%' OR tblusuarios.CORREO LIKE '%$search%' OR CONCAT(tblusuarios.NOMBRE, ' ', tblusuarios.APELLIDOS) LIKE '$search%') AND tblclientes.ESTADO = 1 $CARTERA");
    $clients = array(); $i = 0;
    while ($row = $select->fetch(PDO::FETCH_ASSOC)) {
        $clients[$i]["label"] = $row["NOMBRE"].' '.$row["APELLIDOS"].' ('.$row['NIT'].')';
        $clients[$i]["id"] = $row["ID_USUARIO"];
        $clients[$i]['nit']=$row['NIT'];
        $i++;
    }

    if ($i == 0) {
        $clients[$i]["label"] = 'Sin Resultados';
        $clients[$i]["id"] = '0';
        $clients[$i]['nit']='';
        $i++;
    }

    echo json_encode($clients);

?>