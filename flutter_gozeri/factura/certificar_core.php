<?php 

  set_time_limit(0);
  # Conexion
  require_once '../app/tools.inc.php';

  # ABRIR CONEXION
  $mysqli = Conectar::getInstance();
  $db     = $mysqli->conexionDB();

  session_name('usuario');
  include "../inc/sesiones.inc.php";
  session_start();

  $id_usuario = $_SESSION['idusuario'];
  $id_empresa = $_SESSION['id_empresa'];
  $empresa = $_SESSION['id_empresa'];

  function hijos($id, $db, $id_sucu,$cantidad){
    $matriz_data=array();
    $matriz_data=array("id"=>$id,"cantidad"=>$cantidad);
    $matriz_hijos = '';
    $matriz_hijos = $db->query("SELECT tblproductos.ID_PROD, tblproductos_combos.CANTIDAD, tblproductos_fotos.URL, tblproductos_fotos.FOTO FROM bgzeri_empresa.tblproductos INNER JOIN bgzeri_empresa.tblproductos_combos ON tblproductos.ID_PROD=tblproductos_combos.ID_PROD INNER JOIN bgzeri_empresa.tblproductos_fotos ON tblproductos_fotos.ID_PROD=tblproductos.ID_PROD AND tblproductos_fotos.TIPO = '1' WHERE `ID_PADRE`='$id'");
    $row=$matriz_hijos->fetch_assoc();
    if($matriz_hijos->num_rows == 0){
      return $matriz_data;
    }else if($matriz_hijos->num_rows == 1){
      return hijos($row["ID_PROD"], $db, $id_sucu, ($row["CANTIDAD"]*$cantidad));
    }else{
      return $matriz_data;
    }
  }

