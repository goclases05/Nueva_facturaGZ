import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/models/departamentos_models.dart';

class DepartamentoService extends ChangeNotifier {
  final _baseUrl = 'app.gozeri.com';

  List<Departamento> depa = [];
  bool isLoading = true;

  /*DepartamentoService() {
    //this.LoadDepa();
  }*/

  Future LoadDepa() async {
    this.isLoading = true;
    notifyListeners();

    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;
    print(
        "https://${_baseUrl}/versiones/v1.5.3/departamentos.php?empresa=${empresa}&usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://${_baseUrl}/versiones/v1.5.3/departamentos.php?empresa=${empresa}&usuario=${id_usuario}");

    final resp = await http.get(uri);

    final departamentos = departamentosFromJson(resp.body);
    this.depa.clear();
    this.depa.addAll(departamentos.departamentos);
    //final depas = departamentos.departamentos;

    /*for (var i = 0; i < depas.length; i++) {
      print(depas[i].departamento);
    } */
    this.isLoading = false;
    notifyListeners();
    return this.depa;
  }
}
