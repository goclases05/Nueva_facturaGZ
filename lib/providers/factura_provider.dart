import 'dart:convert';
import 'dart:ffi';

import 'package:factura_gozeri/global/globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Facturacion extends ChangeNotifier {
  final String _baseUrl = "app.gozeri.com";
  bool tmp_creada = false;

  Future<String> new_tmpFactura() async {
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
      print('${id}');
      return id;
    } else {
      return add['error'];
    }
  }
}
