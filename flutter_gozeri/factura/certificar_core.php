<?php 
	ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	error_reporting(E_ALL); 
	include('../conex.php');  
	function hijos($id, $conexion, $id_sucu,$cantidad){   
		$matriz_data=array();   
		$matriz_data=array("id"=>$id,"cantidad"=>$cantidad);
		$matriz_hijos = '';
		$matriz_hijos = $conexion->query("SELECT tblproductos.ID_PROD, tblproductos_combos.CANTIDAD, tblproductos_fotos.URL, tblproductos_fotos.FOTO FROM bgzeri_empresa.tblproductos INNER JOIN bgzeri_empresa.tblproductos_combos ON tblproductos.ID_PROD=tblproductos_combos.ID_PROD INNER JOIN bgzeri_empresa.tblproductos_fotos ON tblproductos_fotos.ID_PROD=tblproductos.ID_PROD AND tblproductos_fotos.TIPO = '1' WHERE `ID_PADRE`='$id'");   
		$row=$matriz_hijos->fetch(PDO::FETCH_ASSOC);   
		if($matriz_hijos->rowCount() == 0){     
			return $matriz_data;   
		}else if($matriz_hijos->rowCount() == 1){     
			return hijos($row["ID_PROD"], $conexion, $id_sucu, ($row["CANTIDAD"]*$cantidad));
		}else{     
			return $matriz_data;   
		} 
	} 
	function combo_varios($id,$cantidad, $conexion, $id_sucu){   
		$matriz_data=array();   
		$matriz_data=array("id_prod"=>$id,"cantidad"=>$cantidad);   
		$matriz_hijos = '';   
		$matriz_hijos = $conexion->query("SELECT tblproductos.ID_PROD, tblproductos_combos.CANTIDAD, tblproductos_fotos.URL, tblproductos_fotos.FOTO FROM bgzeri_empresa.tblproductos INNER JOIN bgzeri_empresa.tblproductos_combos ON tblproductos.ID_PROD=tblproductos_combos.ID_PROD INNER JOIN bgzeri_empresa.tblproductos_fotos ON tblproductos_fotos.ID_PROD=tblproductos.ID_PROD AND tblproductos_fotos.TIPO = '1' WHERE `ID_PADRE`='$id'");   
		$count = $matriz_hijos->rowCount();   
		if($count == 0){     
			return $matriz_data;   
		}else if($count == 1){     
			$row=$matriz_hijos->fetch(PDO::FETCH_ASSOC);     
			return combo_varios($row["ID_PROD"], $conexion, $id_sucu, ($row["CANTIDAD"]*$cantidad));
		}else if($count >1){     
			$matriz_data=array();     
			while($row=$matriz_hijos->fetch(PDO::FETCH_ASSOC)){       
				$matriz_data[] = $row;     
			}     
			return $matriz_data;   
		} 
	} 
	if (isset($_GET["id"])) {  
		$usuario  = addslashes($_GET["usuario"]);  
		$empresa  = addslashes($_GET["empresa"]);  
		$id_empresa = $empresa;  
		$id_fac_tmp  = addslashes($_GET["id"]);  
		$select = $conexion->query("SELECT * FROM bgzeri_empresa.tblfacturas_list_temp WHERE ID_FACT_TMP = '$id_fac_tmp'");  
		$datos = $select->fetch(PDO::FETCH_ASSOC);  
		$id_cliente  = $datos["ID_CLIENTE"];  
		$id_vendedor  = $usuario;  
		$condiciones = 14;  
		$id_serie    = $datos["ID_SERIE"];  
		$fecha       = date('Y-m-d H:i:s');  
		$vence       = date('Y-m-d H:i:s');  
		$observacion = $datos["OBSER"];  
		$direccion      = $datos["DIRECCION"];  
		$descuento   = $datos["DESCUENTO"];  
		if (empty($descuento)) {    
			$descuento = 0;  
		}  
		$preferencias = $conexion->query("SELECT ID_PREFERENCIA, CONTENIDO FROM tblempresas_prefe WHERE ID_EMPRESA = '$empresa' AND ID_PREFERENCIA = 87");  
		$preferencia_empresa = array();  
		while ($prefes = $preferencias->fetch(PDO::FETCH_ASSOC)) {
		    $preferencia_empresa[$prefes["ID_PREFERENCIA"]] = $prefes["CONTENIDO"];
		}  
		$prefe_fel         = $preferencia_empresa[87];  
		$select_numero = $conexion->query("SELECT NO FROM bgzeri_empresa.tblfacturas WHERE ID_EMPRESA = '$empresa' AND ID_SERIE = '$id_serie' ORDER BY tblfacturas.NO DESC LIMIT 1");
		$data_numero = $select_numero->fetch(PDO::FETCH_ASSOC);  
		$numero_serie = $data_numero["NO"]+1;  
		//$select_numero->closeCursor();  
		$select_serie = $conexion->query("SELECT SERIE, HASTA, ACTUAL, TIPO, FEL, tblsucursales.TOKEN_FEL, tblsucursales.DIRECCION, tblsucursales.CODIGO, tblsucursales_prefe.CONTENIDO, tblsucursales.ID_SUCURSAL FROM bgzeri_empresa.tblfacturas_series INNER JOIN bgzeri_empresa.tblsucursales ON tblsucursales.ID_SUCURSAL = tblfacturas_series.ID_SUCURSAL INNER JOIN bgzeri_empresa.tblsucursales_prefe ON tblsucursales_prefe.ID_SUCURSAL = tblsucursales.ID_SUCURSAL WHERE ID_SERIE = '$id_serie' AND tblsucursales.ID_EMPRESA = '$empresa' AND tblsucursales_prefe.ID_PREFE = 1");
		$data_serie = $select_serie->fetch(PDO::FETCH_ASSOC);  
		$sucursal = $data_serie["ID_SUCURSAL"];  
		$serieK = $data_serie['SERIE'];  
		$hasta = $data_serie['HASTA'];  
		$tipo_fact = $data_serie['TIPO'];  
		$fel = $data_serie["FEL"];  
		$codigo_est = $data_serie['CODIGO'];  
		if ($data_serie['CONTENIDO'] == 1) {    
			$prefe_fel = $data_serie['CONTENIDO'];    
			$certificar_por_sucu = 1;  
		}else{    
			$certificar_por_sucu = 0;  
		}  
		$complementos = array();  
		/*if ($tipo_fact == 'FCAM') {    
			$comple = $conexion->query("SELECT ABONO, VENCE FROM bgzeri_empresa.tblfacturas_complementos WHERE ID_FACT_TMP = '$id_fac_tmp' ORDER BY ID_COMPLEMENTO ASC");    
			while ($row = $comple->fetch(PDO::FETCH_ASSOC)) {      
				$complementos[] = $row;    
			}    
			$comple->closeCursor();  
		}*/  
		$select_productos = $conexion->query("SELECT tblfacturas_det_tmp.ID_TMP, tblfacturas_det_tmp.TIPO_PRECIO, tblfacturas_det_tmp.ID_PADRE, tblfacturas_det_tmp.ID_PROD, (SELECT COUNT(*) FROM bgzeri_empresa.tblproductos_combos WHERE tblproductos_combos.ID_PADRE= tblfacturas_det_tmp.ID_PROD) AS HIJOS, tblfacturas_det_tmp.ID_PROD, tblfacturas_det_tmp.DESCRIPCION, tblfacturas_det_tmp.COSTO, SUM(tblfacturas_det_tmp.CANTIDAD) AS CANTIDAD, tblfacturas_det_tmp.PRECIO, tblproductos.PRODUCTO, tblproductos.ID_EMPRESA, tbldepartamentos.CATEGORIA FROM bgzeri_empresa.tblfacturas_det_tmp INNER JOIN bgzeri_empresa.tblproductos ON tblproductos.ID_PROD = tblfacturas_det_tmp.ID_PROD INNER JOIN bgzeri_empresa.tblcategorias AS tblsubcategorias ON tblsubcategorias.ID_CATEG = tblproductos.ID_CATEG INNER JOIN bgzeri_empresa.tblcategorias ON tblcategorias.ID_CATEG = tblsubcategorias.ID_PADRE INNER JOIN bgzeri_empresa.tblcategorias AS tbldepartamentos ON tbldepartamentos.ID_CATEG = tblcategorias.ID_PADRE WHERE ID_FACT_TMP = '$id_fac_tmp' GROUP BY tblfacturas_det_tmp.ID_PROD, tblfacturas_det_tmp.PRECIO, tblfacturas_det_tmp.DESCRIPCION");  
		$matriz_productos = array();  
		$i = 0;  
		$detalle_factura = '';  
		$detalle_kardex = '';  
		$productos = '';  
		$total_fact = 0;  
		while ($row = $select_productos->fetch(PDO::FETCH_ASSOC)) {    
			$inventario = $conexion->query("SELECT ENTRADAS, SALIDAS FROM bgzeri_empresa.tblproductos_inv WHERE ID_PROD = '$row[ID_PROD]'");    
			$datos = $inventario->fetch(PDO::FETCH_ASSOC);    
			$stock = $datos["ENTRADAS"]-$datos["SALIDAS"]-$row['CANTIDAD'];
			//$inventario->closeCursor();    
			if($row['HIJOS']==1){      
				if($row['ID_PADRE']==0){        
					$hijo=hijos($row['ID_PROD'], $conexion, $sucursal, $row['CANTIDAD']);        
					$detalle_kardex .= "('$hijo[id]', '$usuario', '$sucursal', 'F', '__ID_FACT__', '$fecha', '-', '__DESCRIPCION__', '$hijo[cantidad]', $row[PRECIO], $stock),";        
					$detalle_factura .= "('__ID_FACT__', '$row[ID_PROD]', '$row[DESCRIPCION]', '$row[COSTO]', '$row[CANTIDAD]', '$row[PRECIO]', '$row[TIPO_PRECIO]'),";      
				}    
			}else if($row['HIJOS']>1){      
				$hijo=combo_varios($row['ID_PROD'],$row['CANTIDAD'], $conexion, $sucursal);      
				if(!empty($hijo)){        
					foreach($hijo as $key_hijos){          
						$productos .= $key_hijos["ID_PROD"].",";          
						$cantidad = $row['CANTIDAD'];          
						$cantidad=$key_hijos['CANTIDAD']*$cantidad;          
						$detalle_kardex .= "('$key_hijos[ID_PROD]', '$usuario', '$sucursal', 'F', '__ID_FACT__', '$fecha', '-', '__DESCRIPCION__', '$cantidad', 0, 0),";        
					}      
				}      
				//$error_fel = $detalle_kardex;        
				$detalle_factura .= "('__ID_FACT__', '$row[ID_PROD]', '$row[DESCRIPCION]', '$row[COSTO]', '$row[CANTIDAD]', '$row[PRECIO]', '$row[TIPO_PRECIO]'),";    
			}else{      
				if($row['ID_PADRE']==0){        
					$cantidad = $row['CANTIDAD'];        
					$detalle_kardex .= "('$row[ID_PROD]', '$usuario', '$sucursal', 'F', '__ID_FACT__', '$fecha', '-', '__DESCRIPCION__', '$cantidad', $row[PRECIO], $stock),";        $detalle_factura .= "('__ID_FACT__', '$row[ID_PROD]', '$row[DESCRIPCION]', '$row[COSTO]', '$cantidad', '$row[PRECIO]', '$row[TIPO_PRECIO]'),";      
				}else{      
				}    
			}    
			if ($row["ID_PADRE"] == 0) {      
				$total_fact = $total_fact+($row["CANTIDAD"]*$row["PRECIO"]);      
				$productos .= $row["ID_PROD"].",";      
				$matriz_productos[] = $row;      
				$i++;    
			}  
		}  
		$desc = ($total_fact/100)*$descuento;  
		$total_fact = $total_fact-$desc;  
		$detalle_factura = substr($detalle_factura, 0, -1);  
		$detalle_kardex = substr($detalle_kardex, 0, -1);  
		$productos = substr($productos, 0, -1);  
		//$select_productos->closeCursor();  
		if ($i == 0) {    
			echo json_encode(
				array(
					"status" => "error",
					"Error" => "No existen productos",
					"Desc" => "Debes agregar Productos a tu Factura"
				)
			);
			die();  
		}  
		/*if ($tipo_f == 'FCAM') {    
			if (number_format($total_fact, 2, '.', ',') == number_format($abonos, 2, '.', ',')) {

			}else{        
				echo json_encode(array("status" => "error","Error" => "Abono incorrecto","Desc" => "Los abonos no coinciden con el Total ".number_format($total_fact, 2, '.', ',').". Abonos: ".$abonos));die();
			}
		}*/  
		$insert_factura = $conexion->query("INSERT INTO bgzeri_empresa.tblfacturas (ID_PEDIDO, ID_USUARIO, DIRECCION, ID_VENDEDOR, ID_EMPRESA, ID_SUCURSAL, ID_SERIE, NO, FECHA, FECHA_V, TERMINOS, DOCUMENTO, OBSER, TOTAL, DESCUENTO, ESTADO) VALUES ('0', '$id_cliente', '$direccion', '$id_vendedor', '$empresa', '$sucursal', '$id_serie', '$numero_serie', '$fecha', '$vence', '$condiciones', '0', '$observacion', '$total_fact', '$descuento', '1')");  
		$new_id = $conexion->lastInsertId();  
		$detalle_factura = str_replace("__ID_FACT__", $new_id, $detalle_factura);
		$insertar_det = $conexion->query("INSERT INTO bgzeri_empresa.tblfacturas_det (ID_FACT, ID_PROD, DESCRIPCION, COSTO, CANTIDAD, PRECIO, TIPO_PRECIO) VALUES $detalle_factura");  
		$select = $conexion->query("SELECT tbltransacciones.NO_TRANSACCION, tbltransacciones.DOCU, tbltransacciones.ABONO, tblformaspago_pred.FORMA, tblbank.CUENTA, tblbank.NO_CUENTA, tblbank.BANCO FROM bgzeri_empresa.tbltransacciones INNER JOIN tblformaspago_pred ON tblformaspago_pred.ID_PAGO_PRED = tbltransacciones.ID_PAGO LEFT JOIN bgzeri_bank.tblbank ON tblbank.ID_BANK = tbltransacciones.ID_BANK WHERE tbltransacciones.ID_FACT = '$id_fac_tmp' AND TIPO_DOC = -1");  
		$ABONO = 0;  
		while ($data_trans = $select->fetch(PDO::FETCH_ASSOC)) {    
			$ABONO += $data_trans["ABONO"];  
		}  
		$vuelto = $total_fact-$ABONO;  
		if ($vuelto <= 0) {      
			$update = $conexion->query("UPDATE bgzeri_empresa.tblfacturas SET ESTADO = 2 WHERE ID_FACT = '$new_id'");
		}
		if ($vuelto < 0) {    
			$query = $conexion->query("SELECT NO_TRANSACCION FROM bgzeri_empresa.tbltransacciones INNER JOIN tblusuarios ON tblusuarios.ID_USUARIO = tbltransacciones.ID_USU_CANCELA WHERE  tblusuarios.ID_EMPRESA = '$empresa' ORDER BY NO_TRANSACCION DESC LIMIT 1");
			$data = $query->fetch(PDO::FETCH_ASSOC);    
			$no_trans = $data["NO_TRANSACCION"]+1;    
			//$query->closeCursor();    
			$fecha = date('Y-m-d H:i:s');    
			$insert = $conexion->query("INSERT INTO bgzeri_empresa.tbltransacciones (ID_FACT, TIPO_DOC, ID_CIERRE, MONTO, ABONO, FECHA, ID_USU_CANCELA, ID_PAGO, NO_TRANSACCION, ID_BANK, DOCU) VALUES ('$id_fac_tmp', '-1', '0', '0', '$vuelto', '$fecha', '$usuario', '1', '$no_trans', '', '')");
		}
		$transacciones = $conexion->query("UPDATE bgzeri_empresa.tbltransacciones SET TIPO_DOC = 0, ID_FACT = '$new_id' WHERE ID_FACT = '$id_fac_tmp' AND TIPO_DOC = -1");  
		// Actualizar tblseries numero actual y estado
		$estado_serie = "";  
		if ($hasta == $numero_serie) {    
			$estado_serie = ", ESTADO = '0'";  
		}  
		$update_serie = $conexion->query("UPDATE bgzeri_empresa.tblfacturas_series SET ACTUAL = '$numero_serie' $estado_serie WHERE ID_SERIE = '$id_serie' AND ID_EMPRESA = '$empresa'");  
		/*if ($tipo_fact == 'FCAM') {    
			$update = $conexion->query("UPDATE bgzeri_empresa.tblfacturas_complementos SET ID_FACT = '$new_id' WHERE ID_FACT_TMP = '$id_fac_tmp'");
		}*/  
		// Insertar en kardex los productos  
		$descripcionK = "Fact: ".$serieK."-".$numero_serie;  
		$detalle_kardex = str_replace("__ID_FACT__", $new_id, $detalle_kardex);  
		$detalle_kardex = str_replace("__DESCRIPCION__", $descripcionK, $detalle_kardex);  
		$insert_kardex = $conexion->query("INSERT INTO bgzeri_empresa.tblkardex (ID_PRODUCTO, ID_USUARIO, ID_SUCURSAL, TIPO, ID_TIPO, FECHA, TIPO_MOVIMIENTO, DESCRIPCION, CANTIDAD, MONTO, STOCK) VALUES $detalle_kardex");  
		// Crear cookie para dejar seleccionada la serie  
		if ($_SERVER['HTTP_HOST']=='localhost') {    
			$dominio=$_SERVER['HTTP_HOST'];  
		}else{    
			$dominio=".".$_SERVER['HTTP_HOST'];  
		}  
		//setcookie("serie", $id_serie, time()+90000000, "/", $dominio);  
		$select_kardex = $conexion->query("SELECT ID_PRODUCTO, SUM(CANTIDAD) AS CANTIDAD FROM bgzeri_empresa.tblkardex WHERE ID_PRODUCTO IN ($productos) AND TIPO_MOVIMIENTO = '-' GROUP BY ID_PRODUCTO");  
		while ($key = $select_kardex->fetch(PDO::FETCH_ASSOC)) {    
			$update_inv = $conexion->query("UPDATE bgzeri_empresa.tblproductos_inv SET ULT_VENTA = '$fecha', SALIDAS = '$key[CANTIDAD]' WHERE ID_PROD = '$key[ID_PRODUCTO]'");  
		}  
		/*$select_kardex->closeCursor();  
		if (!empty($id_reserva) || $id_reserva > 0) {    
			$update = $conexion->query("UPDATE bgzeri_empresa.tblreservaciones SET ID_FACT = '$new_id' WHERE ID_RESERVACION = '$id_reserva'");  
		}else if (!empty($pedido)) {    
			$select = $conexion->query("SELECT PAGADO, TOTAL, TERMINOS FROM bgzeri_empresa.tblpedidos WHERE ID_PEDIDO = '$pedido'");    
			while ($row = $select->fetch(PDO::FETCH_ASSOC)) {      
				$total = $row["TOTAL"];      
				$pagada = $row["PAGADO"];      
				$pago = $row["TERMINOS"];    
			}    
			$select->closeCursor();    
			if ($pagada == 1) {      
				$query = $conexion->query("SELECT NO_TRANSACCION FROM bgzeri_empresa.tbltransacciones INNER JOIN tblusuarios ON tblusuarios.ID_USUARIO = tbltransacciones.ID_USU_CANCELA WHERE  tblusuarios.ID_EMPRESA = '$empresa' ORDER BY NO_TRANSACCION DESC LIMIT 1");      
				$data = $query->fetch(PDO::FETCH_ASSOC);      
				$no_trans = $data["NO_TRANSACCION"]+1;      
				$query->closeCursor();      
				$update = $conexion->query("UPDATE bgzeri_empresa.tblfacturas SET ESTADO = 2 WHERE ID_FACT = '$new_id'");      
				$insert = $conexion->query("INSERT INTO bgzeri_empresa.tbltransacciones (ID_FACT, MONTO, ABONO, FECHA, ID_USU_CANCELA, ID_PAGO, NO_TRANSACCION, DOCU) VALUES ('$new_id', '0.00', '$total', '$fecha', '$id_usuario', '$pago', '$no_trans', '')");      
				$numero = $no_trans+1;      
				$update = $conexion->query("UPDATE tblempresas_prefe SET CONTENIDO = '$numero' WHERE tblempresas_prefe.ID_EMPRESA = '$id_empresa' AND tblempresas_prefe.ID_PREFERENCIA = 4");    
			}    
			$update = $conexion->query("UPDATE bgzeri_empresa.tblpedidos SET ESTADO = 2 WHERE ID_PEDIDO = '$pedido'");  
		}*/  
		if ( $total_fact == $ABONO) {    
			$estado = ', ESTADO = 2';  
		}else{    
			$estado = ', ESTADO = 1';  
		}  
		if (!isset($xml_r)) {    
			$xml_r = '';  
		}  
		if (!isset($uuid)) {    
			$uuid = '';  
		}  
		if (!isset($uuid_firmado)) {    
			$uuid_firmado = '';  
		}  
		if (!isset($uuid_registra)) {    
			$uuid_registra = '';  
		}  
		$update = $conexion->query("UPDATE bgzeri_empresa.tblfacturas SET UUID = '$uuid', UUID2 = '$uuid_firmado', UUID3 = '$uuid_registra' $xml_r $estado WHERE ID_FACT = '$new_id'");  
		$sentencia = $conexion->query("DELETE FROM bgzeri_empresa.tblfacturas_list_temp WHERE ID_FACT_TMP = '$id_fac_tmp'"); 
		$sentencia2 = $conexion->query("DELETE FROM bgzeri_empresa.tblfacturas_det_tmp WHERE ID_FACT_TMP = '$id_fac_tmp'");


		$id = $new_id;  
		$select = $conexion->query("SELECT *, tblfacturas_series.TIPO AS TIPO_FACT FROM bgzeri_empresa.tblfacturas INNER JOIN bgzeri_empresa.tblfacturas_series ON tblfacturas_series.ID_SERIE = tblfacturas.ID_SERIE WHERE ID_FACT = '$id'");  
		$data = $select->fetch(PDO::FETCH_ASSOC);  
		$id_fac_tmp  = $id;  
		$id_cliente  = $data["ID_USUARIO"];  
		$id_vendedor = $data["ID_VENDEDOR"];  
		$condiciones = $data["TERMINOS"]; 
		$deposito    = $data["DOCUMENTO"];  
		$id_serie    = $data["ID_SERIE"];  
		$vence       = $data["FECHA_V"];  
		$observacion = $data["OBSER"];   
		$pedido      = 0;  
		$descuento   = $data["DESCUENTO"];  
		$id_reserva  = 0;  
		//$prefe_fel   = addslashes($_POST['fel']);  
		$tipo_f      = $data["TIPO_FACT"];  
		$direccion      = $data["DIRECCION"];  
		$sucursal      = $data["ID_SUCURSAL"];  
		$fecha = date('Y-m-d H:i:s');  
		if (empty($descuento)) {    
			$descuento = 0;  
		}  
		// ***************************************************** FEL  
		if ($fel == 1 && $prefe_fel == 1) {    
			function gen_uuid($conexion, $id_empresa) {      
				$uuid = sprintf( '%04x%04x-%04x-%04x-%04x-%04x%04x%04x',          
				// 32 bits for "time_low"          
					mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ),          
					// 16 bits for "time_mid"          
					mt_rand( 0, 0xffff ),          
					// 16 bits for "time_hi_and_version",          
					// four most significant bits holds version number 4          
					mt_rand( 0, 0x0fff ) | 0x4000,          
					// 16 bits, 8 bits for "clk_seq_hi_res",          
					// 8 bits for "clk_seq_low",          
					// two most significant bits holds zero and one for variant DCE1.1          
					mt_rand( 0, 0x3fff ) | 0x8000,          
					// 48 bits for "node"          
					mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff )      );      
				$select_uuid = $conexion->query("SELECT UUID FROM bgzeri_empresa.tblfacturas WHERE ID_EMPRESA = '$id_empresa' AND UUID = '$uuid'");      
				$data_uuid = $select_uuid->fetch(PDO::FETCH_ASSOC);      
				if (empty($data_uuid)) {        
					return strtoupper($uuid);      
				}else{        
					gen_uuid($conexion, $id_empresa);      
				}    
			}    
			if ($certificar_por_sucu == 1) {      
				$select_prefes = $conexion->query("SELECT ID_PREFE, CONTENIDO FROM bgzeri_empresa.tblsucursales_prefe WHERE ID_SUCURSAL = '$sucursal'");      
				$prefes = array();      
				$prefes_sucu = array();      
				while ($row = $select_prefes->fetch(PDO::FETCH_ASSOC)) {        
					$prefes_sucu[$row["ID_PREFE"]] = $row["CONTENIDO"];      
				}      
				$select_prefes->closeCursor();      
				$prefes[79] = $prefes_sucu[4];      
				$prefes[80] = $prefes_sucu[5];      
				$prefes[81] = $prefes_sucu[6];      
				$prefes[83] = $prefes_sucu[7];      
				$prefes[85] = $prefes_sucu[9];      
				$prefes[86] = $prefes_sucu[10];      
				$prefes[87] = $prefes_sucu[1];      
				$prefes[88] = $prefes_sucu[8];      
				$prefes[89] = $prefes_sucu[3];      
				$prefes[102] = $prefes_sucu[11];     
				$prefes[103] = $prefes_sucu[12];      
				$prefes[104] = $prefes_sucu[13];      
				$prefes[105] = $prefes_sucu[14];      
				$prefes[106] = $prefes_sucu[2];    
			}else{      
				$select_prefes = $conexion->query("SELECT ID_PREFERENCIA, CONTENIDO FROM tblempresas_prefe WHERE ID_PREFERENCIA >= '79' AND ID_PREFERENCIA <= '106' AND ID_EMPRESA = '$id_empresa'");      
				$prefes = array();      
				while ($row = $select_prefes->fetch(PDO::FETCH_ASSOC)) {        
					$prefes[$row["ID_PREFERENCIA"]] = $row["CONTENIDO"];      
				}      
				$select_prefes->closeCursor();    
			}    
			$select_token = $conexion->query("SELECT tblempresas_perfil.TOKEN_FEL, tblempresas_perfil.EMAIL, tblempresas_perfil.DIRECCION, tblmunicipios.MUNICIPIO, tbldepartamentos.DEPARTAMENTO, tblpaises.ABREVIA FROM tblempresas_perfil INNER JOIN tblempresas_ ON tblempresas_.ID_EMPRESA = tblempresas_perfil.ID_EMPRESA INNER JOIN tblmunicipios ON tblmunicipios.ID_MUNICIPIO = tblempresas_.ID_MUNICIPIO INNER JOIN tbldepartamentos ON tbldepartamentos.ID_DEPARTAMENTO = tblmunicipios.ID_DEPARTAMENTO INNER JOIN tblpaises ON tblpaises.ID_PAIS = tbldepartamentos.ID_PAIS WHERE tblempresas_perfil.ID_EMPRESA = '$id_empresa'");    
			$data_token = $select_token->fetch(PDO::FETCH_ASSOC);    
			if ($certificar_por_sucu == 1) {      
				$token = $data_serie["TOKEN_FEL"];      
				$direccion_emisor = $data_serie["DIRECCION"];    
			}else{      
				$token = $data_token["TOKEN_FEL"];      
				$direccion_emisor = $data_token["DIRECCION"];    
			}    
			include_once "inc/solicitarToken.php";    
			if (empty($token)) {      
				$token = solicitarToken($prefes[79], $prefes[80], $prefes[89], $prefes[106]);      
				if ($token == 'Curl Error') {        
					$error_fel = "Curl Error al Solicitar el Token";      
				}else{        
					if ($prefes[106] == 1) { # MEGAPRINT          
						$carga_xml = simplexml_load_string($token);          
						$tipo_respuesta = $carga_xml->tipo_respuesta;          
						if ($tipo_respuesta == 0) {            
							if ($certificar_por_sucu == 1) {              
								$update_token = $conexion->query("UPDATE bgzeri_empresa.tblsucursales SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa' AND ID_SUCURSAL = '$sucursal'");            
							}else{              
								$update_token = $conexion->query("UPDATE tblempresas_perfil SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa'");            
							}          
						}else{            
							$error_fel = "Error al solicitar el Token. ".$carga_xml->listado_errores->error->desc_error;
						}        
					}else if ($prefes[106] == 2) { # SIGSA          
						$carga_xml = simplexml_load_string($token);          
						$tipo_respuesta = $carga_xml->codigo;          
						if ($tipo_respuesta == 200) {            
							$token = json_encode(              
								array(                
									"token" => $carga_xml->mensaje,                
									"vigencia" => strtotime(date('Y-m-d H:i:s')."+ 20 minutes")              
								)            
							);            
							if ($certificar_por_sucu == 1) {              
								$update_token = $conexion->query("UPDATE bgzeri_empresa.tblsucursales SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa' AND ID_SUCURSAL = '$sucursal'");
							}else{              
								$update_token = $conexion->query("UPDATE tblempresas_perfil SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa'");
							}
						}else{
							$error_fel = "Error al solicitar el Token. ".$carga_xml->listado_errores->error->desc_error;
						}        
					}else if ($prefes[106] == 3) { #DIGIFACT          
						$carga_xml = json_decode($token, true);          
						if (isset($carga_xml["Token"])) {            
							if ($certificar_por_sucu == 1) {              
								$update_token = $conexion->query("UPDATE bgzeri_empresa.tblsucursales SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa' AND ID_SUCURSAL = '$sucursal'");            
							}else{              
								$update_token = $conexion->query("UPDATE tblempresas_perfil SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa'");            
							}          
						}else{            
							$error_fel = $carga_xml["message"]."\n".$carga_xml["description"];          
						}        
					}      
				}    
			}        
			if ($prefes[106] == 1) { # MEGAPRINT      
				$carga_xml = simplexml_load_string($token);      
				$vigencia = strtotime(str_replace("-06:00", "+06:00", $carga_xml->vigencia));    
			}else if ($prefes[106] == 2) { # SIGSA        
				$carga_xml = json_decode($token, true);      
				$vigencia = $carga_xml["vigencia"];    
			}else if ($prefes[106] == 3) { #DIGIFACT      
				$carga_xml = json_decode($token, true);      
				$vigencia = strtotime(str_replace("Z", "+06:00", $carga_xml["expira_en"]));    
			}    
			if ($vigencia < time()) {      
				$token = solicitarToken($prefes[79], $prefes[80], $prefes[89], $prefes[106]);      
				if ($token == 'Curl Error') {        
					$error_fel = "Curl Error al Solicitar el Token";      
				}else{        
					if ($prefes[106] == 1) { # MEGAPRINT          
						$carga_xml = simplexml_load_string($token);          
						$tipo_respuesta = $carga_xml->tipo_respuesta;          
						if ($tipo_respuesta == 0) {            
							if ($certificar_por_sucu == 1) {              
								$update_token = $conexion->query("UPDATE bgzeri_empresa.tblsucursales SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa' AND ID_SUCURSAL = '$sucursal'");            
							}else{              
								$update_token = $conexion->query("UPDATE tblempresas_perfil SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa'");            
							}          
						}else{            
							$error_fel = "Error al solicitar el Token. ".$carga_xml->listado_errores->error->desc_error;          
						}        
					}else if ($prefes[106] == 2) { # SIGSA          
						$carga_xml = simplexml_load_string($token);          
						$tipo_respuesta = $carga_xml->codigo;          
						if ($tipo_respuesta == 200) {            
							$token = json_encode(              
								array(                
									"token" => $carga_xml->mensaje,                
									"vigencia" => strtotime(date('Y-m-d H:i:s')."+ 20 minutes")              
								)            
							);            
							if ($certificar_por_sucu == 1) {
								$update_token = $conexion->query("UPDATE bgzeri_empresa.tblsucursales SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa' AND ID_SUCURSAL = '$sucursal'");            
							}else{              
								$update_token = $conexion->query("UPDATE tblempresas_perfil SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa'");            
							}          
						}else{            
							$error_fel = "Error al solicitar el Token. ".$carga_xml->listado_errores->error->desc_error;          
						}        
					}else if ($prefes[106] == 3) { #DIGIFACT          
						$carga_xml = json_decode($token, true);          
						if (isset($carga_xml["Token"])) {            
							if ($certificar_por_sucu == 1) {              
								$update_token = $conexion->query("UPDATE bgzeri_empresa.tblsucursales SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa' AND ID_SUCURSAL = '$sucursal'");            
							}else{              
								$update_token = $conexion->query("UPDATE tblempresas_perfil SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa'");            
							}          
						}else{            
							$error_fel = $carga_xml["message"]."\n".$carga_xml["description"];          
						}        
					}      
				}    
			}    
			$select = $conexion->query("SELECT tblusuarios.NOMBRE, tblusuarios.APELLIDOS, tblusuarios.CORREO, tblusuarios_perfil.NIT FROM tblusuarios INNER JOIN tblusuarios_perfil ON tblusuarios_perfil.ID_USUARIO = tblusuarios.ID_USUARIO WHERE tblusuarios.ID_USUARIO = '$id_cliente'");    
			$data_receptor = $select->fetch(PDO::FETCH_ASSOC);    
			if (empty($data_receptor["NIT"])) {      
				$NIT = 'CF';    
			}else{      
				$NIT = $data_receptor["NIT"];    
			}    
			if ($prefes[106] == 1) { # MEGAPRINT      
				$token = $carga_xml->token;      
				$nit_emisor = $prefes[79];    
			}else if ($prefes[106] == 2) { # SIGSA      
				$carga_xml = json_decode($token, true);      
				$token = $carga_xml["token"][0];      
				$nit_emisor = $prefes[79];    
			}else if ($prefes[106] == 3) { #DIGIFACT      
				$token = $carga_xml["Token"];      
				$nit_emisor = explode(".", $prefes[79]);      
				$nit_emisor = (string)((int)($nit_emisor[0]));    
			}    
			include_once "inc/xml.php";    
			//$nombres = explode(" ", $data_receptor["NOMBRE"]);    
			//$apellidos = explode(" ", $data_receptor["APELLIDOS"]);    
			$nombre = $data_receptor["NOMBRE"].' '.$data_receptor["APELLIDOS"];        
			$document = xml('GTQ', $tipo_fact, $prefes[88], $codigo_est, $data_token["EMAIL"], $nit_emisor, $prefes[83], $prefes[81], $direccion_emisor, $data_token["MUNICIPIO"], $data_token["DEPARTAMENTO"], $data_token["ABREVIA"], $data_receptor["CORREO"], $NIT, $nombre, 'ciudad', $data_token["MUNICIPIO"], $data_token["DEPARTAMENTO"], $data_token["ABREVIA"],$matriz_productos, $descuento, $complementos, $conexion, $direccion, $fecha, $certificar_por_sucu, $sucursal, $empresa);    
			$a = array('&Aacute;', '&Eacute;', '&Iacute;', '&Oacute;', '&Uacute;', '&aacute;', '&eacute;', '&iacute;', '&oacute;', '&uacute;','&Ntilde;','&ntilde;','&ordf;', '&#39;', '&Ccedil;', '&ccedil;', '&Agrave;', '&Egrave;', '&Igrave;', '&Ograve;', '&Ugrave;', '&agrave;', '&egrave;', '&igrave;', '&ograve;', '&ugrave;', '&');    
			$b = array('Á', 'É', 'Í', 'Ó', 'Ú', 'á', 'é', 'í', 'ó', 'ú','Ñ','ñ', 'ª' , "'", 'Ç', 'ç', 'À', 'È', 'Ì', 'Ò', 'Ù', 'à', 'è', 'ì', 'ò', 'ù', '&amp;');    
			$document = str_replace($a, $b, $document);    
			if ($prefes[106] == 1 && !empty($token)) { # MEGAPRINT      
				$uuid = gen_uuid($conexion, $id_empresa);      
				$xml = '<?xml version="1.0" encoding="UTF-8"?>      
				<FirmaDocumentoRequest id="'.$uuid.'">      
				<xml_dte><![CDATA['.$document.']]></xml_dte>      
				</FirmaDocumentoRequest>';      
				$ch2 = curl_init();      
				if ($prefes[89] == 1) {        
					curl_setopt($ch2, CURLOPT_URL,"https://api.soluciones-mega.com/api/solicitaFirma");      
				}else{        
					curl_setopt($ch2, CURLOPT_URL,"https://dev.api.soluciones-mega.com/api/solicitaFirma");      
				}      
				curl_setopt($ch2, CURLOPT_VERBOSE, 1);      
				curl_setopt($ch2, CURLOPT_SSL_VERIFYHOST, 0);      
				curl_setopt($ch2, CURLOPT_SSL_VERIFYPEER, 0);      
				curl_setopt($ch2, CURLOPT_POST, 1);      
				curl_setopt($ch2, CURLOPT_POSTFIELDS, $xml);       
				curl_setopt($ch2, CURLOPT_HTTPHEADER, array(
					'Content-type: application/xml',          
					'Accept: application/xml',          
					"Authorization: Bearer $token"      
				));      
				// Receive server response ...      
				curl_setopt($ch2, CURLOPT_RETURNTRANSFER, true);
				$server_output = curl_exec($ch2);      
				$carga_xml_firm = simplexml_load_string($server_output);      
				if ($carga_xml_firm->tipo_respuesta == 0) {       
					$az = array('&Aacute;', '&Eacute;', '&Iacute;', '&Oacute;', '&Uacute;', '&aacute;', '&eacute;', '&iacute;', '&oacute;', '&uacute;','&Ntilde;','&ntilde;','&ordf;', '&#39;', '&Ccedil;', '&ccedil;', '&Agrave;', '&Egrave;', '&Igrave;', '&Ograve;', '&Ugrave;', '&agrave;', '&egrave;', '&igrave;', '&ograve;', '&ugrave;');
					$bz = array('Á', 'É', 'Í', 'Ó', 'Ú', 'á', 'é', 'í', 'ó', 'ú','Ñ','ñ', 'ª' , "'", 'Ç', 'ç', 'À', 'È', 'Ì', 'Ò', 'Ù', 'à', 'è', 'ì', 'ò', 'ù');        
					$xml_firmado = str_replace($az, $bz, htmlentities($carga_xml_firm->xml_dte));        
					/*$xml_firmado = str_replace($a, $b, htmlentities($carga_xml_firm->xml_dte));        
					$xml_firmado = str_replace($c, $b, 
					$xml_firmado);*/        
					$five_chars = substr($xml_firmado, -6);        
					if ($five_chars == "gt;gt;") {          
						$xml_firmado = substr($xml_firmado, 0, -3);        
					}        
					$uuid_firmado = $carga_xml_firm->uuid;        
					curl_close ($ch2);        
					$ch3 = curl_init();        
					if ($prefes[89] == 1) {          
						curl_setopt($ch3, CURLOPT_URL,"https://apiv2.ifacere-fel.com/api/validarDocumento");        
					}else{          
						curl_setopt($ch3, CURLOPT_URL,"https://dev2.api.ifacere-fel.com/api/validarDocumento");        
					}              
					curl_setopt($ch3, CURLOPT_VERBOSE, 1);        
					curl_setopt($ch3, CURLOPT_SSL_VERIFYHOST, 0);        
					curl_setopt($ch3, CURLOPT_SSL_VERIFYPEER, 0);        
					curl_setopt($ch3, CURLOPT_POST, 1);        
					curl_setopt($ch3, CURLOPT_POSTFIELDS,'<?xml version="1.0" encoding="UTF-8"?><ValidaDocumentoRequest><xml_dte>'.$xml_firmado.'</xml_dte></ValidaDocumentoRequest>');         
					curl_setopt($ch3, CURLOPT_HTTPHEADER, array(
						'Content-type: application/xml',
						'Accept: application/xml',
						"Authorization: Bearer $token"
						));
					error_log($xml_firmado);
					// Receive server response ...
					curl_setopt($ch3, CURLOPT_RETURNTRANSFER, true);
					$server_output = curl_exec($ch3);
					curl_close ($ch3);
					$carga_xml_valida = simplexml_load_string($server_output);
					if ($carga_xml_valida->tipo_respuesta == 0) {
						$xml_registra = '<?xml version="1.0" encoding="UTF-8"?>
						<RegistraDocumentoXMLRequest id="'.$uuid_firmado.'">
						<xml_dte><![CDATA['.html_entity_decode($xml_firmado).']]></xml_dte>
					</RegistraDocumentoXMLRequest>';
					$ch4 = curl_init();
					if ($prefes[89] == 1) {
						curl_setopt($ch4, CURLOPT_URL,"https://apiv2.ifacere-fel.com/api/registrarDocumentoXML");
					}else{
						curl_setopt($ch4, CURLOPT_URL,"https://dev2.api.ifacere-fel.com/api/registrarDocumentoXML");
					}
					curl_setopt($ch4, CURLOPT_VERBOSE, 1);
					curl_setopt($ch4, CURLOPT_SSL_VERIFYHOST, 0);
					curl_setopt($ch4, CURLOPT_SSL_VERIFYPEER, 0);
					curl_setopt($ch4, CURLOPT_POST, 1);
					curl_setopt($ch4, CURLOPT_POSTFIELDS, $xml_registra);
					curl_setopt($ch4, CURLOPT_HTTPHEADER, array(
						'Content-type: application/xml',
						'Accept: application/xml',
						"Authorization: Bearer $token"
						));
						// Receive server response ...
						curl_setopt($ch4, CURLOPT_RETURNTRANSFER, true);
						$server_output = curl_exec($ch4);
						curl_close ($ch4);
						$carga_xml_registro = simplexml_load_string($server_output);
						if ($carga_xml_registro->tipo_respuesta == 0) {
							$uuid_registra = $carga_xml_registro->uuid;
							$xml_registrado = addslashes($carga_xml_registro->xml_dte);
							$xml_r = ", DTE = '$xml_registrado'";
						}else{
							$error_fel = 'Error al registrar el documento. '.$server_output;
						}
					}else{
						$error_fel = 'Error al validar el documento. '.$server_output;
					}
				}else{
					$error_fel = 'Error al Firmar el documento. '.$server_output;
				}
			}else if ($prefes[106] == 2) { # SIGSA
				if ($prefes[89] == 1) {
					$host = "https://receptor.fel.sigsa.gt/prod/ReceptorXml";
				}else{
					$host = "https://receptor.fel.sigsa.gt/desa/ReceptorXml";
				}
				$curl = curl_init();
				curl_setopt_array($curl, array(
					CURLOPT_URL => $host,
					CURLOPT_RETURNTRANSFER => true,
					CURLOPT_ENCODING => '',
					CURLOPT_MAXREDIRS => 10,
					CURLOPT_TIMEOUT => 0,
					CURLOPT_FOLLOWLOCATION => true,
					CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
					CURLOPT_CUSTOMREQUEST => 'POST',
					CURLOPT_POSTFIELDS =>$document,
					CURLOPT_HTTPHEADER => array(
						"Access_Token: $token",
						'Content-Type: application/xml',
						'Accept: application/xml',
						"ID_Certificado: $nit_emisor"
					),
				));
				$response = curl_exec($curl);
				curl_close($curl);
				$carga_xml_firm = json_decode($response, true);
				if (!empty($carga_xml_firm["Autorizacion"])) {
					$autorizacion = $carga_xml_firm["Autorizacion"];
					sleep(1);
					if ($prefes[89] == 1) {
						$host = "https://receptor.fel.sigsa.gt/prod/DownloadDTE";
					}else{
						$host = "https://receptor.fel.sigsa.gt/desa/DownloadDTE";
					}
					$curl = curl_init();
					curl_setopt_array($curl, array(
						CURLOPT_URL => $host,
						CURLOPT_RETURNTRANSFER => true,
						CURLOPT_ENCODING => '',
						CURLOPT_MAXREDIRS => 10,
						CURLOPT_TIMEOUT => 0,
						CURLOPT_FOLLOWLOCATION => true,
						CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
						CURLOPT_CUSTOMREQUEST => 'GET',
						CURLOPT_HTTPHEADER => array(
							'Content-Type: application/xml',
							'Accept: application/xml',
							'Token: '.$token.'',
							'EMISOR: '.$nit_emisor.'',
							'RECEPTOR: '.$NIT.'',
							'NUMERO_DOCUMENTO: '.$carga_xml_firm["Autorizacion"].''
						),
					));
					$response = curl_exec($curl);
					curl_close($curl);
					$respuesta = simplexml_load_string($response);
					if ($respuesta->CodError == "FEL_RCP000") {
						$uuid_registra = $carga_xml_firm["Autorizacion"];
						$xml_registrado = str_replace("<![CDATA[", "", addslashes($respuesta->Mensaje));
						$xml_registrado = str_replace("]]>", "", $xml_registrado);
						$xml_r = ", DTE = '$xml_registrado'";
					}else{
						$error_fel = $respuesta->Mensaje;
					}
				}else{
					$error_fel = $carga_xml_firm["mensaje"];
				}
			}else if ($prefes[106] == 3 && !empty($token)) { #DIGIFACT
				if ($prefes[89] == 1) {
					$host = 'https://felgtaws.digifact.com.gt/gt.com.fel.api.v3/api/FelRequestV2';
				}else{
					$host = 'https://felgttestaws.digifact.com.gt/gt.com.fel.api.v3/api/FelRequestV2';
				}
				$user = explode(".", $prefes[79]);
				$curl = curl_init();
				curl_setopt_array($curl, array(
					CURLOPT_URL => $host.'?NIT='.$user[0].'&TIPO=CERTIFICATE_DTE_XML_TOSIGN&FORMAT=XML,PDF&USERNAME='.$user[1],
					CURLOPT_RETURNTRANSFER => true,
					CURLOPT_ENCODING => '',
					CURLOPT_MAXREDIRS => 10,
					CURLOPT_TIMEOUT => 0,
					CURLOPT_FOLLOWLOCATION => true,
					CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
					CURLOPT_CUSTOMREQUEST => 'POST',
					CURLOPT_POSTFIELDS => $document,
					CURLOPT_HTTPHEADER => array(
						'Content-type: application/json',
						"Authorization: $token"
					),
				));
				$server_output = curl_exec($curl);
				curl_close($curl);
				$respuesta = json_decode($server_output, true);
				if ($respuesta["Codigo"] == 1) {
					$uuid_registra = $respuesta["AcuseReciboSAT"];
					$xml_registrado = addslashes(base64_decode($respuesta["ResponseDATA1"]));
					$pdf = $respuesta["ResponseDATA3"];
					$xml_r = ", DTE = '$xml_registrado', PDF = '$pdf'";
				}else{
					$error_fel = $respuesta["Mensaje"]."<br>".$respuesta["ResponseDATA1"];
				}
			}
		}

		if (isset($error_fel)) {
			echo json_encode(array("MENSAJE"=>"Error","Descripción"=>$error_fel));
			die();
		}else{
			if (!isset($xml_r)) {
				$xml_r = '';
			}
			if (!isset($uuid)) {
				$uuid = '';
			}
			if (!isset($uuid_firmado)) {
				$uuid_firmado = '';
			}
			if (!isset($uuid_registra)) {
				$uuid_registra = '';
			}
			$update = $conexion->query("UPDATE bgzeri_empresa.tblfacturas SET UUID = '$uuid', UUID2 = '$uuid_firmado', UUID3 = '$uuid_registra' $xml_r WHERE ID_FACT = '$id'");
			$status = 'ok';
			$error = '';
			$error_fel = '';
			echo json_encode(array("MENSAJE"=>"OK","ID"=>$id));
		}
	}
	 ?>