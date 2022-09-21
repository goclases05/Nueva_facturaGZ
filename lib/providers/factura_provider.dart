import 'dart:convert';

import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/models/car_list_models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Facturacion extends ChangeNotifier {
  final String _baseUrl = "app.gozeri.com";
  bool tmp_creada = false;
  bool list_load = false;

  Future<dynamic> new_tmpFactura() async {
    tmp_creada = false;
    notifyListeners();

    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;

    print(
        "https://${_baseUrl}/flutter_gozeri/factura/new_tmp_factura.php?empresa=${empresa}&id_usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://${_baseUrl}/flutter_gozeri/factura/new_tmp_factura.php?empresa=${empresa}&id_usuario=${id_usuario}");

    final resp = await http.get(uri);

    final Map<String, dynamic> add = json.decode(resp.body);

    if (add.containsKey('id_tmp')) {
      tmp_creada = true;
      notifyListeners();

      final id = add['id_tmp'];
      final array = [id, add['clave']];
      print(array);
      return array;
    } else {
      return add['error'];
    }
  }

  Future<dynamic> list_cart(String id) async {
    list_load = false;
    notifyListeners();

    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;

    print(
        "https://${_baseUrl}/flutter_gozeri/factura/read_det_factura.php?id_tmp=${id}&id_empresa=${empresa}");
    final Uri uri = Uri.parse(
        "https://${_baseUrl}/flutter_gozeri/factura/read_det_factura.php?id_tmp=${id}&id_empresa=${empresa}");

    final resp = await http.get(uri);

    final result = DataProductos.fromMap(json.decode(resp.body));

    return result.productos[0].codigo;
  }
}
