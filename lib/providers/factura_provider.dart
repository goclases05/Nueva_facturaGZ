import 'dart:convert';
import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/models/bancos_models.dart';
import 'package:factura_gozeri/models/car_list_models.dart';
import 'package:factura_gozeri/models/series_models.dart';
import 'package:factura_gozeri/models/transacciones_models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Facturacion extends ChangeNotifier {
  final String _baseUrl = "app.gozeri.com";
  bool tmp_creada = false;

  //serie
  String initialSerie = '0';

  //lista de la carta
  bool contenido = false;
  bool list_load = true;
  late List<ClassListCart> list_det = [];

  bool loadMetodo = true;
  List<MetodosPago> list_metodoPago = [];

  //bancos
  bool loadBancos = true;
  List<BancosData> list_Bancos = [];

  //bool carga transaccion
  bool loadTransaccion = true;
  List<Transacciones> list_transaccion = [];
  String total_fac = '0';
  String saldo = '0';

  //variables para cliente
  String cliente = '';
  String nit_cliente = '';
  String id_cliente = '';
  String id = '';
  String cambio_c = '0';

  Facturacion() {
    metodoPago();
  }

  Future serie(String tmp, String accion, String serie) async {
    if (accion == 'read') {
      initialSerie = '0';
      notifyListeners();
      print(
          "https://app.gozeri.com/flutter_gozeri/factura/serie_tmp.php?tmp=${tmp}&accion=read");
      final Uri uri = Uri.parse(
          "https://app.gozeri.com/flutter_gozeri/factura/serie_tmp.php?tmp=${tmp}&accion=read");

      final resp = await http.get(uri);
      if (resp.body == '0') {
        initialSerie = (Preferencias.serie == '') ? '0' : Preferencias.serie;
        notifyListeners();
        return this.serie(tmp, 'add', initialSerie);
      } else {
        initialSerie = resp.body;
        return notifyListeners();
      }
    } else if (accion == 'add') {
      print(
          "https://app.gozeri.com/flutter_gozeri/factura/serie_tmp.php?tmp=${tmp}&accion=add&serie=${serie}");
      final Uri uri = Uri.parse(
          "https://app.gozeri.com/flutter_gozeri/factura/serie_tmp.php?tmp=${tmp}&accion=add&serie=${serie}");

      final resp = await http.get(uri);
      if (resp.body == '1') {
        initialSerie = serie;
        notifyListeners();
      }
      notifyListeners();
      return resp.body;
    }
  }

  Future metodoPago() async {
    final sucursal = Preferencias.sucursal;
    loadMetodo = true;
    notifyListeners();
    print("https://app.gozeri.com/flutter_gozeri/metodoPago.php");
    final Uri uri =
        Uri.parse("https://app.gozeri.com/flutter_gozeri/metodoPago.php");

    final resp = await http.get(uri);
    var js = json.decode(resp.body);
    final len = js.length;
    //final sucursales_http = sucursalesDataFromJson(resp.body);
    list_metodoPago.clear();
    var result;
    for (int o = 0; o < len; o++) {
      result = MetodosPago.fromJson(js[o]);
      /*list_det.addAll(result);*/
      print(list_metodoPago);
      list_metodoPago.add(result);
    }
    loadMetodo = false;
    return notifyListeners();
  }

  Future transacciones(String tmp) async {
    loadTransaccion = true;
    saldo = '0';

    notifyListeners();
    print(
        "https://app.gozeri.com/flutter_gozeri/factura/transacciones.php?id=${tmp}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/flutter_gozeri/factura/transacciones.php?id=${tmp}");

    final resp = await http.get(uri);
    var js = json.decode(resp.body);
    //list_transaccion.addAll(js['TRANSACCIONES']);
    final len = js['TRANSACCIONES'].length;
    print("trans ${len}");

    //final sucursales_http = sucursalesDataFromJson(resp.body);
    list_transaccion.clear();
    notifyListeners();
    var result;
    double abonosi = 0;
    for (int o = 0; o < len; o++) {
      result = Transacciones.fromJson(js['TRANSACCIONES'][o]);
      /*list_det.addAll(result);*/
      abonosi = abonosi + double.parse(js['TRANSACCIONES'][o]['ABONO']);
      print(list_transaccion);
      list_transaccion.add(result);
    }
    double y = double.parse(js['TOTAL']);
    total_fac = y.toString();
    saldo = (double.parse(js['TOTAL']) - abonosi).toString();
    loadTransaccion = false;
    return notifyListeners();
  }

  Future accionesMetodoPAgo(
    String accion,
    String tmp,
    String abono,
    String metodo,
    String cuenta,
    String referencia,
  ) async {
    final usuario = Preferencias.data_id;
    final empresa = Preferencias.data_empresa;
    if (accion == 'add') {
      print(
          "https://app.gozeri.com/flutter_gozeri/factura/fac_metodoPago.php?accion=${accion}&tmp=${tmp}&abono=${abono}&id_usuario=${usuario}&metodo=${metodo}&cuenta=${cuenta}&referencia=${referencia}&empresa=${empresa}");
      final Uri uri = Uri.parse(
          "https://app.gozeri.com/flutter_gozeri/factura/fac_metodoPago.php?accion=${accion}&tmp=${tmp}&abono=${abono}&id_usuario=${usuario}&metodo=${metodo}&cuenta=${cuenta}&referencia=${referencia}&empresa=${empresa}");

      final resp = await http.get(uri);
      return resp.body;
    } else {
      return notifyListeners();
    }
  }

  Future facturar(String tmp) async {
    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;
    print(
        "https://app.gozeri.com/flutter_gozeri/factura/certificar_core.php?id=${tmp}&usuario=${id_usuario}&empresa=${empresa}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/flutter_gozeri/factura/certificar_core.php?id=${tmp}&usuario=${id_usuario}&empresa=${empresa}");

    final resp = await http.get(uri);
    return resp.body;
  }

  Future bancos() async {
    final empresa = Preferencias.data_empresa;
    loadBancos = true;
    notifyListeners();
    print(
        "https://app.gozeri.com/flutter_gozeri/factura/bancos.php?empresa=${empresa}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/flutter_gozeri/factura/bancos.php?empresa=${empresa}");

    final resp = await http.get(uri);

    var js = json.decode(resp.body);
    final len = js.length;
    //final sucursales_http = sucursalesDataFromJson(resp.body);
    list_Bancos.clear();
    var result;
    for (int o = 0; o < len; o++) {
      result = BancosData.fromJson(js[o]);

      /*list_det.addAll(result);*/
      print(result);
      list_Bancos.add(result);
    }
    loadBancos = false;
    return notifyListeners();
  }

  Future<dynamic> new_tmpFactura() async {
    tmp_creada = false;
    notifyListeners();

    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;

    print(
        "https://${_baseUrl}/flutter_gozeri/factura/new_tmp_factura.php?empresa=${empresa}&id_usuario=${id_usuario}&sucu=${Preferencias.sucursal}");
    final Uri uri = Uri.parse(
        "https://${_baseUrl}/flutter_gozeri/factura/new_tmp_factura.php?empresa=${empresa}&id_usuario=${id_usuario}&sucu=${Preferencias.sucursal}");

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
    list_load = true;
    notifyListeners();

    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;

    print(
        "https://${_baseUrl}/flutter_gozeri/factura/read_det_factura.php?id_tmp=${id}&id_empresa=${empresa}");
    final Uri uri = Uri.parse(
        "https://${_baseUrl}/flutter_gozeri/factura/read_det_factura.php?id_tmp=${id}&id_empresa=${empresa}");

    final resp = await http.get(uri);

    //final result =ClassListCart.fromJson(json.decode(resp.body));
    list_det.clear();
    var result;
    if (resp.body == '0') {
      list_load = false;
      contenido = false;
      notifyListeners();
      return result;
    } else {
      //final result =ClassListCart.fromJson(json.decode(resp.body));
      int count = json.decode(resp.body).length;
      for (int i = 0; i < count; i++) {
        result = ClassListCart.fromJson(json.decode(resp.body)[i]);
        /*list_det.addAll(result);*/
        list_det.add(result);
        print(result);
      }
      contenido = true;
      list_load = false;
      notifyListeners();
      print(result);
      return result;
    }
  }

  Future<dynamic> read_cliente(
      String accion, String id_cliente, String tmp) async {
    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;

    notifyListeners();

    if (accion == 'read') {
      //busca si se encuentra un cliente registrado a la factura
      print(
          "https://app.gozeri.com/flutter_gozeri/factura/fac_cliente.php?tmp=${tmp}&accion=read");
      final Uri uri = Uri.parse(
          "https://app.gozeri.com/flutter_gozeri/factura/fac_cliente.php?tmp=${tmp}&accion=read");

      final resp = await http.get(uri);
      final res_json = await json.decode(resp.body);
      print('hola ' + res_json['id'].toString());
      cliente = res_json['label'].toString();
      id = res_json['id'].toString();
      nit_cliente = res_json['nit'].toString();
      print('adios ${id_cliente}');
      notifyListeners();
      return notifyListeners();
    } else if (accion == 'remove') {
      print(
          "https://app.gozeri.com/flutter_gozeri/factura/fac_cliente.php?tmp=${tmp}&accion=remove&cliente=${id_cliente}");
      final Uri uri = Uri.parse(
          "https://app.gozeri.com/flutter_gozeri/factura/fac_cliente.php?tmp=${tmp}&accion=remove&cliente=${id_cliente}");

      final resp = await http.get(uri);

      if (resp.body == 'OK') {
        print(resp.body);
        return await read_cliente('read', '0', tmp);
      } else {
        return notifyListeners();
      }
    }

    return true;
  }

  Future<dynamic> get_Sat(String tmp, String nit) async {
    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;
    cambio_c = '0';
    print(
        "https://app.gozeri.com/flutter_gozeri/factura/search_cliente_sat.php?SAT=${nit}&empresa=${empresa}&idusuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/flutter_gozeri/factura/search_cliente_sat.php?SAT=${nit}&empresa=${empresa}&idusuario=${id_usuario}");

    final resp = await http.get(uri);
    final jso = json.decode(resp.body);
    print(jso['error']);
    if (jso['error'] == '0') {
      return await read_cliente('remove', jso['cliente'], tmp);
    } else {
      cambio_c = jso['error'];
      return notifyListeners();
    }
  }
}
