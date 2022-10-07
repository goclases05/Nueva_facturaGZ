import 'dart:convert';

List<BancosData> bancosDataFromJson(String str) => List<BancosData>.from(json.decode(str).map((x) => BancosData.fromJson(x)));

String bancosDataToJson(List<BancosData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BancosData {
    BancosData({
        required this.idBank,
        required this.idMoneda,
        required this.cuenta,
        required this.noCuenta,
        required this.banco,
        required this.fecha,
        required this.voucher,
        required this.estado,
    });

    String idBank;
    String idMoneda;
    String cuenta;
    String noCuenta;
    String banco;
    DateTime fecha;
    String voucher;
    String estado;

    factory BancosData.fromJson(Map<String, dynamic> json) => BancosData(
        idBank: json["ID_BANK"],
        idMoneda: json["ID_MONEDA"],
        cuenta: json["CUENTA"],
        noCuenta: json["NO_CUENTA"],
        banco: json["BANCO"],
        fecha: DateTime.parse(json["FECHA"]),
        voucher: json["VOUCHER"],
        estado: json["ESTADO"],
    );

    Map<String, dynamic> toJson() => {
        "ID_BANK": idBank,
        "ID_MONEDA": idMoneda,
        "CUENTA": cuenta,
        "NO_CUENTA": noCuenta,
        "BANCO": banco,
        "FECHA": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "VOUCHER": voucher,
        "ESTADO": estado,
    };
}
