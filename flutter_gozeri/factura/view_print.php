<?php 
	ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
    include('../conex.php');

    $id = addslashes($_GET['id']);
    $empresa = addslashes($_GET['empresa']);

	$query = $conexion->query("SELECT tblsucursales.TELEFONO AS TELE_SUCU, tblsucursales.ID_SUCURSAL, tblsucursales.DIRECCION AS DIRECCION_SUCU, tblsucursales.NOMBRE AS NOMBRE_EMPRESA_SUCU, tblempresas_.NOMBRE_EMPRESA, tblsucursales.RUTA AS RUTA_SUCU, tblsucursales.FOTO, tblfacturas.ESTADO, tblfacturas.DTE, tblclientes.FACTURAR_A, tblclientes.ORGANIZACION, tblfacturar.NOMBRE AS NOMBRE_F, tblfacturar.APELLIDOS AS APELLIDOS_F, tblfacturas.DESCUENTO, tblfacturas.ID_SERIE, tblfacturas.ID_FACT, tblfacturas_series.TIPO, tblfacturas_series.TICKET, tblfacturas_series.SERIE, tblfacturas.NO, tblempresas_perfil.TELEFONO, tblempresas_perfil.LOGO_URL, tblempresas_perfil.LOGO_NOM, tblempresas_perfil.DIRECCION, tblusuarios.ID_USUARIO AS ID_CLIENTE, tblusuarios.NOMBRE, tblusuarios.APELLIDOS, tblfacturas.DIRECCION AS DIRECCION_CLI, tblusuarios_perfil.TELEFONO AS TELEFONO_USU, tblusuarios_perfil.NIT, tblfacturas.FECHA, tblfacturas.FECHA_V, tblfacturas.ID_VENDEDOR, tblusuarios_2.NOMBRE AS NOMBRE_V, tblusuarios_2.APELLIDOS AS APELLIDOS_V, tblfacturas.TOTAL, tblformaspago_pred.FORMA, tblfacturas.OBSER, tblfacturas_series.OBSERVACIONES, tblfacturas_series.RUTA, tblfacturas_series.PLANTILLA, tblempresas_prefe.CONTENIDO FROM bgzeri_empresa.tblfacturas INNER JOIN tblusuarios ON tblfacturas.ID_USUARIO = tblusuarios.ID_USUARIO INNER JOIN tblusuarios_perfil ON tblusuarios.ID_USUARIO = tblusuarios_perfil.ID_USUARIO INNER JOIN bgzeri_empresa.tblfacturas_series ON tblfacturas.ID_SERIE = tblfacturas_series.ID_SERIE INNER JOIN tblempresas_ ON tblfacturas.ID_EMPRESA = tblempresas_.ID_EMPRESA INNER JOIN tblempresas_perfil ON tblempresas_.ID_EMPRESA = tblempresas_perfil.ID_EMPRESA INNER JOIN tblusuarios AS tblusuarios_2 ON tblfacturas.ID_VENDEDOR = tblusuarios_2.ID_USUARIO INNER JOIN bgzeri_dbzeri.tblformaspago_pred ON tblfacturas.TERMINOS = tblformaspago_pred.ID_PAGO_PRED INNER JOIN tblempresas_prefe ON tblempresas_prefe.ID_EMPRESA = tblfacturas.ID_EMPRESA LEFT JOIN bgzeri_empresa.tblclientes ON tblclientes.ID_USUARIO = tblfacturas.ID_USUARIO LEFT JOIN tblusuarios AS tblfacturar ON tblfacturar.ID_USUARIO = tblclientes.FACTURAR_A INNER JOIN bgzeri_empresa.tblsucursales ON tblsucursales.ID_SUCURSAL = tblfacturas_series.ID_SUCURSAL WHERE tblfacturas.ID_FACT = '$id' AND tblempresas_prefe.ID_PREFERENCIA = 2 AND tblfacturas.ID_EMPRESA = '$empresa'");
	$matriz_factura = array();
	while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
		$matriz_factura["ENCABEZADO"] = $row;
	}

	$matriz_factura["DETALLE"] = array();

	echo json_encode($matriz_factura);
 ?>