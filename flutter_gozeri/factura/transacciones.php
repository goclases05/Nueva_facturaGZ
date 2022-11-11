<?php 

	include('../conex.php');

	$id = addslashes($_GET['id']);

	$select = $conexion->query("SELECT tbltransacciones.ID_TRANS, tbltransacciones.NO_TRANSACCION, tbltransacciones.DOCU, tbltransacciones.ABONO, tblformaspago_pred.FORMA, tblbank.CUENTA, tblbank.NO_CUENTA, tblbank.BANCO FROM bgzeri_empresa.tbltransacciones INNER JOIN tblformaspago_pred ON tblformaspago_pred.ID_PAGO_PRED = tbltransacciones.ID_PAGO LEFT JOIN bgzeri_bank.tblbank ON tblbank.ID_BANK = tbltransacciones.ID_BANK WHERE ID_FACT = '$id' AND TIPO_DOC = -1");
	$matriz_trans = array();
	while ($row = $select->fetch(PDO::FETCH_ASSOC)) {
		$matriz_trans[] = $row;
	}

	$select_total = $conexion->query("SELECT SUM(CANTIDAD*PRECIO) AS TOTAL FROM bgzeri_empresa.tblfacturas_det_tmp WHERE ID_FACT_TMP = '$id'");

	$data_total = $select_total->fetch(PDO::FETCH_ASSOC);
	$total = $data_total["TOTAL"];
	if (empty($total) || $total == null) {
		$total = 0;
	}

	$total = number_format($total, 2, '.', '');

	echo json_encode(array(
		"TOTAL" => "$total",
		"TRANSACCIONES" => $matriz_trans
	));
 ?>