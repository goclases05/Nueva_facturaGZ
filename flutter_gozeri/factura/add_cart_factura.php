<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include('../conex.php');


//TODO: empresa, id_usuario
//verifica si la empresa y el usuario son correctos
function recorre_hijos($prod, $id_fact, $idusuario, $id_insert,$conexion,$fac_ped_recu){
    $select_combo=$conexion->query("SELECT * FROM bgzeri_empresa.tblproductos_combos WHERE `ID_PADRE` = $prod");
    if($select_combo->rowCount() >=1){
        while($row=$select_combo->fetch_assoc()){
            if(empty($fac_ped_recu)){
                $insert = $conexion->query("INSERT INTO bgzeri_empresa.tblfacturas_det_tmp (ID_FACT_TMP, ID_USUARIO, ID_PROD, COSTO, CANTIDAD, PRECIO, ID_PADRE) VALUES ('$id_fact','$idusuario','".$row['ID_PROD']."','0','".$row['CANTIDAD']."','0','".$id_insert."')");
            }else{
                $insert = $conexion->query("INSERT INTO bgzeri_empresa.tblfacturas_progra_det (ID_PROG, ID_USUARIO, ID_PROD, COSTO, CANTIDAD, PRECIO, ID_PADRE) VALUES ('$id_fact','$idusuario','".$row['ID_PROD']."','0','".$row['CANTIDAD']."','0','".$id_insert."')");
            }
            $id=$conexion->insert_id;
            recorre_hijos($row['ID_PROD'], $id_fact, $idusuario, $id, $conexion, $fac_ped_recu);
        }
    }
}

/*
id_prod
id_fact
idusuario
cantida
precio
*/


$select = $conexion->query("SELECT COSTO, PRECIO AS PRECIO_1, PRECIO_2, PRECIO_3, PRECIO_4 FROM bgzeri_empresa.tblproductos WHERE ID_PROD = '$id_prod'");
$data = $select->fetch(PDO::FETCH_ASSOC);
$costo = $data["COSTO"];
$select->closeCursor();

if (empty($precio)) {
    $precio = $data["PRECIO_1"];
    $tipo_precio = 1;
}else{
    $tipo_precio = 0;
    for ($i=1; $i <= 4; $i++) { 
        if ($data["PRECIO_".$i] == $precio) {
            $tipo_precio = $i;
            break;
        }
    }
}

$fac_ped_recu = '';
$select = $conexion->query("SELECT ID_TMP FROM bgzeri_empresa.tblfacturas_det_tmp WHERE ID_FACT_TMP = '$id_fact' AND ID_PROD = '$id_prod' AND PRECIO = '$precio'");
$data_prod = $select->fetch(PDO::FETCH_ASSOC);
$select->closeCursor();



if (empty($data_prod["ID_TMP"])) {

    /*$impuestos = $conexion->query("SELECT tblimpuestos_tipos.CODIGO AS CODIGO_G, tblimpuestos.NOMBRE_CORTO, tblimpuestos.SUMAR_MONTO, tblimpuestos_tipos.ID_IMPUESTO, tblimpuestos_tipos.CODIGO, tblproductos_impuestos.ID, tblimpuestos.NOMBRE, tblimpuestos.SIGLA, tblimpuestos_tipos.NOMBRE AS TIPO, tblimpuestos_tipos.ISO, tblimpuestos_tipos.MONTO FROM bgzeri_empresa.tblproductos_impuestos INNER JOIN bgzeri_empresa.tblimpuestos_tipos ON tblimpuestos_tipos.ID_IMP_TIPO = tblproductos_impuestos.ID_IMP_TIPO INNER JOIN bgzeri_empresa.tblimpuestos ON tblimpuestos.ID_IMPUESTO = tblimpuestos_tipos.ID_IMPUESTO WHERE tblproductos_impuestos.ID_PROD = '$id_prod'");
		$monto = 0;
		while ($value = $impuestos->fetch(PDO::FETCH_ASSOC)) {
			$precios = '';
			if ($value["ID_IMPUESTO"] == 1 && $value["CODIGO"] == 2) {

			}else{
				if ($value["SUMAR_MONTO"] == 1) {
					if ($value["ISO"] == 'GTQ') {
						$monto += $value["MONTO"];
					}else if ($value["ISO"] == 'USD') {
						$monto += $value["MONTO"]*7.72;
					}else if ($value["ISO"] == '%') {
						$monto += round((((($precio)/"1.".$value["MONTO"])*$value["MONTO"])/100), 2);
					}
				}
			}
		}
        $precio=$precio+$monto;*/
    $cantida = round($cantida,2);
    $insert = $conexion->query("INSERT INTO bgzeri_empresa.tblfacturas_det_tmp (ID_FACT_TMP, ID_USUARIO, ID_PROD, COSTO, CANTIDAD, PRECIO, TIPO_PRECIO) VALUES ('$id_fact','$idusuario','$id_prod','$costo','$cantida','$precio', $tipo_precio)");
    $id_insert=$conexion->lastInsertId();
}else{
    $insert = $conexion->query("UPDATE bgzeri_empresa.tblfacturas_det_tmp SET CANTIDAD = (CANTIDAD+$cantida) WHERE ID_FACT_TMP = '$id_fact' AND ID_PROD = '$id_prod' AND PRECIO = '$precio'");
    $id_insert=$data_prod["ID_TMP"];
}

if ($insert) {
    recorre_hijos($id_prod, $id_fact, $idusuario, $id_insert,$conexion,$fac_ped_recu);
    echo 'OK';
}else{
    echo 'Error';
}


?>