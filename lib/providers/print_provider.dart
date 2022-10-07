import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrintProvider extends ChangeNotifier {
  PrintProvider() {}

  Future dataFac() async {
    print("https://app.gozeri.com/flutter_gozeri/metodoPago.php");
    final Uri uri =
        Uri.parse("https://app.gozeri.com/flutter_gozeri/metodoPago.php");

    final resp = await http.get(uri);
    var js = json.decode(resp.body);

    return notifyListeners();
  }
}
