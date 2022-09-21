<?php 
	/*ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	error_reporting(E_ALL);*/

	include('conex.php');
	//$empresa=$_POST['empresa'];

	/*$query=$conexion->query("SELECT tblcategorias.ID_CATEG, tblcategorias.CATEGORIA, ICONO FROM ".BASE_EMPRESA.".tblcategorias WHERE NIVEL = 1 AND ESTADO = 1 AND ID_EMPRESA='$empresa'");*/

	$id_empresa=$_GET['empresa'];
	$query=$conexion->query("SELECT tbldepartamentos.ID_CATEG, tbldepartamentos.CATEGORIA, tbldepartamentos.ICONO FROM bgzeri_empresa.tblcategorias AS tbldepartamentos INNER JOIN bgzeri_empresa.tblcategorias ON tblcategorias.ID_PADRE = tbldepartamentos.ID_CATEG INNER JOIN bgzeri_empresa.tblcategorias AS tblsubcategorias ON tblsubcategorias.ID_PADRE = tblcategorias.ID_CATEG INNER JOIN bgzeri_empresa.tblproductos ON tblproductos.ID_CATEG = tblsubcategorias.ID_CATEG LEFT JOIN bgzeri_empresa.tblproductos_pre ON tblproductos_pre.ID_PROD = tblproductos.ID_PROD LEFT JOIN bgzeri_empresa.tblproductos_inv ON tblproductos_inv.ID_PROD = tblproductos.ID_PROD WHERE tbldepartamentos.ID_EMPRESA = '$id_empresa' AND tbldepartamentos.ESTADO = 1 AND tblcategorias.ESTADO = 1 AND tblsubcategorias.ESTADO = 1 AND tbldepartamentos.NIVEL = 1 AND tblproductos.ESTADO = 1 AND (if(tblproductos_inv.ENTRADAS-tblproductos_inv.SALIDAS > 0, 1, tblproductos_pre.STOCK_C)) = 1 GROUP BY tbldepartamentos.ID_CATEG ORDER BY tbldepartamentos.CATEGORIA ASC");

	$query->execute();

	$array_departamentos=$query->fetchAll();
	$total_rows = $query->rowCount();
	$query->closeCursor();

	if($total_rows > 0){

		$matriz_departamentos=array();
		$i=0;
		foreach($array_departamentos as $key){

			$categoria = html_entity_decode($key['CATEGORIA']);
			if(strlen($categoria) > 10){
				$categoria = substr ( $categoria, 0, 10). ' ...';
			}

			$matriz_departamentos[$i] = array(
				"ID" => "{$key['ID_CATEG']}",
				"DEPARTAMENTO" => ''.html_entity_decode($key['CATEGORIA']).'',
				"DEPARTAMENTO_CORTO" => "{$categoria}",
				"ICONO" => ''.html_entity_decode($key['ICONO']).'',
			);
			$i++;

		}

	 echo '{ 
	        "total_depa" : "'.$total_rows.'",
	        "departamentos": '.json_encode($matriz_departamentos).' 
	     }';

	}else{

	echo '{ 
	        "total_depa" : "0" 
	        "departamentos": ""
	     }';
	}
	//echo json_encode($matriz_departamentos);


	$conexion=null;

?>