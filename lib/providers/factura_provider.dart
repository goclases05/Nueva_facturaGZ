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

  //observación
  String ob = '';

  //serie
  String initialSerie = '0';
  bool cargainiSerie = true;

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
  String abonosi2 = '0';

  //condicion pago
  bool loadCondicionesTMP = false; //inicia cargando
  Map<String, dynamic> condiciones_registradas =
      {}; //condiciones registradas en la tabla temporal

  bool load_condicionespagos = false; //inicia cargando
  List<CondicionPago> list_condicionPago = []; //condiciones de pago

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
    final id_usuario = Preferencias.data_id;
    if (accion == 'read') {
      cargainiSerie = true;
      initialSerie = '0';
      notifyListeners();
      print(
          "https://app.gozeri.com/versiones/v1.5.5/factura/serie_tmp.php?tmp=${tmp}&accion=read&usuario=${id_usuario}");
      final Uri uri = Uri.parse(
          "https://app.gozeri.com/versiones/v1.5.5/factura/serie_tmp.php?tmp=${tmp}&accion=read&usuario=${id_usuario}");

      final resp = await http.get(uri);
      if (resp.body == '0') {
        initialSerie = (Preferencias.serie.isEmpty) ? '0' : Preferencias.serie;
        cargainiSerie = false;
        notifyListeners();
        return this.serie(tmp, 'add', initialSerie);
      } else {
        initialSerie = resp.body;
        cargainiSerie = false;
        return notifyListeners();
      }
    } else if (accion == 'add') {
      print(
          "https://app.gozeri.com/versiones/v1.5.5/factura/serie_tmp.php?tmp=${tmp}&accion=add&serie=${serie}&usuario=${id_usuario}");
      final Uri uri = Uri.parse(
          "https://app.gozeri.com/versiones/v1.5.5/factura/serie_tmp.php?tmp=${tmp}&accion=add&serie=${serie}&usuario=${id_usuario}");

      final resp = await http.get(uri);
      if (resp.body == '1') {
        initialSerie = serie;
        //notifyListeners();
      }
      //notifyListeners();
      return resp.body;
    }
  }

  Future addOB(String observacion, String id) async {
    final id_usuario = Preferencias.data_id;
    print(
        "https://app.gozeri.com/versiones/v1.5.5/factura/save_ob.php?ob=${observacion}&id=${id}&usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/versiones/v1.5.5/factura/save_ob.php?ob=${observacion}&id=${id}&usuario=${id_usuario}");

    final resp = await http.get(uri);
    var js = json.decode(resp.body);

    ob = observacion;

    return notifyListeners();
  }

  Future readOB(String id) async {
    final id_usuario = Preferencias.data_id;
    print(
        "https://app.gozeri.com/versiones/v1.5.5/factura/read_ob.php?id=${id}&usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/versiones/v1.5.5/factura/read_ob.php?id=${id}&usuario=${id_usuario}");

    final resp = await http.get(uri);
    ob = resp.body;

    return notifyListeners();
  }

  Future metodoPago() async {
    final sucursal = Preferencias.sucursal;
    final id_usuario = Preferencias.data_id;
    loadMetodo = true;
    notifyListeners();
    print(
        "https://app.gozeri.com/versiones/v1.5.5/metodoPago.php?usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/versiones/v1.5.5/metodoPago.php?usuario=${id_usuario}");

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

  Future transacciones(String tmp, String accion) async {
    loadTransaccion = true;
    final id_usuario = Preferencias.data_id;
    saldo = '0';

    print(
        "https://app.gozeri.com/versiones/v1.5.5/factura/transacciones.php?id=${tmp}&usuario=${id_usuario}&estado=${accion}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/versiones/v1.5.5/factura/transacciones.php?id=${tmp}&usuario=${id_usuario}&estado=${accion}");

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
    this.abonosi2 = '0';
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
    abonosi2 = abonosi2.toString();
    loadTransaccion = false;
    return notifyListeners();
  }

  Future accionesMetodoPAgo(String accion, String tmp, String abono,
      String metodo, String cuenta, String referencia, String estado) async {
    final usuario = Preferencias.data_id;
    final empresa = Preferencias.data_empresa;
    if (accion == 'add') {
      print(
          "https://app.gozeri.com/versiones/v1.5.5/factura/fac_metodoPago.php?accion=${accion}&tmp=${tmp}&abono=${abono}&id_usuario=${usuario}&metodo=${metodo}&cuenta=${cuenta}&referencia=${referencia}&empresa=${empresa}&usuario=${usuario}&estado=${estado}");
      final Uri uri = Uri.parse(
          "https://app.gozeri.com/versiones/v1.5.5/factura/fac_metodoPago.php?accion=${accion}&tmp=${tmp}&abono=${abono}&id_usuario=${usuario}&metodo=${metodo}&cuenta=${cuenta}&referencia=${referencia}&empresa=${empresa}&usuario=${usuario}&estado=${estado}");

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
        "https://app.gozeri.com/versiones/v1.5.5/factura/certificar_core.php?id=${tmp}&usuario=${id_usuario}&empresa=${empresa}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/versiones/v1.5.5/factura/certificar_core.php?id=${tmp}&usuario=${id_usuario}&empresa=${empresa}");

    final resp = await http.get(uri);
    print('el dato');
    print(resp.body);
    return resp.body;
  }

  Future anular_factura(String id_f) async {
    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;
    print(
        "https://app.gozeri.com/versiones/v1.5.5/factura/anulacion_factura.php?id=${id_f}&usuario=${id_usuario}&empresa=${empresa}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/versiones/v1.5.5/factura/anulacion_factura.php?id=${id_f}&usuario=${id_usuario}&empresa=${empresa}");

    final resp = await http.get(uri);
    print('el dato');
    print(resp.body);
    return resp.body;
  }

  Future bancos() async {
    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;
    loadBancos = true;
    notifyListeners();
    print(
        "https://app.gozeri.com/versiones/v1.5.5/factura/bancos.php?empresa=${empresa}&usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/versiones/v1.5.5/factura/bancos.php?empresa=${empresa}&usuario=${id_usuario}");

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
        "https://${_baseUrl}/versiones/v1.5.5/factura/new_tmp_factura.php?empresa=${empresa}&id_usuario=${id_usuario}&sucu=${Preferencias.sucursal}&usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://${_baseUrl}/versiones/v1.5.5/factura/new_tmp_factura.php?empresa=${empresa}&id_usuario=${id_usuario}&sucu=${Preferencias.sucursal}&usuario=${id_usuario}");

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
        "https://${_baseUrl}/versiones/v1.5.5/factura/read_det_factura.php?id_tmp=${id}&id_empresa=${empresa}&usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://${_baseUrl}/versiones/v1.5.5/factura/read_det_factura.php?id_tmp=${id}&id_empresa=${empresa}&usuario=${id_usuario}");

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

  Future<dynamic> delete_producto(String id_tmp, String id_item) async {
    final id_usuario = Preferencias.data_id;
    print(
        "https://app.gozeri.com/versiones/v1.5.5/factura/edit_articulo_detalle_car.php?id_tmp=${id_tmp}&id_item=${id_item}&usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/versiones/v1.5.5/factura/edit_articulo_detalle_car.php?id_tmp=${id_tmp}&id_item=${id_item}&usuario=${id_usuario}");

    final resp = await http.get(uri);
    if (resp.body == 'OK') {
      await list_cart(id_tmp);
      return;
    }
    return resp.body;
  }

  //elimina transacion
  Future<dynamic> delete_transaccion(String id_tmp, String trans) async {
    final id_usuario = Preferencias.data_id;
    print(
        "https://app.gozeri.com/versiones/v1.5.5/factura/fac_metodoPago.php?id_tmp=${id_tmp}&id_trans=${trans}&accion=delete&usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/versiones/v1.5.5/factura/fac_metodoPago.php?id_tmp=${id_tmp}&id_trans=${trans}&accion=delete&usuario=${id_usuario}");

    final resp = await http.get(uri);
    return resp.body;
  }

  Future<dynamic> read_cliente(
      String accion, String id_cliente, String tmp) async {
    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;

    notifyListeners();

    if (accion == 'read') {
      //busca si se encuentra un cliente registrado a la factura
      print(
          "https://app.gozeri.com/versiones/v1.5.5/factura/fac_cliente.php?tmp=${tmp}&accion=read&usuario=${id_usuario}");
      final Uri uri = Uri.parse(
          "https://app.gozeri.com/versiones/v1.5.5/factura/fac_cliente.php?tmp=${tmp}&accion=read&usuario=${id_usuario}");

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
          "https://app.gozeri.com/versiones/v1.5.5/factura/fac_cliente.php?tmp=${tmp}&accion=remove&cliente=${id_cliente}&usuario=${id_usuario}");
      final Uri uri = Uri.parse(
          "https://app.gozeri.com/versiones/v1.5.5/factura/fac_cliente.php?tmp=${tmp}&accion=remove&cliente=${id_cliente}&usuario=${id_usuario}");

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

  Future<dynamic> create_cliente(
      String nombre, String apellidos, String nit, String tmp) async {
    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;

    print(
        "https://app.gozeri.com/versiones/v1.5.5/factura/create_cliente.php?tmp=${tmp}&nombre=${nombre}&apellidos=${apellidos}&nit=${nit}&idempresa=${empresa}&idusuario=${id_usuario}&usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/versiones/v1.5.5/factura/create_cliente.php?tmp=${tmp}&nombre=${nombre}&apellidos=${apellidos}&nit=${nit}&idempresa=${empresa}&idusuario=${id_usuario}&usuario=${id_usuario}");

    final resp = await http.get(uri);
    Map<String, dynamic> rhh = await json.decode(resp.body);

    if (rhh["MENSAJE"] == 'OK') {
      return await read_cliente('read', rhh['ID'], tmp);
    }
    return notifyListeners();
  }

  Future<String> delete_tmp(String tmp) async {
    final id_usuario = Preferencias.data_id;
    print(
        "https://app.gozeri.com/versiones/v1.5.5/factura/eliminar_factura.php?id=${tmp}&usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/versiones/v1.5.5/factura/eliminar_factura.php?id=${tmp}&usuario=${id_usuario}");

    final resp = await http.get(uri);
    print('se elimino: ' + resp.body);
    return resp.body;
  }

  Future condicionesPagos(String id) async {
    final id_usuario = Preferencias.data_id;

    load_condicionespagos = true;
    notifyListeners();

    print(
        "https://app.gozeri.com/versiones/v1.5.5/condiciones_pagos.php?usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/versiones/v1.5.5/condiciones_pagos.php?usuario=${id_usuario}");

    final resp = await http.get(uri);
    var js = json.decode(resp.body);
    final len = js.length;

    list_condicionPago.clear();

    var result;
    for (int o = 0; o < len; o++) {
      result = CondicionPago.fromJson(js[o]);
      list_condicionPago.add(result);
    }

    await queryCondicionesPagoTM('0', '', '', id);
    load_condicionespagos = false;
    return notifyListeners();
  }

  Future queryCondicionesPagoTM(
      String accion, String clave, String valor, String tmp) async {
    final id_usuario = Preferencias.data_id;
    final empresa = Preferencias.data_empresa;
    if (accion != '1') {
      loadCondicionesTMP = true;
      notifyListeners();
      //va mostrar los registros de termino y fechas previamente guardados
      condiciones_registradas.clear();
      print(
          "https://app.gozeri.com/versiones/v1.5.5/factura/showsave_condicionespago.php?accion=${accion}&clave=${clave}&valor=${valor}&tmp=${tmp}&idempresa=${empresa}&idusuario=${id_usuario}&usuario=${id_usuario}");
      final Uri uri = Uri.parse(
          "https://app.gozeri.com/versiones/v1.5.5/factura/showsave_condicionespago.php?accion=${accion}&clave=${clave}&valor=${valor}&tmp=${tmp}&idempresa=${empresa}&idusuario=${id_usuario}&usuario=${id_usuario}");

      final resp = await http.get(uri);
      Map<String, dynamic> js = await json.decode(resp.body);

      condiciones_registradas.addAll(js);

      loadCondicionesTMP = false;
      return notifyListeners();
    } else {
      //registrara los datos
      print(
          "https://app.gozeri.com/versiones/v1.5.5/factura/showsave_condicionespago.php?accion=${accion}&clave=${clave}&valor=${valor}&tmp=${tmp}&idempresa=${empresa}&idusuario=${id_usuario}&usuario=${id_usuario}");
      final Uri uri = Uri.parse(
          "https://app.gozeri.com/versiones/v1.5.5/factura/showsave_condicionespago.php?accion=${accion}&clave=${clave}&valor=${valor}&tmp=${tmp}&idempresa=${empresa}&idusuario=${id_usuario}&usuario=${id_usuario}");

      final resp = await http.get(uri);
      Map<String, dynamic> js = await json.decode(resp.body);
      if (js['MENSAJE'] == 'OK') {
        condiciones_registradas[clave] = valor;
        return notifyListeners();
      } else {
        return 'Error: no se aplico los cambios';
      }
    }
  }

  Future<dynamic> get_Sat(String tmp, String nit) async {
    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;
    cambio_c = '0';
    print(
        "https://app.gozeri.com/versiones/v1.5.5/factura/search_cliente_sat.php?SAT=${nit}&empresa=${empresa}&idusuario=${id_usuario}&usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/versiones/v1.5.5/factura/search_cliente_sat.php?SAT=${nit}&empresa=${empresa}&idusuario=${id_usuario}&usuario=${id_usuario}");

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
