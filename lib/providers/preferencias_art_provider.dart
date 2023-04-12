import 'dart:convert';

import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Preferencias_art extends ChangeNotifier {
  final String _baseUrl = "app.gozeri.com";

  Preferencias_art() {}

  Future preferencias_producto() async {
    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;
    print(
        "https://${_baseUrl}/versiones/v1.5.2/preferencias_productos.php?id_empresa=${empresa}");
    final Uri uri = Uri.parse(
        "https://${_baseUrl}/versiones/v1.5.2/preferencias_productos.php?id_empresa=${empresa}");

    final resp = await http.get(uri);
    print('el dato');
    print(resp.body);
    final data = json.decode(resp.body);

    return data;
  }
}
