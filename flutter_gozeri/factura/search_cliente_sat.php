<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include('../conex.php');

$nit = addslashes(str_replace("-", "", $SAT));
	$empresa = 47;
	include_once "inc/solicitarToken_v2.php";
	
	if ($prefes[89] == 1) {
    	$xml = "<?xml version='1.0' encoding='UTF-8'?>
		<RetornaDatosClienteRequest>
		 <nit>".$nit."</nit>
		</RetornaDatosClienteRequest>";

		$ch2 = curl_init();
	    curl_setopt($ch2, CURLOPT_URL,"https://apiv2.ifacere-fel.com/api/retornarDatosCliente");

	    curl_setopt($ch2, CURLOPT_VERBOSE, 1);
	    curl_setopt($ch2, CURLOPT_SSL_VERIFYHOST, 0);
	    curl_setopt($ch2, CURLOPT_SSL_VERIFYPEER, 0);

	    curl_setopt($ch2, CURLOPT_POST, 1);
	    curl_setopt($ch2, CURLOPT_POSTFIELDS, $xml); 
	    curl_setopt($ch2, CURLOPT_HTTPHEADER, array(
	        'Content-type: application/xml',
	        "Authorization: Bearer $token"
	    ));

		// Receive server response ...
		curl_setopt($ch2, CURLOPT_RETURNTRANSFER, true);
		$server_output = curl_exec($ch2);
		curl_close ($ch2);
		$carga_xml = simplexml_load_string($server_output);

		if ($carga_xml->tipo_respuesta == 0) {

			/*$nombre_comp = explode(" ", );

			$apellidos = $nombre_comp[0].' '.$nombre_comp[1];*/
			$nombre = addslashes($carga_xml->nombre);
			$direccion = addslashes($carga_xml->direcciones->direccion);

			$pais   = 'GT';
            $empresa=$_GET['empresa'];
			$insert = $conexion->query("INSERT INTO tblusuarios (TIPO_USUARIO, ID_EMPRESA, NOMBRE, APELLIDOS, FECHA_REGISTRO, CORREO, CLAVE, TIPO_REGISTRO, VALIDADO, IGRESADO_POR, PAIS) VALUES ('9', '$empresa', '$nombre', '', NOW(), '', '', '3', '0', '$idusuario','$pais')");
			$new_id=$conexion->lastInsertId();
			$login = strtoupper($pais).$new_id;
			$update = $conexion->query("UPDATE tblusuarios SET USUARIO = '$login' WHERE ID_USUARIO = '$new_id'");

		
			$update  = $conexion->query("UPDATE tblusuarios_perfil SET DIRECCION = '$direccion', TELEFONO = '', NIT = '$nit' WHERE ID_USUARIO = '$new_id'");

			$new_insert = $conexion->query("INSERT INTO bgzeri_empresa.tblclientes (ID_USUARIO, ID_VENDEDOR, ID_EMPRESA, ID_FASE, TIPO_CLIENTE) VALUES ('$new_id', '$idusuario', '$empresa', (SELECT ID_FASE FROM bgzeri_empresa.tblclientes_fases WHERE ID_PRED = 1 AND ID_EMPRESA = '$empresa'), '1')");

			//echo $new_id;
            echo "{                
                'cliente':'".$new_id."'
            }";
		}else{
			echo "{                
                'error':'NIT no encontrado'
            }";
		}
	}

?>