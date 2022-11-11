<?php 
	ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
    include('../conex.php');
    require "funcion_letras.inc.php";

    function ObtenerMes($mes){
	  switch ($mes) {
	    case '1':
	      $MES = 'Enero';
	      break;
	    case '2':
	      $MES = 'Febrero';
	      break;
	    case '3':
	      $MES = 'Marzo';
	      break;
	    case '4':
	      $MES = 'Abril';
	      break;
	    case '5':
	      $MES = 'Mayo';
	      break;
	    case '6':
	      $MES = 'Junio';
	      break;
	    case '7':
	      $MES = 'Julio';
	      break;
	    case '8':
	      $MES = 'Agosto';
	      break;
	    case '9':
	      $MES = 'Septiembre';
	      break;
	    case '10':
	      $MES = 'Octubre';
	      break;
	    case '11':
	      $MES = 'Noviembre';
	      break;
	    case '12':
	      $MES = 'Diciembre';
	      break;
	  }
	  return $MES;
	}

    function Frase($id_frase, $id_codigo){
		if ($id_frase == 0) {
			return '';
		}else if ($id_frase == 1) {
			switch ($id_codigo) {
				case 1:
					return 'Sujeto a pagos trimestrales ISR';
				break;
				case 2:
					return 'Sujeto a retención definitiva ISR';
				break;
				case 3:
					return 'Sujeto a pago directo ISR';
				break;
			}
		}else if ($id_frase == 2) {
			return (($id_codigo == 1) ? 'Agente de Retención del IVA':'');
		}else if ($id_frase == 3) {
			return (($id_codigo == 1) ? 'No genera derecho a crédito fiscal':'');
		}else if ($id_frase == 4) {
			switch ($id_codigo) {
				case 1:
					return 'Exenta del IVA (art. 7 num. 2 Ley del IVA)';
				break;
				case 2:
					return 'Exenta del IVA (art. 7 num. 4 Ley del IVA)';
				break;
				case 3:
					return 'Exenta del IVA (art. 7 num. 5 Ley del IVA)';
				break;
				case 4:
					return 'Exenta del IVA (art. 7 num. 9 Ley del IVA)';
				break;
				case 5:
					return 'Exenta del IVA (art. 7 num. 10 Ley del IVA)';
				break;
				case 6:
					return 'Exenta del IVA (art. 7 num. 13 Ley del IVA)';
				break;
				case 7:
					return 'Exenta del IVA (art. 7 num. 14 Ley del IVA)';
				break;
				case 8:
					return 'Exenta del IVA (art. 8 num. 1 Ley del IVA)';
				break;
				case 9:
					return 'Exenta del IVA (art. 7 num. 15 Ley del IVA)';
				break;
				case 10:
					return 'Esta factura no incluye IVA (art. 55 Ley del IVA)';
				break;
				case 11:
					return 'No afecta al IVA (Decreto 29-89 Ley de Maquila)';
				break;
				case 12:
					return 'No afecta al IVA (Decreto 65-89 Ley de Zonas Francas)';
				break;
				case 13:
					return 'Exenta del IVA (art. 7 num. 12, Ley del IVA)';
				break;
				case 14:
					return 'Exenta del IVA (art. 7 num. 6 Ley del IVA)';
				break;
				case 15:
					return 'Exenta del IVA (art. 7 num. 11 Ley del IVA)';
				break;
				case 16:
					return 'Exenta del IVA (art. 8 num. 2 Ley del IVA)';
				break;
				case 17:
					return 'Exenta del IVA (art. 32 literal c Ley Orgánica Zolic)';
				break;
				case 18:
					return '(Contribuyentes con resoluciones específicas de exención al IVA)';
				break;
				case 19:
					return 'Exenta del IVA (art. 3 num. 7 Ley del IVA)';
				break;
				case 20:
					return 'Aportes (art. 35 Ley de Fortalecimiento al Emprendimiento)';
				break;
				case 21:
					return 'Cargos e impuestos no sujetos a IVA (Aerolíneas)';
				break;
				case 22:
					return 'Factura Origen no incluye IVA';
				break;
				case 23:
					return 'Exenta del IVA (art. 7, numeral 3, literal c, Ley del IVA)';
				break;
				case 24:
					return 'No afecto al IVA (Fuera del hecho generador art. 3, 7 y 8, Ley del IVA)';
				break;
				case 25:
					return 'Exenta del IVA (art. 31 Dec. 22-73 Ley Orgánica Zolic)';
				break;
				case 26:
					return 'Exenta del IVA (art. 4 Dec. 31-2022 Ley de Fom. del Trab. Temp. en el Extranjero)';
				break;
				case 27:
					return 'Exenta del IVA (art. 7 literal “a” Dec. 40-2022 Ley Inc. Mov. Eléctrica)';
				break;
				case 28:
					return 'Exenta del IVA (art. 7 literal “c” Dec. 40-2022 Ley Inc. Mov. Eléctrica)';
				break;
				case 29:
					return 'Exenta del IVA (art. 7 literal “d” Dec. 40-2022 Ley Inc. Mov. Eléctrica)';
				break;
				case 30:
					return 'Exenta del IVA (art. 7 literal “g” Dec. 40-2022 Ley Inc. Mov. Eléctrica)';
				break;
				case 31:
					return 'Exenta del IVA (art. 7 literal “h” o “i” Dec. 40- 2022 Ley Inc. Mov. Eléctrica)';
				break;
				case 32:
					return 'Exenta del IVA (art. 8 Dec. 40-2022 Ley Inc. Mov. Eléctrica';
				break;
			}
		}else if ($id_frase == 5) {
			return (($id_codigo == 1) ? 'El vendedor o prestador del servicio se negó a emitir la factura correspondiente.':'');
		}else if ($id_frase == 6) {
			switch ($id_codigo) {
				case 1:
					return 'Con forma de pago sobre las ventas brutas';
				break;
				case 2:
					return 'Con forma de pago sobre las utilidades, no retener';
				break;
			}
		}else if ($id_frase == 7) {
			switch ($id_codigo) {
				case 1:
					return 'No retener (IVA pequeño Contribuyente)';
				break;
				case 2:
					return 'No retener (IVA pequeño Contribuyente agropeguario)';
				break;
			}
		}else if ($id_frase == 8) {
			switch ($id_codigo) {
				case 1:
					return 'Exenta del ISR (art. 8 núm. 2 Ley de Actualización Tributaria)';
				break;
				case 2:
					return 'Exenta del ISR (art. 8 núm. 3 Ley de Actualización Tributaria)';
				break;
				case 3:
					return 'Exenta del ISR (art. 8 núm. 5 Ley de Actualización Tributaria)';
				break;
				case 4:
					return 'Exenta del ISR (art. 11 núm. 1 Ley de Actualización Tributaria)';
				break;
				case 5:
					return 'Exenta del ISR (art. 11 núm. 2 Ley de Actualización Tributaria';
				break;
				case 6:
					return 'Exenta del ISR (art. 11 núm. 2 Ley de Actualización Tributaria)';
				break;
				case 7:
					return 'Exenta del ISR (art. 32 litar a, Ley Orgánica Zolic)';
				break;
				case 8:
					return 'Exenta del ISR (art. 8 núm. 1 Ley de Actualización Tributaria)';
				break;
				case 9:
					return 'Exenta del ISR (Art. 4, literal b), numeral ii, Dec. 40-2022, Ley inc. Mov. Eléctrica)';
				break;
				case 10:
					return 'Exenta del ISR (Art. 4, literal f, Dec. 40-2022, Ley Inc. Mov. Eléctrica)';
				break;
				case 11:
					return 'Exenta del ISR (Art. 7, literal g, Dec. 40-2022, Ley Inc. Mov, Eléctrica)';
				break;
			}
		}
	}

    $id = addslashes($_GET['id']);
    $empresa = addslashes($_GET['empresa']);

	$query = $conexion->query("SELECT (SELECT CONTENIDO FROM tblempresas_prefe WHERE ID_PREFERENCIA = 87 AND ID_EMPRESA = '$empresa') AS FEL, (SELECT CONTENIDO FROM bgzeri_empresa.tblsucursales_prefe WHERE ID_SUCURSAL = tblsucursales.ID_SUCURSAL AND ID_PREFE = 1) AS FEL_SUCU, (SELECT CONTENIDO FROM bgzeri_empresa.tblsucursales_prefe WHERE ID_SUCURSAL = tblsucursales.ID_SUCURSAL AND ID_PREFE = 7) AS NOMBRE_COMERCIAL_SUCU, (SELECT CONTENIDO FROM tblempresas_prefe WHERE ID_PREFERENCIA = 83 AND ID_EMPRESA = '$empresa') AS NOMBRE_COMERCIAL_EMP, tblsucursales.TELEFONO AS TELE_SUCU, tblsucursales.ID_SUCURSAL, tblsucursales.DIRECCION AS DIRECCION_SUCU, tblsucursales.NOMBRE AS NOMBRE_EMPRESA_SUCU, tblempresas_.NOMBRE_EMPRESA, tblsucursales.RUTA AS RUTA_SUCU, tblsucursales.FOTO, tblfacturas.ESTADO, tblfacturas.DTE, tblclientes.FACTURAR_A, tblclientes.ORGANIZACION, tblfacturar.NOMBRE AS NOMBRE_F, tblfacturar.APELLIDOS AS APELLIDOS_F, tblfacturas.DESCUENTO, tblfacturas.ID_SERIE, tblfacturas.ID_FACT, tblfacturas_series.TIPO, tblfacturas_series.TICKET, tblfacturas_series.SERIE, tblfacturas.NO, tblempresas_perfil.TELEFONO, tblempresas_perfil.LOGO_URL, tblempresas_perfil.LOGO_NOM, tblempresas_perfil.DIRECCION, tblusuarios.ID_USUARIO AS ID_CLIENTE, tblusuarios.NOMBRE, tblusuarios.APELLIDOS, tblfacturas.DIRECCION AS DIRECCION_CLI, tblusuarios_perfil.TELEFONO AS TELEFONO_USU, tblusuarios_perfil.NIT, tblfacturas.FECHA, tblfacturas.FECHA_V, tblfacturas.ID_VENDEDOR, tblusuarios_2.NOMBRE AS NOMBRE_V, tblusuarios_2.APELLIDOS AS APELLIDOS_V, tblfacturas.TOTAL, tblformaspago_pred.FORMA, tblfacturas.OBSER, tblfacturas_series.OBSERVACIONES, tblfacturas_series.RUTA, tblfacturas_series.PLANTILLA, tblempresas_prefe.CONTENIDO FROM bgzeri_empresa.tblfacturas INNER JOIN tblusuarios ON tblfacturas.ID_USUARIO = tblusuarios.ID_USUARIO INNER JOIN tblusuarios_perfil ON tblusuarios.ID_USUARIO = tblusuarios_perfil.ID_USUARIO INNER JOIN bgzeri_empresa.tblfacturas_series ON tblfacturas.ID_SERIE = tblfacturas_series.ID_SERIE INNER JOIN tblempresas_ ON tblfacturas.ID_EMPRESA = tblempresas_.ID_EMPRESA INNER JOIN tblempresas_perfil ON tblempresas_.ID_EMPRESA = tblempresas_perfil.ID_EMPRESA INNER JOIN tblusuarios AS tblusuarios_2 ON tblfacturas.ID_VENDEDOR = tblusuarios_2.ID_USUARIO INNER JOIN bgzeri_dbzeri.tblformaspago_pred ON tblfacturas.TERMINOS = tblformaspago_pred.ID_PAGO_PRED INNER JOIN tblempresas_prefe ON tblempresas_prefe.ID_EMPRESA = tblfacturas.ID_EMPRESA LEFT JOIN bgzeri_empresa.tblclientes ON tblclientes.ID_USUARIO = tblfacturas.ID_USUARIO LEFT JOIN tblusuarios AS tblfacturar ON tblfacturar.ID_USUARIO = tblclientes.FACTURAR_A INNER JOIN bgzeri_empresa.tblsucursales ON tblsucursales.ID_SUCURSAL = tblfacturas_series.ID_SUCURSAL WHERE tblfacturas.ID_FACT = '$id' AND tblempresas_prefe.ID_PREFERENCIA = 2 AND tblfacturas.ID_EMPRESA = '$empresa'");
	$matriz_factura = array();
	while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
		$moneda = $row["CONTENIDO"];
		if (!empty($row["DTE"])) {
	        $xml = simplexml_load_string(str_replace("dte:", '', $row["DTE"]));
	        $autoriza = (String) $xml->SAT->DTE->Certificacion->NumeroAutorizacion;
	        $serie = (String) substr($xml->SAT->DTE->Certificacion->NumeroAutorizacion, 0, 8);
	        $numero_serie = (String) hexdec(str_replace("-", "", substr($xml->SAT->DTE->Certificacion->NumeroAutorizacion, 9, 9)));
	        $FRASES = $xml->SAT->DTE->DatosEmision->Frases->Frase;

	        $matriz_frase = array();
	        for ($i = 0; $i < count($FRASES); $i++) {
          		$CodigoEscenario = $xml->SAT->DTE->DatosEmision->Frases->Frase[$i]->attributes()->CodigoEscenario;
          		$TipoFrase = $xml->SAT->DTE->DatosEmision->Frases->Frase[$i]->attributes()->TipoFrase;

          		$matriz_frase[$i] = Frase($TipoFrase, $CodigoEscenario);
          	}

  			$certificador = (String) $xml->SAT->DTE->Certificacion->NombreCertificador;
  			$nit_cert = (String) $xml->SAT->DTE->Certificacion->NITCertificador;
  			$fecha_cert = (String) $xml->SAT->DTE->Certificacion->FechaHoraCertificacion;
  			if (empty($row["NIT"]) || $row["NIT"] == 'C/F') {
  				$nit_receptor = 'CF';
  			}else{
  				$a = array("-", "/", "\\");
    			$b = array("", "", "");
  				$nit_receptor = str_replace($a, $b, $row['NIT']);
  			}
  			$NIT_EMISOR = (String) $xml->SAT->DTE->DatosEmision->Emisor->attributes()->NITEmisor;
  			$url = (String) 'https://felpub.c.sat.gob.gt/verificador-web/publico/vistas/verificacionDte.jsf%3Ftipo=autorizacion%26numero='.$autoriza.'%26emisor='.$NIT_EMISOR.'%26receptor='.$nit_receptor.'%26monto=' . number_format($row["TOTAL"], 2, '.', '');

	        $row["FRASES"] = (count($matriz_frase)==0)?array():$matriz_frase;
	        $row["NIT_EMISOR"] = $NIT_EMISOR;
	        $row["CERTIFICADOR"] = $certificador;
	        $row["NIT_CERT"] = $nit_cert;
	        $row["FECHA_CERT"] = $fecha_cert;

	        $row["DTE"] = $autoriza;
	        $row["SERIE_DTE"] = $serie;
	        $row["NO_DTE"] = $numero_serie;
	        //$row["QR"] = "https://chart.googleapis.com/chart?chs=150x150&amp;cht=qr&amp;chld=M%7CPT+6&amp;chl=".$url;
	        $row["QR"] = $url;
	        $row["TOTAL_LETAS"] = strtolower(numtoletras($row["TOTAL"]));

	        $dia = date('d', strtotime($row['FECHA']));
    		$mes = date('m', strtotime($row['FECHA']));
    		$agno = date('Y', strtotime($row['FECHA']));

	        $row["FECHA_LETRAS"] = $dia . " de " . ObtenerMes($mes) . " de " . $agno;
	    }else{
	        $row["FRASES"] = array();
	        if (empty($row["NIT"]) || $row["NIT"] == 'C/F') {
  				$nit_receptor = 'CF';
  			}else{
  				$nit_receptor = $row["NIT"];
  			}
	        $row["NIT_EMISOR"] = '';
	        $row["NIT"] = $nit_receptor;
	        $row["CERTIFICADOR"] = '';
	        $row["NIT_CERT"] = '';
	        $row["FECHA_CERT"] = '';

	        $row["DTE"] = '';
	        $row["SERIE_DTE"] = '';
	        $row["NO_DTE"] = '';
	        $row["QR"] = '';
	        $row["TOTAL_LETAS"] = strtolower(numtoletras($row["TOTAL"]));

	        $dia = date('d', strtotime($row['FECHA']));
		    $mes = date('m', strtotime($row['FECHA']));
		    $agno = date('Y', strtotime($row['FECHA']));

	        $row["FECHA_LETRAS"] = $dia . " de " . ObtenerMes($mes) . " de " . $agno;
	    }

	    if (empty($row["NOMBRE_F"]) || $row["NOMBRE_F"] == null) {
	    	$row["NOMBRE_F"] = '';
	    }

	    if (empty($row["APELLIDOS_F"]) || $row["APELLIDOS_F"] == null) {
	    	$row["APELLIDOS_F"] = '';
	    }

		$matriz_factura["ENCABEZADO"] = $row;
	}

	$detelle = $conexion->query("SELECT tblprod_detalles_valores.CONTENIDO AS UNIDAD_METRICA, tblproductos.ID_PROD, tblproductos.CODIGO, tblfacturas_det.DESCRIPCION, tblfacturas_det.COSTO, tblfacturas_det.ID_FACT, tblproductos.CODIGO, tblproductos.PRODUCTO, tblfacturas_det.CANTIDAD, tblfacturas_det.PRECIO FROM bgzeri_empresa.tblfacturas_det INNER JOIN bgzeri_empresa.tblproductos ON tblfacturas_det.ID_PROD = tblproductos.ID_PROD LEFT JOIN bgzeri_empresa.tblprod_detalles_valores ON tblprod_detalles_valores.ID_PROD = tblproductos.ID_PROD AND tblprod_detalles_valores.ID_DETALLE_P = 33 WHERE tblfacturas_det.ID_FACT = '$id'");
	$matriz_factura["DETALLE"] = array();
	while ($row = $detelle->fetch(PDO::FETCH_ASSOC)) {
		/*if (empty($row["CONTENIDO"])) {
			$row["CONTENIDO"] = '';
		}*/
		$row["CONTENIDO"] = $moneda;
		$matriz_factura["DETALLE"][] = $row;
	}

	echo json_encode($matriz_factura);
 ?>