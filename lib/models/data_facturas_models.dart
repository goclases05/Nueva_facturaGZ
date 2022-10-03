import 'dart:convert';

List<DataFacturas> dataFacturasFromJson(String str) => List<DataFacturas>.from(
    json.decode(str).map((x) => DataFacturas.fromJson(x)));

String dataFacturasToJson(List<DataFacturas> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataFacturas {
  DataFacturas({
    required this.idFactTmp,
    required this.idCliente,
    required this.nombre,
    required this.apellidos,
    required this.nit,
    required this.no,
    required this.fecha,
    required this.estado
  });

  String idFactTmp;
  String idCliente;
  String nombre;
  String apellidos;
  String nit;
  String no;
  String fecha;
  String estado;

  factory DataFacturas.fromJson(Map<String, dynamic> json) => DataFacturas(
        idFactTmp: json["ID_FACT_TMP"],
        idCliente: json["ID_CLIENTE"],
        nombre: json["NOMBRE"],
        apellidos: json["APELLIDOS"],
        nit: json["NIT"],
        no: json["NO"],
        fecha: json["FECHA"],
        estado: json["ESTADO"],
      );

  Map<String, dynamic> toJson() => {
        "ID_FACT_TMP": idFactTmp,
        "ID_CLIENTE": idCliente,
        "NOMBRE": nombre,
        "APELLIDOS": apellidos,
        "NIT": nit,
        "NO": no,
        "FECHA": fecha,
        "ESTADO": estado,
      };
}
