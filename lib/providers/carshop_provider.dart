import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/models/producto_x_departamento_models.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class Cart with ChangeNotifier {
  List<Producto> _list_producto = [];
  int cantidad = 0;
  double _price = 0.0;

  final String _baseUrl = "app.gozeri.com";

  void add(int cantidad_p, String item, String id_tmp) async {
    print(item);
    print(cantidad_p);
    final htt = await HttpCart(item, cantidad_p, id_tmp);
    if (htt == 'OK') {
      cantidad = cantidad + cantidad_p;
      notifyListeners();
    }
  }

  Future<String> HttpCart(id_prod, cantidad_p, id_tmp) async {
    /* final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;
    print(
        "https://${_baseUrl}/flutter_gozeri/factura/add_cart.php?id_tmp=${id_tmp}&id_prod=${id_prod}&cantidad=${cantidad_p}&empresa=${empresa}&id_usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://${_baseUrl}/flutter_gozeri/factura/add_cart.php?id_tmp=${id_tmp}&id_prod=${id_prod}&cantidad=${cantidad_p}&empresa=${empresa}&id_usuario=${id_usuario}");

    final resp = await http.get(uri);

    final Map<String, dynamic> add = json.decode(resp.body);

    if (add.containsKey('messaje')) {
      return add['messaje'];
    } else {
      return add['error'];
    }*/
    return 'OK';
  }

  int get count {
    //return _list_producto.length;
    return cantidad;
  }
}
