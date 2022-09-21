<?php 
	ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	error_reporting(E_ALL);

	include('conex.php');

	$id_empresa = $_GET['id_empresa'];
	
	$accion=$_GET['accion'];
	/*accion
	accion 1= todos los data_productos
	accion 2= producto por categoria
	*/

	if ($accion=='2') {
		$productos=$_GET['producto'];
		$id_categoria=$_GET['id_categoria'];
		// code...
		$query = $conexion->query("SELECT (SELECT CONTENIDO FROM tblempresas_prefe WHERE tblempresas_prefe.ID_EMPRESA = tblproductos.ID_EMPRESA AND ID_PREFERENCIA = 70) AS EDIT_PRECIO, (SELECT CONTENIDO FROM tblempresas_prefe WHERE tblempresas_prefe.ID_EMPRESA = tblproductos.ID_EMPRESA AND ID_PREFERENCIA = 96) AS FACTURAR, tblproductos_pre.UNIDAD_MEDIDA, tblproductos.ID_PROD, tblproductos.PRODUCTO,tblproductos.CODIGO, tblproductos.DESC_BREVE, tblproductos.DESC_COMP, tblproductos.PRECIO, tblproductos.PRECIO_2, tblproductos.PRECIO_3, tblproductos.PRECIO_4, (tblproductos_inv.ENTRADAS-tblproductos_inv.SALIDAS) AS STOCK, FOTO, URL FROM bgzeri_empresa.tblproductos_fotos INNER JOIN bgzeri_empresa.tblproductos USING (ID_PROD) INNER JOIN bgzeri_empresa.tblproductos_inv USING (ID_PROD) INNER JOIN bgzeri_empresa.tblcategorias ON tblcategorias.ID_CATEG=tblproductos.ID_CATEG INNER JOIN bgzeri_empresa.tblcategorias AS tblcategorias2 ON tblcategorias2.ID_CATEG=tblcategorias.ID_PADRE INNER JOIN bgzeri_empresa.tblcategorias AS tblcategorias3 ON tblcategorias3.ID_CATEG=tblcategorias2.ID_PADRE LEFT JOIN bgzeri_empresa.tblproductos_pre ON tblproductos_pre.ID_PROD = tblproductos.ID_PROD WHERE TIPO = 1 AND tblcategorias.ID_EMPRESA = '$id_empresa' AND tblproductos.ID_PROD AND tblproductos.ESTADO = 1 AND tblcategorias3.ID_CATEG='$id_categoria' GROUP BY ID_PROD LIMIT $productos, 5");
		
	}else if($accion=='1'){
		$query = $conexion->query("SELECT ID_PROD, tblproductos.PRODUCTO,tblproductos.CODIGO, tblproductos.DESC_BREVE, tblproductos.PRECIO, (tblproductos_inv.ENTRADAS-tblproductos_inv.SALIDAS) AS STOCK, FOTO, URL FROM bgzeri_empresa.tblproductos_fotos INNER JOIN bgzeri_empresa.tblproductos USING (ID_PROD) INNER JOIN bgzeri_empresa.tblproductos_inv USING (ID_PROD) WHERE TIPO = 1 AND ID_EMPRESA = '$id_empresa' AND tblproductos.ID_PROD AND tblproductos.ESTADO = 1 GROUP BY ID_PROD");
	
	}

	$query->execute();

	$array_productos=$query->fetchAll();
	$total_rows = $query->rowCount();
	//print_r($array_productos);

	$query->closeCursor();


$matriz_productos=array();
	if($total_rows > 0){

		
		$i=0;
		foreach($array_productos as $key){

			$matriz_productos[$i]['ID_PROD'] = "{$key['ID_PROD']}";
			$matriz_productos[$i]['PRODUCTO'] = "".strip_tags(html_entity_decode($key['PRODUCTO']))."";
			$matriz_productos[$i]['CODIGO'] = "{$key['CODIGO']}";
			$matriz_productos[$i]['DESC_BREVE'] = "".strip_tags(html_entity_decode($key['DESC_BREVE']))."";
			$matriz_productos[$i]['DESC_COMP'] = "".strip_tags(html_entity_decode($key['DESC_COMP']))."";
			$matriz_productos[$i]['MODO_VENTA'] = "{$key['UNIDAD_MEDIDA']}";
			$matriz_productos[$i]['FACTURAR'] = "{$key['FACTURAR']}";
			$matriz_productos[$i]['PRECIO'] = "{$key['PRECIO']}";
			$matriz_productos[$i]['PRECIO_2'] = "{$key['PRECIO_2']}";
			$matriz_productos[$i]['PRECIO_3'] = "{$key['PRECIO_3']}";
			$matriz_productos[$i]['PRECIO_4'] = "{$key['PRECIO_4']}";
			$matriz_productos[$i]['STOCK'] = "{$key['STOCK']}";
			$matriz_productos[$i]['FOTO'] = "{$key['FOTO']}";
			$matriz_productos[$i]['URL'] = "{$key['URL']}";

			$i++;

		}

	echo '{ 
		        "total": "'.$total_rows.'",
		        "productos": '.json_encode($matriz_productos).' 
	     }';

	}else{

		echo '{ 
		        "total": "",
		        "productos": '.json_encode(array()).'
		     }';
	}


	//echo json_encode($matriz_productos);

	

 ?>