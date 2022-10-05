import 'dart:convert';

import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:factura_gozeri/models/series_models.dart';
import 'package:factura_gozeri/models/sucursales_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = "app.gozeri.com";

  List<SucursalesData> list_sucu = [];
  List<SeriesData> list_serie = [];

  final storage = new FlutterSecureStorage();

  Future<String?> login(String user, String pass) async {
    final Map<String, dynamic> authData = {'usuario': user, 'pass': pass};

    final url = Uri.https(_baseUrl, '/flutter_gozeri/login.php');
    final resp = await http.post(url, body: authData);

    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decodeResp.containsKey('message')) {
      //usuario existente
      //return decodeResp['message']['ID_USUARIO'];
      await storage.write(
          key: 'USUARIO', value: decodeResp['message']['ID_USUARIO']);
      await storage.write(
          key: 'ID_EMPRESA', value: decodeResp['message']['ID_EMPRESA']);
      await storage.write(
          key: 'TIPO_USUARIO', value: decodeResp['message']['TIPO_USUARIO']);
      await storage.write(key: 'CLAVE', value: decodeResp['message']['CLAVE']);

      Preferencias.name = decodeResp['message']['NOMBRE'];
      Preferencias.apellido = decodeResp['message']['APELLIDOS'];
      Preferencias.data_usuario = decodeResp['message']['USUARIO'];
      Preferencias.grupo = decodeResp['message']['GRUPO'];
      Preferencias.foto_usuario = decodeResp['message']['FOTO_USUARIO'];
      Preferencias.nombre_empresa = decodeResp['message']['NOMBRE_EMPRESA'];
      Preferencias.foto_empresa = decodeResp['message']['FOTO_EMPRESA'];
      Preferencias.data_id = decodeResp['message']['ID_USUARIO'];
      Preferencias.data_empresa = decodeResp['message']['ID_EMPRESA'];
      Preferencias.moneda = decodeResp['message']['MONEDA'];
      Preferencias.tipo = decodeResp['message']['TIPO_USUARIO'];
      Preferencias.sucursal = decodeResp['message']['ID_SUCURSAL'];

      return null;
    } else {
      return decodeResp['error'];
    }
  }

  Future logout() async {
    Preferencias.sucursal = '0';
    Preferencias.serie = '';
    //await storage.delete(key: 'USUARIO');
    await storage.deleteAll();
  }

  Future<String> readUsuario() async {
    await Sucursales();
    await Series();
    return await storage.read(key: 'USUARIO') ?? '';
  }

  Future Sucursales() async {
    final empresa = Preferencias.data_empresa;

    print(
        "https://app.gozeri.com/flutter_gozeri/sucursales.php?empresa=${empresa}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/flutter_gozeri/sucursales.php?empresa=${empresa}");

    final resp = await http.get(uri);
    var js = json.decode(resp.body);
    final len = js.length;
    //final sucursales_http = sucursalesDataFromJson(resp.body);
    list_sucu.clear();
    var result;
    for (int o = 0; o < len; o++) {
      print('hola sucursal ${o} y ${len}');
      result = SucursalesData.fromJson(js[o]);
      /*list_det.addAll(result);*/
      print(list_sucu);
      list_sucu.add(result);
    }
    return notifyListeners();
  }

  Future Series() async {
    final sucursal = Preferencias.sucursal;

    print(
        "https://app.gozeri.com/flutter_gozeri/series.php?sucursal=${sucursal}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/flutter_gozeri/series.php?sucursal=${sucursal}");

    final resp = await http.get(uri);
    var js = json.decode(resp.body);
    final len = js.length;
    //final sucursales_http = sucursalesDataFromJson(resp.body);
    list_serie.clear();
    var result;
    for (int o = 0; o < len; o++) {
      result = SeriesData.fromJson(js[o]);
      /*list_det.addAll(result);*/
      print(list_serie);
      list_serie.add(result);
    }
    return notifyListeners();
  }
}
