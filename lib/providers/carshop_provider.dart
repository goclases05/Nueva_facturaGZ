import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/models/producto_x_departamento_models.dart';
import 'package:factura_gozeri/print/print_page.dart';
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

  void add(int cantidad_p, String item, String id_tmp, String cantidad_producto,
      String precio) async {
    print(item);
    print(cantidad_p);
    final htt = await HttpCart(item, cantidad_producto, id_tmp, precio);
    print('holi ${htt}');
    if (htt == 'OK') {
      cantidad = cantidad + cantidad_p;
      notifyListeners();
    }
  }

  Future<String> HttpCart(id_prod, cantidad_p, id_tmp, precio) async {
    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;
    print(
        "https://${_baseUrl}/desarrollo_flutter/factura/add_cart_factura.php?id_prod=${id_prod}&id_fact=${id_tmp}&idusuario=${id_usuario}&cantida=${cantidad_p}&precio=${precio}");
    final Uri uri = Uri.parse(
        "https://${_baseUrl}/desarrollo_flutter/factura/add_cart_factura.php?id_prod=${id_prod}&id_fact=${id_tmp}&idusuario=${id_usuario}&cantida=${cantidad_p}&precio=${precio}");

    final resp = await http.get(uri);

    //final String /*Map<String, dynamic>*/ add = json.decode(resp.body);
    /*if (add.containsKey('messaje')) {
      return add['messaje'];
    } else {
      return add['error'];
    }
    return 'OK';*/
    return resp.body;
  }

  int get count {
    //return _list_producto.length;
    return cantidad;
  }
}
