import 'dart:convert';

class SeriesData {
  SeriesData({
    required this.idSerie,
    required this.nombre,
  });

  String idSerie;
  String nombre;

  factory SeriesData.fromJson(Map<String, dynamic> json) => SeriesData(
        idSerie: json["ID_SERIE"],
        nombre: json["NOMBRE"],
      );

  Map<String, dynamic> toJson() => {
        "ID_SERIE": idSerie,
        "NOMBRE": nombre,
      };
}

class MetodosPago {
  MetodosPago({
    required this.idMetodo,
    required this.nombre,
  });

  String idMetodo;
  String nombre;

  factory MetodosPago.fromJson(Map<String, dynamic> json) => MetodosPago(
        idMetodo: json["ID_PAGO_PRED"],
        nombre: json["FORMA"],
      );

  Map<String, dynamic> toJson() => {
        "ID_PAGO_PRED": idMetodo,
        "FORMA": nombre,
      };
}

class CondicionPago {
  CondicionPago({
    required this.idMetodo,
    required this.nombre,
  });

  String idMetodo;
  String nombre;

  factory CondicionPago.fromJson(Map<String, dynamic> json) => CondicionPago(
        idMetodo: json["ID_PAGO_PRED"],
        nombre: json["FORMA"],
      );

  Map<String, dynamic> toJson() => {
        "ID_PAGO_PRED": idMetodo,
        "FORMA": nombre,
      };
}
