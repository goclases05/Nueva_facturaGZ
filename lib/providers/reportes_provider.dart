import 'dart:convert';

import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReporteProvider extends ChangeNotifier {
  final String _baseUrl = "app.gozeri.com";

  String id_sucu_reportes = 'all';
  String fecha_inicio = '${DateFormat('yyyy-MM-d').format(DateTime.now())}';
  String fecha_fin = '${DateFormat('yyyy-MM-d').format(DateTime.now())}';

  Future id_suc_reporte(String valor) async {
    id_sucu_reportes = valor;
    notifyListeners();
  }

  Future event_fecha_inicio(DateTime? valor) async {
    fecha_inicio = DateFormat('yyyy-MM-dd').format(valor!);
    notifyListeners();
  }

  Future event_fecha_fin(DateTime? valor) async {
    fecha_fin = DateFormat('yyyy-MM-dd').format(valor!);
    notifyListeners();
  }

  Future ventas_excel(String accion) async {
    final empresa = Preferencias.data_empresa;

    print(
        "https://admin.gozeri.com/app_facturacion/reportes_venta.php?${accion}&empresa=${empresa}&sucursal=${id_sucu_reportes}&fecha_inicio=${fecha_inicio}&fecha_fin=${fecha_fin}");
    final Uri uri = Uri.parse(
        "https://admin.gozeri.com/app_facturacion/reportes_venta.php?${accion}&empresa=${empresa}&sucursal=${id_sucu_reportes}&fecha_inicio=${fecha_inicio}&fecha_fin=${fecha_fin}");

    final resp = await http.get(uri);
    var js = json.decode(resp.body);
    print('se genero');
    print(js['message']);

    return js;
  }
}
