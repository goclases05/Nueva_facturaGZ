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
