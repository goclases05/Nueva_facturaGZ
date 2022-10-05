<?php 
	ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
    include('../conex.php');

    $factura = addslashes($_GET['factura']);
    $empresa = addslashes($_GET['empresa']);

    $select = $conexion->query("SELECT tblfacturas_list_temp.ID_SERIE, tblfacturas_list_temp.ID_USUARIO, tblfacturas_list_temp.ID_CLIENTE, tblusuarios.NOMBRE, tblusuarios.APELLIDOS, tblfacturas_list_temp.DIRECCION, tblusuarios_perfil.TELEFONO, tblusuarios_perfil.NIT, tblclientes.FACTURAR_A, tblclientes.ORGANIZACION, tblfacturar.NOMBRE AS NOMBRE_F, tblfacturar.APELLIDOS AS APELLIDOS_F, tblfacturas_list_temp.TERMINOS FROM bgzeri_empresa.tblfacturas_list_temp  LEFT JOIN bgzeri_dbzeri.tblusuarios ON tblfacturas_list_temp.ID_CLIENTE = tblusuarios.ID_USUARIO LEFT JOIN bgzeri_dbzeri.tblusuarios_perfil ON tblusuarios.ID_USUARIO = tblusuarios_perfil.ID_USUARIO LEFT JOIN bgzeri_empresa.tblclientes ON tblclientes.ID_USUARIO = tblfacturas_list_temp.ID_CLIENTE LEFT JOIN bgzeri_dbzeri.tblusuarios AS tblfacturar ON tblfacturar.ID_USUARIO = tblclientes.FACTURAR_A WHERE tblfacturas_list_temp.ID_FACT_TMP = '$factura' AND tblfacturas_list_temp.ID_EMPRESA = '$empresa'");
    $clients = array();
    while ($row = $select->fetch(PDO::FETCH_ASSOC)) {
    	$cliente = $row["ID_CLIENTE"];
    	$serie = $row["ID_SERIE"];
        /*$clients[$i]["id"] = $row["ID_USUARIO"];
        $clients[$i]["cliente"] = $row["NOMBRE"].' '.$row["APELLIDOS"];
        $clients[$i]['nit']=$row['NIT'];*/
    }

    $select = $conexion->query("SELECT * FROM bgzeri_empresa.tblfacturas_det WHERE ID_FACT = '$factura'");
    $o = 0;
    while ($fila = $select->fetch(PDO::FETCH_ASSOC)) {
    	$o++;
    }

    $select = $conexion->query("SELECT * FROM bgzeri_empresa.tbltransacciones WHERE ID_FACT = '$factura' AND TIPO_DOC = '-1'");
    $u = 0;
    while ($fila2 = $select->fetch(PDO::FETCH_ASSOC)) {
    	$u++;
    }

    $clients[0]["cliente"] = "$cliente";
    $clients[0]['detalle']="$o";
    $clients[0]['pagos']="$u";
    $clients[0]['serie']="$serie";

    echo json_encode($clients);
 ?>