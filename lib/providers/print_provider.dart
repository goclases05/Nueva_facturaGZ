import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:factura_gozeri/models/view_factura_print.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrintProvider extends ChangeNotifier {
  List<Encabezado> list = [];
  List<Detalle> list_detalle = [];
  bool loading = true;

  PrintProvider() {}

  Future dataFac(String factura) async {
    list.clear();
    list_detalle.clear();
    loading = true;
    notifyListeners();

    final usuario = Preferencias.data_id;
    final empresa = Preferencias.data_empresa;

    print(
        "https://app.gozeri.com/flutter_gozeri/factura/view_print.php?id=${factura}&empresa=${empresa}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/flutter_gozeri/factura/view_print.php?id=${factura}&empresa=${empresa}");

    final resp = await http.get(uri);
    //print(resp.body);

    final js = json.decode(resp.body);
    print(js);
    var result = Encabezado.fromJson(js['ENCABEZADO']);
    //print('kkkk');
    list.add(result);
    int co = js['DETALLE'].length;
    for (int d = 0; d < co; d++) {
      var re = Detalle.fromJson(js['DETALLE'][d]);
      list_detalle.add(re);
    }
    //list_detalle.add(result_detalle);

    loading = false;
    return notifyListeners();
  }
}
