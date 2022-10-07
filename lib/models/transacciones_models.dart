import 'dart:convert';

List<Transacciones> transaccionesFromJson(String str) =>
    List<Transacciones>.from(
        json.decode(str).map((x) => Transacciones.fromJson(x)));

String transaccionesToJson(List<Transacciones> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Transacciones {
  Transacciones({
    required this.idTrans,
    required this.noTransaccion,
    required this.docu,
    required this.abono,
    required this.forma,
    required this.cuenta,
    required this.noCuenta,
    required this.banco,
  });

  String idTrans;
  String noTransaccion;
  String docu;
  String abono;
  String forma;
  String cuenta;
  String noCuenta;
  String banco;

  factory Transacciones.fromJson(Map<String, dynamic> json) => Transacciones(
        idTrans: json["ID_TRANS"],
        noTransaccion: json["NO_TRANSACCION"],
        docu: json["DOCU"],
        abono: json["ABONO"],
        forma: json["FORMA"],
        cuenta: json["CUENTA"] == null ? '' : json["CUENTA"],
        noCuenta: json["NO_CUENTA"] == null ? '' : json["NO_CUENTA"],
        banco: json["BANCO"] == null ? '' : json["BANCO"],
      );

  Map<String, dynamic> toJson() => {
        "ID_TRANS": idTrans,
        "NO_TRANSACCION": noTransaccion,
        "DOCU": docu,
        "ABONO": abono,
        "FORMA": forma,
        "CUENTA": cuenta == null ? '' : cuenta,
        "NO_CUENTA": noCuenta == null ? '' : noCuenta,
        "BANCO": banco == null ? '' : banco,
      };
}
