import 'dart:convert';

class SucursalesData {
  SucursalesData({
    required this.idSucursal,
    required this.nombre,
  });

  String idSucursal;
  String nombre;

  factory SucursalesData.fromJson(Map<String, dynamic> json) => SucursalesData(
        idSucursal: json["ID_SUCURSAL"],
        nombre: json["NOMBRE"],
      );

  Map<String, dynamic> toJson() => {
        "ID_SUCURSAL": idSucursal,
        "NOMBRE": nombre,
      };
}
