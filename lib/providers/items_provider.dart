import 'dart:async';
import 'dart:convert';

import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/helpers/debouncer.dart';
import 'package:factura_gozeri/models/data_facturas_models.dart';
import 'package:factura_gozeri/models/producto_x_departamento_models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ItemProvider extends ChangeNotifier {
  final String _baseUrl = "app.gozeri.com";

  final debauncer = Debouncer(duration: Duration(milliseconds: 500));

  final StreamController<List<Producto>> _suggestionsStremcontroller =
      new StreamController.broadcast();
  Stream<List<Producto>> get suggestionsStrem =>
      this._suggestionsStremcontroller.stream;

  final StreamController<List<DataFacturas>>
      _suggestionsStremcontrollerfacturas = new StreamController.broadcast();
  Stream<List<DataFacturas>> get suggestionsStremfacturas =>
      this._suggestionsStremcontrollerfacturas.stream;

  Future<List<Producto>> searchItem(String query) async {
    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;

    print(
        "https://${_baseUrl}/versiones/v1.5.5/search_items.php?id_empresa=${empresa}&data=${query}&usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://${_baseUrl}/versiones/v1.5.5/search_items.php?id_empresa=${empresa}&data=${query}&usuario=${id_usuario}");

    final resp = await http.get(uri);
    final search = ProductosDepartamento.fromJson(resp.body);

    return search.productos;
  }

  void getSuggestionsByQuery(String searchTearm) {
    debauncer.value = '';
    debauncer.onValue = (value) async {
      final result = await this.searchItem(value);
      this._suggestionsStremcontroller.add(result);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debauncer.value = searchTearm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }

  Future<List<DataFacturas>> searchFacturas(String query) async {
    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;
    List<DataFacturas> list_emi = [];

    list_emi.clear();

    print(
        "https://app.gozeri.com/versiones/v1.5.5/factura/filtro_facturas.php?empresa=${empresa}&idusuario=${id_usuario}&sucu=${Preferencias.sucursal}&usuario=${id_usuario}&filtro=${query}");

    final Uri uri = Uri.parse(
        "https://app.gozeri.com/versiones/v1.5.5/factura/filtro_facturas.php?empresa=${empresa}&idusuario=${id_usuario}&sucu=${Preferencias.sucursal}&usuario=${id_usuario}&filtro=${query}");

    final resp = await http.get(uri);
    final o = json.decode(resp.body);
    print('la e: ');
    print(o.length);
    if (o.length == 0) {
    } else {
      for (int e = 0; e < o.length; e++) {
        var lfac = DataFacturas.fromJson(json.decode(resp.body)[e]);
        list_emi.add(lfac);
      }
    }
    return list_emi;
  }

  void getSuggestionsByQueryfactura(String searchTearm) {
    debauncer.value = '';
    debauncer.onValue = (value) async {
      final result = await this.searchFacturas(value);
      this._suggestionsStremcontrollerfacturas.add(result);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debauncer.value = searchTearm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
