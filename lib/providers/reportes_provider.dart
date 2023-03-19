import 'dart:convert';

import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReporteProvider extends ChangeNotifier {
  final String _baseUrl = "app.gozeri.com";

  String id_sucu_reportes = 'all';

  Future id_suc_reporte(String valor) async {
    id_sucu_reportes = valor;
    notifyListeners();
  }

  Future ventas_excel() async {
    final empresa = Preferencias.data_empresa;

    print(
        "https://admin.gozeri.com/app_facturacion/reportes_venta.php?xls&empresa=47&sucursal=all&fecha_inicio=2023-01-01&fecha_fin=2023-03-31");
    final Uri uri = Uri.parse(
        "https://admin.gozeri.com/app_facturacion/reportes_venta.php?xls&empresa=47&sucursal=all&fecha_inicio=2023-01-01&fecha_fin=2023-03-31");

    final resp = await http.get(uri);
    var js = json.decode(resp.body);
    print('se genero');
    print(js['message']);

    return js;
  }


}