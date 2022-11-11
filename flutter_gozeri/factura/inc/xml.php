<?php 
	function xml($ISO, $tipo_fact, $afiliacion, $codigo_est, $correoE, $NITE,$nombreC,$nombreE,$direccionE,$municipioE, $departamentoE, $paisE, $correoR, $NITR, $nombreR, $direccionR, $municipioR, $departamentoR, $paisR, $productos, $descuento, $complementos, $conexion, $direccion, $fecha, $certificar_por_sucu, $sucursal, $empresa){
		$a = array(" ","-","/","\\");
		$b = array("","","","");
		$tipo = "(TIPO_FRASE = 0";
		if ($tipo_fact == 'FACT' || $tipo_fact == 'FCAM' || $tipo_fact == 'NCRE' || $tipo_fact == 'NDEB') {
			$tipo .= " OR TIPO_FRASE = 1";
		}
		if ($tipo_fact == 'FACT' || $tipo_fact == 'FCAM' || $tipo_fact == 'NCRE' || $tipo_fact == 'NDEB') {
			$tipo .= " OR TIPO_FRASE = 2";
		}
		if ($tipo_fact == 'FPEQ' || $tipo_fact == 'FCAP' || $tipo_fact == 'FACA' || $tipo_fact == 'FCCA' || $tipo_fact == 'FAPE' || $tipo_fact == 'FCPE' || $tipo_fact == 'FAAE' || $tipo_fact == 'FCAE') {
			$tipo .= " OR TIPO_FRASE = 3";
		}
		if ($tipo_fact == 'FACT' || $tipo_fact == 'FCAM' || $tipo_fact == 'RDON' || $tipo_fact == 'RECI' || $tipo_fact == 'FESP' || $tipo_fact == 'NCRE' || $tipo_fact == 'NDEB') {
			$tipo .= " OR TIPO_FRASE = 4";
		}
		if ($tipo_fact == 'FESP') {
			$tipo .= " OR TIPO_FRASE = 5";
		}
		if ($tipo_fact == 'FACA' || $tipo_fact == 'FCCA') {
			$tipo .= " OR TIPO_FRASE = 6";
		}
		if ($tipo_fact == 'FAPE' || $tipo_fact == 'FCPE' || $tipo_fact == 'FAAE' || $tipo_fact == 'FCAE') {
			$tipo .= " OR TIPO_FRASE = 7";
		}
		if ($tipo_fact == 'FACT' || $tipo_fact == 'FCAM' || $tipo_fact == 'RDON' || $tipo_fact == 'RECI' || $tipo_fact == 'NCRE' || $tipo_fact == 'NDEB') {
			$tipo .= " OR TIPO_FRASE = 8";
		}
		if ($tipo_fact == 'FACT' || $tipo_fact == 'FCAM' || $tipo_fact == 'FPEQ' || $tipo_fact == 'FCAP' || $tipo_fact == 'NCRE' || $tipo_fact == 'NDEB') {
			$tipo .= " OR TIPO_FRASE = 9";
		}
		$tipo .= ")";
		if ($certificar_por_sucu == 1) {
			$frases_query = $conexion->query("SELECT TIPO_FRASE, CODIGO FROM tblfrases_empresas WHERE ID_SUCURSAL = '$sucursal' AND $tipo");
		}else{
			$frases_query = $conexion->query("SELECT TIPO_FRASE, CODIGO FROM tblfrases_empresas WHERE ID_EMPRESA = '$empresa' AND ID_SUCURSAL = 0 AND $tipo");
		}
		$frases = '';
		while ($fra = $frases_query->fetch(PDO::FETCH_ASSOC)) {
			if ($tipo_fact == 'NCRE' && $fra["TIPO_FRASE"] == 4) {
				if ($fra["CODIGO"] == 22) {
					# code...
				}else{
					continue;
				}
			}else if ($tipo_fact == 'FACT' && $fra["TIPO_FRASE"] == 4) {
				if ($fra["CODIGO"] == 22) {
					continue;
				}else{

				}
			}

			$frases .= '<dte:Frase CodigoEscenario="'.$fra["CODIGO"].'" TipoFrase="'.$fra["TIPO_FRASE"].'"/>';

		}

		$nombreR = str_replace("&", "&amp;", $nombreR);

		if (empty($direccion)) {
			$direccion = 'ciudad';
		}
		$xml = '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
			<dte:GTDocumento xmlns:dte="http://www.sat.gob.gt/dte/fel/0.2.0" Version="0.1">
				<dte:SAT ClaseDocumento="dte">
					<dte:DTE ID="DatosCertificados">
						<dte:DatosEmision ID="DatosEmision">
							<dte:DatosGenerales CodigoMoneda="'.$ISO.'" FechaHoraEmision="'.date('Y-m-d\TH:i:s.vP', strtotime($fecha)).'" Tipo="'.$tipo_fact.'"/>
							<dte:Emisor AfiliacionIVA="'.$afiliacion.'" CodigoEstablecimiento="'.$codigo_est.'" CorreoEmisor="'.$correoE.'" NITEmisor="'.str_replace($a, $b, $NITE).'" NombreComercial="'.$nombreC.'" NombreEmisor="'.$nombreE.'">
								<dte:DireccionEmisor>
									<dte:Direccion>'.$direccionE.'</dte:Direccion>
									<dte:CodigoPostal>0</dte:CodigoPostal>
									<dte:Municipio>'.$municipioE.'</dte:Municipio>
									<dte:Departamento>'.$departamentoE.'</dte:Departamento>
									<dte:Pais>'.$paisE.'</dte:Pais>
								</dte:DireccionEmisor>
							</dte:Emisor>
							<dte:Receptor CorreoReceptor="'.$correoR.'" IDReceptor="'.str_replace($a, $b, $NITR).'" NombreReceptor="'.$nombreR.'">
								<dte:DireccionReceptor>
									<dte:Direccion>'.$direccion.'</dte:Direccion>
									<dte:CodigoPostal>0</dte:CodigoPostal>
									<dte:Municipio>'.$municipioE.'</dte:Municipio>
									<dte:Departamento>'.$departamentoE.'</dte:Departamento>
									<dte:Pais>'.$paisE.'</dte:Pais>
								</dte:DireccionReceptor>
							</dte:Receptor>';

								$xml .= '
								<dte:Frases>
									'.$frases.'
								</dte:Frases>';

							$xml .= '
							<dte:Items>';
								$i = 1; $total_i = 0; $total_f = 0; $exento = 0;
								foreach ($productos as $key) {
									$empresa = $key["ID_EMPRESA"];
									$id = $key["ID_PROD"];

									if ($key["CATEGORIA"] == "SERVICIOS") {
										$tipo = 'S';
									}else{
										$tipo = 'B';
									}
									if (empty($key["DESCRIPCION"])) {
										$descripcion = $key["PRODUCTO"];
									}else{
										$descripcion = $key["PRODUCTO"].': '.$key["DESCRIPCION"];
									}

									// - Impuestos
									$impuestos = $conexion->query("SELECT tblimpuestos_tipos.CODIGO AS CODIGO_G, tblimpuestos.NOMBRE_CORTO, tblimpuestos.SUMAR_MONTO, tblimpuestos_tipos.ID_IMPUESTO, tblimpuestos_tipos.CODIGO, tblproductos_impuestos.ID, tblimpuestos.NOMBRE, tblimpuestos.SIGLA, tblimpuestos_tipos.NOMBRE AS TIPO, tblimpuestos_tipos.ISO, tblimpuestos_tipos.MONTO FROM bgzeri_empresa.tblproductos_impuestos INNER JOIN bgzeri_empresa.tblimpuestos_tipos ON tblimpuestos_tipos.ID_IMP_TIPO = tblproductos_impuestos.ID_IMP_TIPO INNER JOIN bgzeri_empresa.tblimpuestos ON tblimpuestos.ID_IMPUESTO = tblimpuestos_tipos.ID_IMPUESTO WHERE tblproductos_impuestos.ID_PROD = '$id'");
									$iva0 = 0;
									$matriz_impuestos = array();
									$u = 0;
									$impuesto = 0;
									while ($row = $impuestos->fetch(PDO::FETCH_ASSOC)) {
										if ($row["ID_IMPUESTO"] == 1 && $row["CODIGO"] == 2) {
											$iva0 = 1;
										}else{
											$u++;
											$matriz_impuestos[] = $row;
											if ($row["SUMAR_MONTO"] == 1) {
												if ($row["ISO"] == 'GTQ') {
													$impuesto += $row["MONTO"];
												}else if ($row["ISO"] == 'USD') {
													$impuesto += $row["MONTO"]*7.72;
												}else if ($row["ISO"] == '%') {
													$impuesto += round((((($precio)/("1.".$row["MONTO"]))*$row["MONTO"])/100), 2);
												}
											}
										}
									}
									// ------------------------------------------

									$precio = ($key["PRECIO"]-$impuesto)*$key["CANTIDAD"];
									if ($descuento == 0) {
										$descue = 0;
									}else{
										$descue = ($precio/100)*$descuento;
									}
									$precio_sin = $precio-$descue;

									if ($iva0 == 0) {
										$select = $conexion->query("SELECT CONTENIDO FROM tblempresas_prefe WHERE ID_EMPRESA = '$empresa' AND ID_PREFERENCIA = 99");
										$data = $select->fetch(PDO::FETCH_ASSOC);
										$iva = round( ( ( ($precio_sin/("1.".$data["CONTENIDO"]))*$data["CONTENIDO"])/100), 2);
									}else{
										$iva = 0;
									}
									$grava = $precio_sin-$iva;
									$total = $precio-$descue;
									$total_i += $iva;
									$xml .= '<dte:Item BienOServicio="'.$tipo.'" NumeroLinea="'.$i.'">
									<dte:Cantidad>'.$key["CANTIDAD"].'</dte:Cantidad>
									<dte:UnidadMedida>UNI</dte:UnidadMedida>
									<dte:Descripcion>'.$descripcion.'</dte:Descripcion>
									<dte:PrecioUnitario>'.($key["PRECIO"]-$impuesto).'</dte:PrecioUnitario>
									<dte:Precio>'.(number_format($precio,2,".","")).'</dte:Precio>
									<dte:Descuento>'.(number_format($descue,2,".","")).'</dte:Descuento>';
								$total_montos = 0;
								if ($tipo_fact == 'FCAM' || $tipo_fact == 'FACT' || $tipo_fact == 'FESP' || $tipo_fact == 'NCRE') {
									if ($iva0 == 0) {
										$gravable = 1;
									}else{
										$exento = 1;
										$gravable = 2;
									}
									$xml .= '
									<dte:Impuestos>
										<dte:Impuesto>
											<dte:NombreCorto>IVA</dte:NombreCorto>
											<dte:CodigoUnidadGravable>'.$gravable.'</dte:CodigoUnidadGravable>
											<dte:MontoGravable>'.number_format($grava,2,".","").'</dte:MontoGravable>
											<dte:MontoImpuesto>'.number_format($iva,2,".","").'</dte:MontoImpuesto>
										</dte:Impuesto>
									';
									$total_imp = array();
									if ($u > 0) {
										foreach ($matriz_impuestos as $value) {

											if ($value["ISO"] == 'GTQ') {
												$monto = $value["MONTO"];
											}else if ($value["ISO"] == 'USD') {
												$monto = $value["MONTO"]*7.72;
											}else if ($value["ISO"] == '%') {
												$monto = round((((($precio)/"1.".$value["MONTO"])*$value["MONTO"])/100), 2);
											}

											$monto = $monto*$key["CANTIDAD"];
											$xml .='
											<dte:Impuesto>
												<dte:NombreCorto>'.$value["NOMBRE_CORTO"].'</dte:NombreCorto>
												<dte:CodigoUnidadGravable>'.$value["CODIGO_G"].'</dte:CodigoUnidadGravable>
												<dte:CantidadUnidadesGravables>'.$key["CANTIDAD"].'</dte:CantidadUnidadesGravables>
												<dte:MontoImpuesto>'.number_format($monto,2,".","").'</dte:MontoImpuesto>
											</dte:Impuesto>
											';

											if ($value["SUMAR_MONTO"] == 1) {
												if (!isset($total_imp[$value["NOMBRE_CORTO"]])) {
													$total_imp[$value["NOMBRE_CORTO"]] = 0;
												}
												$total_imp[$value["NOMBRE_CORTO"]] += $monto;
												$total_montos += $monto;
											}
										}
									}
									$xml .='
									</dte:Impuestos>
									';
								}
								$xml .= '
									<dte:Total>'.(number_format($total+$total_montos,2,".","")).'</dte:Total>
								</dte:Item>';
								$i++;

								$total_f += ($total+$total_montos);
								}

							$xml .= '</dte:Items>
							<dte:Totales>';
								if ($tipo_fact == 'FCAM' || $tipo_fact == 'FACT' || $tipo_fact == 'FESP' || $tipo_fact == 'NCRE') {
									$xml .= '
								<dte:TotalImpuestos>';
								//if ($iva0 == 0) {
									$xml .= '<dte:TotalImpuesto NombreCorto="IVA" TotalMontoImpuesto="'.(number_format($total_i,2,".","")).'"/>';
								//}

								if (isset($total_imp['Bomberos'])) {
									$xml .= '<dte:TotalImpuesto NombreCorto="Bomberos" TotalMontoImpuesto="'.(number_format($total_imp['Bomberos'],2,".","")).'"/>';
								}
								if (isset($total_imp['PETROLEO'])) {
									$xml .= '<dte:TotalImpuesto NombreCorto="PETROLEO" TotalMontoImpuesto="'.(number_format($total_imp['PETROLEO'],2,".","")).'"/>';
								}
								if (isset($total_imp['Timbre de Prensa'])) {
									$xml .= '<dte:TotalImpuesto NombreCorto="Timbre de Prensa" TotalMontoImpuesto="'.(number_format($total_imp['Timbre de Prensa'],2,".","")).'"/>';
								}
								if (isset($total_imp['Turismo Hospedaje'])) {
									$xml .= '<dte:TotalImpuesto NombreCorto="Turismo Hospedaje" TotalMontoImpuesto="'.(number_format($total_imp['Turismo Hospedaje'],2,".","")).'"/>';
								}
								if (isset($total_imp['Turismo Pasajes'])) {
									$xml .= '<dte:TotalImpuesto NombreCorto="Turismo Pasajes" TotalMontoImpuesto="'.(number_format($total_imp['Turismo Pasajes'],2,".","")).'"/>';
								}

								$xml .= '
								</dte:TotalImpuestos>
									';
								}
								$xml .= '
								<dte:GranTotal>'.(number_format($total_f,2,".","")).'</dte:GranTotal>
							</dte:Totales>';
							if ($tipo_fact == 'FCAM') {
								$xml .= '
							<dte:Complementos>
								<dte:Complemento IDComplemento="1" NombreComplemento="Abono" URIComplemento="http://www.sat.gob.gt/dte/fel/CompCambiaria/0.1.0">
									<cfc:AbonosFacturaCambiaria xmlns:cfc="http://www.sat.gob.gt/dte/fel/CompCambiaria/0.1.0" Version="1">';
									$i = 1;
									foreach ($complementos as $value) {
										$xml .= '
										<cfc:Abono>
											<cfc:NumeroAbono>'.$i.'</cfc:NumeroAbono>
											<cfc:FechaVencimiento>'.$value["VENCE"].'</cfc:FechaVencimiento>
											<cfc:MontoAbono>'.$value["ABONO"].'</cfc:MontoAbono>
										</cfc:Abono>';
										$i++;
									}
									$xml .= '
									</cfc:AbonosFacturaCambiaria>
								</dte:Complemento>
							</dte:Complementos>
							';
							}else if ($tipo_fact == 'FESP') {
								$total_ISR = round((($total_f-$total_i)/100)*5, 2);
								$xml .= '
							<dte:Complementos>
								<dte:Complemento IDComplemento="1" NombreComplemento="RETENCION" URIComplemento="http://www.sat.gob.gt/face2/ComplementoFacturaEspecial/0.1.0">
									<cfe:RetencionesFacturaEspecial xmlns:cfe="http://www.sat.gob.gt/face2/ComplementoFacturaEspecial/0.1.0" Version="1">
										<cfe:RetencionISR>'.(number_format($total_ISR,2,".","")).'</cfe:RetencionISR>
										<cfe:RetencionIVA>'.(number_format($total_i,2,".","")).'</cfe:RetencionIVA>
										<cfe:TotalMenosRetenciones>'.(number_format(($total_f-$total_i-$total_ISR),2,".","")).'</cfe:TotalMenosRetenciones>
									</cfe:RetencionesFacturaEspecial>
								</dte:Complemento>
							</dte:Complementos>
							';
							}else if ($tipo_fact == 'NCRE') {
								$xml .= '
								<dte:Complementos>
									<dte:Complemento IDComplemento="1" NombreComplemento="NOTA CREDITO" URIComplemento="http://www.sat.gob.gt/face2/ComplementoReferenciaNota/0.1.0">
										<cno:ReferenciasNota xmlns:cno="http://www.sat.gob.gt/face2/ComplementoReferenciaNota/0.1.0" FechaEmisionDocumentoOrigen="'.$complementos[0]["FECHA_ORIGEN"].'" MotivoAjuste="'.$complementos[0]["MOTIVO"].'" NumeroAutorizacionDocumentoOrigen="'.$complementos[0]["NO_DTE"].'" Version="1"/>
									</dte:Complemento>
								</dte:Complementos>
								';
							}
						$xml .= '	
						</dte:DatosEmision>
					</dte:DTE>
				</dte:SAT>
			</dte:GTDocumento>
		';

		/*for ($i=1; $i <= 23; $i++) { 
			if ($exento == 0) {
				$xml = str_replace('<dte:Frase CodigoEscenario="'.$i.'" TipoFrase="4"/>', '', $xml);
			}else if ($exento == 1 && ($tipo_fact == 'NCRE' || $tipo_fact == 'NDEB')) {
				if ($i == 22) {
					continue;
				}else{
					$xml = str_replace('<dte:Frase CodigoEscenario="'.$i.'" TipoFrase="4"/>', '', $xml);
				}
			}
		}*/

		return $xml;
	}
 ?>