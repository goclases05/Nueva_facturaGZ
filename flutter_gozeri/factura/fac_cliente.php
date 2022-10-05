<?php
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
    include('../conex.php');
    
    if($accion=='read'){
        $select=$conexion->query("SELECT bgzeri_dbzeri.tblusuarios.ID_USUARIO, bgzeri_dbzeri.tblusuarios.NOMBRE, bgzeri_dbzeri.tblusuarios.APELLIDOS, bgzeri_dbzeri.tblusuarios_perfil.NIT FROM bgzeri_empresa.tblfacturas_list_temp INNER JOIN bgzeri_dbzeri.tblusuarios ON tblusuarios.ID_USUARIO=bgzeri_empresa.tblfacturas_list_temp.ID_CLIENTE INNER JOIN bgzeri_dbzeri.tblusuarios_perfil ON bgzeri_dbzeri.tblusuarios_perfil.ID_USUARIO=tblusuarios.ID_USUARIO WHERE ID_FACT_TMP=$tmp");

        $clients = array(); $i = 0;
        while ($row = $select->fetch(PDO::FETCH_ASSOC)) {
            $nt=($row['NIT']==null || empty($row['NIT']))?'CF':$row['NIT'];
            $clients["label"] = $row["NOMBRE"].' '.$row["APELLIDOS"].' ('.$nt.')';
            $clients["id"] = $row["ID_USUARIO"];
            $clients['nit']=$nt;
            $i++;
        }

        if ($i == 0) {
            $clients["label"] = '';
            $clients["id"] = '';
            $clients['nit']='';
            $i++;
        }

        echo json_encode($clients);
    }else if($accion=='remove'){

        $select=$conexion->query("UPDATE bgzeri_empresa.tblfacturas_list_temp SET `ID_CLIENTE` = '$cliente' WHERE `tblfacturas_list_temp`.`ID_FACT_TMP` = '$tmp';");
        if($select){
            echo 'OK';
        }else{
            echo 'ERROR';
        }
    }
    

?>