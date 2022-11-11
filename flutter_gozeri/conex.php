<?php 
	date_default_timezone_set("America/Guatemala");
	header('Content-type: application/json; charset=utf-8');
	
	if ($_SERVER['SERVER_NAME']=='localhost') {
		// code...
		$servidor = "localhost";
		$usuario = "root";
		$password = "";
	}else{
		$servidor = "172.105.151.117";
		$usuario = "bgzeri_acceso";
		$password = "oIAL_nFL;e7j";
	}


	try{

        $conexion = new PDO("mysql:host=$servidor;dbname=bgzeri_dbzeri", $usuario, $password);      
        $conexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		$conexion->exec("SET CHARACTER SET utf8");

        define('BASE_EMPRESA','bgzeri_empresa');
        define('BASE_BANCOS','bgzeri_empresa');
        define('BASE_MSJ','bgzeri_msj');


    }catch(PDOException $e){

	    echo "La conexión ha fallado: " . $e->getMessage();
	    die();

	}
	
	foreach($_POST as $nombre_campo => $valor){
		$asignacion = "\$" . $nombre_campo . "='" . addslashes($valor) . "';";
		eval($asignacion);
	}
	
	foreach($_GET as $nombre_campo2 => $valor2){
		$asignacion2 = "\$" . $nombre_campo2 . "='" . addslashes($valor2) . "';";
		eval($asignacion2);
	}
?>