if (isset($_POST["id"])) {

  	$id = addslashes($_POST['id']);
  	$select = $db->query("SELECT *, tblfacturas_series.TIPO AS TIPO_FACT FROM bgzeri_empresa.tblfacturas INNER JOIN bgzeri_empresa.tblfacturas_series ON tblfacturas_series.ID_SERIE = tblfacturas.ID_SERIE WHERE ID_FACT = '$id'");
  	$data = $select->fetch_assoc();

    $id_fac_tmp  = $id;
    $id_cliente  = $data["ID_USUARIO"];
    $id_vendedor = $data["ID_VENDEDOR"];
    if (empty($id_vendedor) || $id_vendedor == 0) {
      $id_vendedor = $id_usuario;
    }
    $condiciones = $data["TERMINOS"];
    $deposito    = $data["DOCUMENTO"];
    $id_serie    = $data["ID_SERIE"];
    $vence       = $data["FECHA_V"];
    $observacion = $data["OBSER"]; 
    $pedido      = 0;
    $descuento   = $data["DESCUENTO"];
    $id_reserva  = 0;
    $prefe_fel   = addslashes($_POST['fel']);
    $tipo_f      = $data["TIPO_FACT"];
    $direccion      = $data["DIRECCION"];
    $sucursal      = $data["ID_SUCURSAL"];
    $fecha = date('Y-m-d H:i:s');

    if (empty($descuento)) {
      $descuento = 0;
    }

    // Obtener productos seleccionados
    $select_productos = $db->query("SELECT tblfacturas_det.ID_FACT_DET, tblfacturas_det.TIPO_PRECIO, tblfacturas_det.ID_PROD, (SELECT COUNT(*) FROM bgzeri_empresa.tblproductos_combos WHERE tblproductos_combos.ID_PADRE= tblfacturas_det.ID_PROD) AS HIJOS, tblfacturas_det.ID_PROD, tblfacturas_det.DESCRIPCION, tblfacturas_det.COSTO, SUM(tblfacturas_det.CANTIDAD) AS CANTIDAD, tblfacturas_det.PRECIO, tblproductos.PRODUCTO, tblproductos.ID_EMPRESA, tbldepartamentos.ID_CATEG AS ID_DEP FROM bgzeri_empresa.tblfacturas_det INNER JOIN bgzeri_empresa.tblproductos ON tblproductos.ID_PROD = tblfacturas_det.ID_PROD INNER JOIN bgzeri_empresa.tblcategorias AS tblsubcategorias ON tblsubcategorias.ID_CATEG = tblproductos.ID_CATEG INNER JOIN bgzeri_empresa.tblcategorias ON tblcategorias.ID_CATEG = tblsubcategorias.ID_PADRE INNER JOIN bgzeri_empresa.tblcategorias AS tbldepartamentos ON tbldepartamentos.ID_CATEG = tblcategorias.ID_PADRE WHERE ID_FACT = '$id' GROUP BY tblfacturas_det.ID_PROD, tblfacturas_det.PRECIO, tblfacturas_det.DESCRIPCION");
    $matriz_productos = array();
    $i = 0;
    $detalle_factura = '';
    $detalle_kardex = '';
    $productos = '';
    $total_fact = 0;
    while ($row = $select_productos->fetch_assoc()) {
      $total_fact = $total_fact+($row["CANTIDAD"]*$row["PRECIO"]);
      $productos .= $row["ID_PROD"].",";
      $matriz_productos[] = $row;
      $i++;
    }

    $descuento = ($total_fact/100)*$descuento;
    $total_fact = $total_fact-$descuento;
    $descuento   = addslashes($data["DESCUENTO"]);

    $productos = substr($productos, 0, -1);
    $select_productos->free();
    if ($i == 0) {
      echo json_encode(
        array(
          "status" => "error",
          "Error" => "No existen productos: Debes agregar Productos a tu Factura",
        )
      );
      die();
    }


    // Obtener Datos de la serie
    $select_serie = $db->query("SELECT SERIE, HASTA, ACTUAL, TIPO, FEL, tblsucursales.TOKEN_FEL, tblsucursales.DIRECCION, tblsucursales.CODIGO, tblsucursales_prefe.CONTENIDO FROM bgzeri_empresa.tblfacturas_series INNER JOIN bgzeri_empresa.tblsucursales ON tblsucursales.ID_SUCURSAL = tblfacturas_series.ID_SUCURSAL INNER JOIN bgzeri_empresa.tblsucursales_prefe ON tblsucursales_prefe.ID_SUCURSAL = tblsucursales.ID_SUCURSAL WHERE ID_SERIE = '$id_serie' AND tblsucursales.ID_EMPRESA = '$id_empresa' AND tblsucursales_prefe.ID_PREFE = 1");
    $data_serie = $select_serie->fetch_assoc();
    $tipo_fact = $data_serie['TIPO'];
    $fel = $data_serie["FEL"];
    $codigo_est = $data_serie['CODIGO'];
    if ($data_serie['CONTENIDO'] == 1) {
      $prefe_fel = $data_serie['CONTENIDO'];
      $certificar_por_sucu = 1;
    }else{
      $certificar_por_sucu = 0;
    }
    $select_serie->free();

    $complementos = array();
    if ($tipo_fact == 'FCAM') {
      $comple = $db->query("SELECT ABONO, VENCE FROM bgzeri_empresa.tblfacturas_complementos WHERE ID_FACT = '$id' ORDER BY ID_COMPLEMENTO ASC");
      while ($row = $comple->fetch_assoc()) {
        $complementos[] = $row;
      }
      $comple->free();
    }
  

  // ***************************************************** FEL
  if ($fel == 1 && $prefe_fel == 1) {
    function gen_uuid($db, $id_empresa) {
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
          mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff )
      );

      $select_uuid = $db->query("SELECT UUID FROM bgzeri_empresa.tblfacturas WHERE ID_EMPRESA = '$id_empresa' AND UUID = '$uuid'");
      $data_uuid = $select_uuid->fetch_assoc();

      if (empty($data_uuid)) {
        return strtoupper($uuid);
      }else{
        gen_uuid($db, $id_empresa);
      }
    }

    if ($certificar_por_sucu == 1) {
      $select_prefes = $db->query("SELECT ID_PREFE, CONTENIDO FROM bgzeri_empresa.tblsucursales_prefe WHERE ID_SUCURSAL = '$sucursal'");
      $prefes = array();
      $prefes_sucu = array();
      while ($row = $select_prefes->fetch_assoc()) {
        $prefes_sucu[$row["ID_PREFE"]] = $row["CONTENIDO"];
      }
      $select_prefes->free();
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
      $select_prefes = $db->query("SELECT ID_PREFERENCIA, CONTENIDO FROM tblempresas_prefe WHERE ID_PREFERENCIA >= '79' AND ID_PREFERENCIA <= '106' AND ID_EMPRESA = '$id_empresa'");
      $prefes = array();
      while ($row = $select_prefes->fetch_assoc()) {
        $prefes[$row["ID_PREFERENCIA"]] = $row["CONTENIDO"];
      }
      $select_prefes->free();
    }

    $select_token = $db->query("SELECT tblempresas_perfil.TOKEN_FEL, tblempresas_perfil.EMAIL, tblempresas_perfil.DIRECCION, tblmunicipios.MUNICIPIO, tbldepartamentos.DEPARTAMENTO, tblpaises.ABREVIA FROM tblempresas_perfil INNER JOIN tblempresas_ ON tblempresas_.ID_EMPRESA = tblempresas_perfil.ID_EMPRESA INNER JOIN tblmunicipios ON tblmunicipios.ID_MUNICIPIO = tblempresas_.ID_MUNICIPIO INNER JOIN tbldepartamentos ON tbldepartamentos.ID_DEPARTAMENTO = tblmunicipios.ID_DEPARTAMENTO INNER JOIN tblpaises ON tblpaises.ID_PAIS = tbldepartamentos.ID_PAIS WHERE tblempresas_perfil.ID_EMPRESA = '$id_empresa'");
    $data_token = $select_token->fetch_assoc();

    if ($certificar_por_sucu == 1) {
      $token = $data_serie["TOKEN_FEL"];
      $direccion_emisor = $data_serie["DIRECCION"];
    }else{
      $token = $data_token["TOKEN_FEL"];
      $direccion_emisor = $data_token["DIRECCION"];
    }

    include_once "../inc/solicitarToken.php";

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
              $update_token = $db->query("UPDATE bgzeri_empresa.tblsucursales SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa' AND ID_SUCURSAL = '$sucursal'");
            }else{
              $update_token = $db->query("UPDATE tblempresas_perfil SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa'");
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
              $update_token = $db->query("UPDATE bgzeri_empresa.tblsucursales SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa' AND ID_SUCURSAL = '$sucursal'");
            }else{
              $update_token = $db->query("UPDATE tblempresas_perfil SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa'");
            }
          }else{
            $error_fel = "Error al solicitar el Token. ".$carga_xml->listado_errores->error->desc_error;
          }
        }else if ($prefes[106] == 3) { #DIGIFACT

          $carga_xml = json_decode($token, true);
          if (isset($carga_xml["Token"])) {
            if ($certificar_por_sucu == 1) {
              $update_token = $db->query("UPDATE bgzeri_empresa.tblsucursales SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa' AND ID_SUCURSAL = '$sucursal'");
            }else{
              $update_token = $db->query("UPDATE tblempresas_perfil SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa'");
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
              $update_token = $db->query("UPDATE bgzeri_empresa.tblsucursales SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa' AND ID_SUCURSAL = '$sucursal'");
            }else{
              $update_token = $db->query("UPDATE tblempresas_perfil SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa'");
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
              $update_token = $db->query("UPDATE bgzeri_empresa.tblsucursales SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa' AND ID_SUCURSAL = '$sucursal'");
            }else{
              $update_token = $db->query("UPDATE tblempresas_perfil SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa'");
            }
          }else{
            $error_fel = "Error al solicitar el Token. ".$carga_xml->listado_errores->error->desc_error;
          }
        }else if ($prefes[106] == 3) { #DIGIFACT

          $carga_xml = json_decode($token, true);
          if (isset($carga_xml["Token"])) {
            if ($certificar_por_sucu == 1) {
              $update_token = $db->query("UPDATE bgzeri_empresa.tblsucursales SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa' AND ID_SUCURSAL = '$sucursal'");
            }else{
              $update_token = $db->query("UPDATE tblempresas_perfil SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$id_empresa'");
            }
          }else{
            $error_fel = $carga_xml["message"]."\n".$carga_xml["description"];
          }

        }

      }
    }

    $select = $db->query("SELECT tblusuarios.NOMBRE, tblusuarios.APELLIDOS, tblusuarios.CORREO, tblusuarios_perfil.NIT FROM tblusuarios INNER JOIN tblusuarios_perfil ON tblusuarios_perfil.ID_USUARIO = tblusuarios.ID_USUARIO WHERE tblusuarios.ID_USUARIO = '$id_cliente'");
    $data_receptor = $select->fetch_assoc();
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

    include_once "../inc/xml.php";

    //$nombres = explode(" ", $data_receptor["NOMBRE"]);
    //$apellidos = explode(" ", $data_receptor["APELLIDOS"]);

    $nombre = $data_receptor["NOMBRE"].' '.$data_receptor["APELLIDOS"];
    
    $document = xml('GTQ', $tipo_fact, $prefes[88], $codigo_est, $prefes[85], $prefes[86], $data_token["EMAIL"], $nit_emisor, $prefes[83], $prefes[81], $direccion_emisor, $data_token["MUNICIPIO"], $data_token["DEPARTAMENTO"], $data_token["ABREVIA"], $data_receptor["CORREO"], $NIT, $nombre, 'ciudad', $data_token["MUNICIPIO"], $data_token["DEPARTAMENTO"], $data_token["ABREVIA"],$matriz_productos, $descuento, $complementos, $db, $prefes[102], $prefes[103], $prefes[104], $prefes[105], $direccion, $fecha);

    $a = array('&Aacute;', '&Eacute;', '&Iacute;', '&Oacute;', '&Uacute;', '&aacute;', '&eacute;', '&iacute;', '&oacute;', '&uacute;','&Ntilde;','&ntilde;');
    $b = array('Á', 'É', 'Í', 'Ó', 'Ú', 'á', 'é', 'í', 'ó', 'ú','Ñ','ñ');
    $c = array('&Agrave;', '&Egrave;', '&Igrave;', '&Ograve;', '&Ugrave;', '&agrave;', '&egrave;', '&igrave;', '&ograve;', '&ugrave;','&Ntilde;','&ntilde;');

    $document = str_replace($a, $b, $document);

    if ($prefes[106] == 1 && !empty($token)) { # MEGAPRINT
      $uuid = gen_uuid($db, $id_empresa);
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
        $xml_firmado = str_replace($a, $b, htmlentities($carga_xml_firm->xml_dte));
        $xml_firmado = str_replace($c, $b, $xml_firmado);
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
            </RegistraDocumentoXMLRequest>
          ';

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
    $status = 'failed';
    $error = "Error en la Factura Electronica";
    echo json_encode(
      array(
        "status" => $status,
        "Error" => $error.' '.$error_fel,
      )
    );
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
	  $update = $db->query("UPDATE bgzeri_empresa.tblfacturas SET UUID = '$uuid', UUID2 = '$uuid_firmado', UUID3 = '$uuid_registra' $xml_r WHERE ID_FACT = '$id'");

	  $status = 'ok';
	  $error = '';
	  $error_fel = '';

	  echo json_encode(
	    array(
	      "status" => $status,
	      "Error" => $error.': '.$error_fel
	    )
	  );
  }

}
 ?>
