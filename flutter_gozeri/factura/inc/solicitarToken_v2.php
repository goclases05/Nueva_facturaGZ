<?php
    //echo "SELECT ID_PREFERENCIA, CONTENIDO FROM tblempresas_prefe WHERE ID_PREFERENCIA >= '79' AND ID_PREFERENCIA <= '106' AND ID_EMPRESA = '$empresa'";
    $select_prefes = $conexion->query("SELECT ID_PREFERENCIA, CONTENIDO FROM tblempresas_prefe WHERE ID_PREFERENCIA >= '79' AND ID_PREFERENCIA <= '106' AND ID_EMPRESA = '$empresa'");
    $prefes = array();
    while ($row = $select_prefes->fetch(PDO::FETCH_ASSOC)) {
    $prefes[$row["ID_PREFERENCIA"]] = $row["CONTENIDO"];
    }
    $select_prefes->closeCursor();

    $select_token = $conexion->query("SELECT tblempresas_perfil.TOKEN_FEL FROM tblempresas_perfil WHERE tblempresas_perfil.ID_EMPRESA = '$empresa' LIMIT 1");
    $data_token = $select_token->fetch(PDO::FETCH_ASSOC);
    $token = $data_token["TOKEN_FEL"];
    $select_token->closeCursor();

    if (empty($token)) {
        include_once "inc/solicitarToken.php";
        $token = solicitarToken($prefes[79], $prefes[80], $prefes[89], $prefes[106]);

        if ($token == 'Curl Error') {
            $error_fel = "Ocurrio un error en el curl al solicitar el token";
        }else{
            $carga_xml = simplexml_load_string($token);
            $tipo_respuesta = $carga_xml->tipo_respuesta;
            if ($tipo_respuesta == 0) {
            $update_token = $conexion->query("UPDATE tblempresas_perfil SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$empresa'");
            }else{
            $error_fel = "Error al solicitar el Token";
            }
        }

    }else{
    $carga_xml = simplexml_load_string($token);
    }

    if (isset($error_fel)) {
        echo json_encode(
            /*array(
            "status" => 'failed',
            "error" => 'Error',
            "Desc" => $error_fel
            )*/
            array(
                "status" => 'failed',
                "error" => $error_fel,
            )
        );
        die();
    }

    $vigencia = strtotime(str_replace("T", " ", $carga_xml->vigencia));

    if ($vigencia < time()) {

        $token = solicitarToken($prefes[79], $prefes[80], $prefes[89], $prefes[106]);

        if ($token == 'Curl Error') {
            $error_fel = "Ocurrio un error en el curl al solicitar el token";
        }else{
            $carga_xml = simplexml_load_string($token);
            $tipo_respuesta = $carga_xml->tipo_respuesta;
            if ($tipo_respuesta == 0) {
            $update_token = $conexion->query("UPDATE tblempresas_perfil SET TOKEN_FEL = '$token' WHERE ID_EMPRESA = '$empresa'");
            }else{
            $error_fel = "Error al solicitar el Token";
            }
        }
    }

    if (isset($error_fel)) {
        echo json_encode(
            array(
                "status" => 'failed',
                "error" => $error_fel,
            )
        );
        die();
    }

    $token = $carga_xml->token;
?>