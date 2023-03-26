import 'dart:convert';

import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ImpresorasProvider extends ChangeNotifier {
  List<PrinterBluetooth> devices = [];


  Future impresoras_disponibles(List<PrinterBluetooth> devList) async {
    devices = devList;
    notifyListeners();
  }


}
