import 'dart:convert';

import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/models/sucursales_models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class settingsProvider extends ChangeNotifier {
  final String _baseUrl = "app.gozeri.com";
  bool load_sucursal = true;

  List<Color> list_Color = [
    Colors.cyan,
    Colors.black,
    Colors.amber,
    Colors.amberAccent,
    Colors.teal,
    Colors.redAccent,
    Colors.red,
    Colors.purpleAccent,
    Colors.purple,
    Colors.pinkAccent,
    Colors.pink,
    Colors.orangeAccent,
    Colors.orange,
    Colors.indigo,
    Colors.blue,
    Colors.blueGrey,
    Colors.blueAccent,
    Colors.brown,
    Colors.deepOrange,
    Colors.lightGreenAccent,
    Colors.deepPurple,
    Colors.green,
    Colors.grey
  ];
  Color colorPrimary = Colors.cyan;

  settingsProvider() {
    print(list_Color[int.parse(Preferencias.pcolor)]);
    colorPrimary = list_Color[int.parse(Preferencias.pcolor)];
    notifyListeners();
  }

  Future colorChange(int position) async {
    colorPrimary = list_Color[position];
    Preferencias.pcolor = '${position}';
    return notifyListeners();
  }
}
