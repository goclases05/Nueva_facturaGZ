import 'dart:convert';

import 'package:factura_gozeri/global/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = "app.gozeri.com";

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

      return null;
    } else {
      return decodeResp['error'];
    }
  }

  Future logout() async {
    //await storage.delete(key: 'USUARIO');
    await storage.deleteAll();
  }

  Future<String> readUsuario() async {
    return await storage.read(key: 'USUARIO') ?? '';
  }
}
