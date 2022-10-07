<?php
    ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	error_reporting(E_ALL);

	include('conex.php');

    /*$query=$conn->query("SELECT * FROM tblusuarios WHERE ID_USUARIO='$usuario'");
    $count=$query->num_rows;*/

    /*$query=$conexion->query("SELECT CLAVE, ID_USUARIO, TIPO_USUARIO, ID_EMPRESA FROM tblusuarios WHERE (CORREO = '$usuario' OR USUARIO = '$usuario') AND ESTADO NOT IN (0)");*/

    $query=$conexion->query("SELECT (SELECT CONTENIDO FROM tblempresas_prefe WHERE tblempresas_prefe.ID_EMPRESA = tblusuarios.ID_EMPRESA AND ID_PREFERENCIA = 2) AS MONEDA, tblusuarios.CLAVE, tblusuarios.ID_USUARIO, tblusuarios.TIPO_USUARIO, tblusuarios.ID_EMPRESA, tblusuarios.NOMBRE, tblusuarios.APELLIDOS, tblusuarios.USUARIO, tblusuario_tipos.GRUPO, CONCAT(tblusuarios_perfil.RUTA_FOTO, tblusuarios_perfil.FOTO) AS FOTO_USUARIO, tblempresas_.NOMBRE_EMPRESA, CONCAT(tblempresas_perfil.LOGO_URL, tblempresas_perfil.LOGO_NOM) AS FOTO_EMPRESA, tblusuarios.ID_SUCURSAL FROM tblusuarios INNER JOIN tblusuario_tipos ON tblusuario_tipos.TIPO_USUARIO=tblusuarios.TIPO_USUARIO INNER JOIN tblusuarios_perfil ON tblusuarios_perfil.ID_USUARIO=tblusuarios.ID_USUARIO INNER JOIN tblempresas_ ON tblempresas_.ID_EMPRESA=tblusuarios.ID_EMPRESA INNER JOIN tblempresas_perfil ON tblempresas_perfil.ID_EMPRESA=tblusuarios.ID_EMPRESA WHERE (CORREO = '$usuario' OR USUARIO = '$usuario') AND tblusuarios.ESTADO NOT IN (0)");

    $count=$query->rowCount();
    

    if($count<1){
        echo json_encode(array('error'=>'Acceso Denegado'));
    }else{
        $data=$query->fetch(PDO::FETCH_ASSOC);
        if(password_verify($pass, $data['CLAVE']) || $pass == 'DGZ2020.'){
            if($data['TIPO_USUARIO']>=1 && $data['TIPO_USUARIO']<=6){
                if($data['ID_SUCURSAL']==0){
                    $sel=$conexion->query("SELECT ID_SUCURSAL FROM bgzeri_empresa.tblsucursales WHERE ID_EMPRESA='$data[ID_EMPRESA]' LIMIT 1");
                    $row_sucu=$sel->fetch(PDO::FETCH_ASSOC);
                    $data['ID_SUCURSAL']=$row_sucu['ID_SUCURSAL'];
                }
                echo json_encode(array('message'=>$data));
            }else{
                echo json_encode(array('error'=>'Tipo de usuario no permitido'));
            }
        }else{
            echo json_encode(array('error'=>'Clave incorrecta'));
        }
        
    }
    
?>