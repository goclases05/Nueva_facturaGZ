import 'dart:async';
import 'dart:convert';

import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/helpers/debouncer.dart';
import 'package:factura_gozeri/models/producto_x_departamento_models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ItemProvider extends ChangeNotifier {
  final String _baseUrl = "app.gozeri.com";

  final debauncer= Debouncer(duration: Duration(milliseconds: 500));
  final StreamController<List<Producto>> _suggestionsStremcontroller= new StreamController.broadcast();
  Stream<List<Producto>> get suggestionsStrem => this._suggestionsStremcontroller.stream;

  Future<List<Producto>> searchItem(String query) async {

    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;

    print(
        "https://${_baseUrl}/flutter_gozeri/search_items.php?id_empresa=${empresa}&data=${query}");
    final Uri uri = Uri.parse(
        "https://${_baseUrl}/flutter_gozeri/search_items.php?id_empresa=${empresa}&data=${query}");

    final resp = await http.get(uri);
    final search = ProductosDepartamento.fromJson(resp.body);

    return search.productos;
  }

  void getSuggestionsByQuery(String searchTearm){
    debauncer.value='';
    debauncer.onValue=(value)async{
       final result=await this.searchItem(value);
       this._suggestionsStremcontroller.add(result);
    };

    final timer=Timer.periodic(Duration(milliseconds: 300), (_) {
      debauncer.value=searchTearm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
