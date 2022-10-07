// To parse this JSON data, do
//
//     final viewFacturaPrint = viewFacturaPrintFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ViewFacturaPrint viewFacturaPrintFromJson(String str) =>
    ViewFacturaPrint.fromJson(json.decode(str));

String viewFacturaPrintToJson(ViewFacturaPrint data) =>
    json.encode(data.toJson());

class ViewFacturaPrint {
  ViewFacturaPrint({
    required this.encabezado,
    required this.detalle,
  });

  Encabezado encabezado;
  List<dynamic> detalle;

  factory ViewFacturaPrint.fromJson(Map<String, dynamic> json) =>
      ViewFacturaPrint(
        encabezado: Encabezado.fromJson(json["ENCABEZADO"]),
        detalle: List<dynamic>.from(json["DETALLE"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "ENCABEZADO": encabezado.toJson(),
        "DETALLE": List<dynamic>.from(detalle.map((x) => x)),
      };
}

class Encabezado {
  Encabezado({
    required this.fel,
    required this.felSucu,
    required this.teleSucu,
    required this.idSucursal,
    required this.direccionSucu,
    required this.nombreEmpresaSucu,
    required this.nombreEmpresa,
    required this.rutaSucu,
    required this.foto,
    required this.estado,
    required this.dte,
    required this.facturarA,
    required this.organizacion,
    required this.nombreF,
    required this.apellidosF,
    required this.descuento,
    required this.idSerie,
    required this.idFact,
    required this.tipo,
    required this.ticket,
    required this.serie,
    required this.no,
    required this.telefono,
    required this.logoUrl,
    required this.logoNom,
    required this.direccion,
    required this.idCliente,
    required this.nombre,
    required this.apellidos,
    required this.direccionCli,
    required this.telefonoUsu,
    required this.nit,
    required this.fecha,
    required this.fechaV,
    required this.idVendedor,
    required this.nombreV,
    required this.apellidosV,
    required this.total,
    required this.forma,
    required this.obser,
    required this.observaciones,
    required this.ruta,
    required this.plantilla,
    required this.contenido,
    required this.frases,
    required this.certificador,
    required this.nitCert,
    required this.fechaCert,
    required this.serieDte,
    required this.noDte,
    required this.totalLetas,
  });

  String fel;
  String felSucu;
  String teleSucu;
  String idSucursal;
  String direccionSucu;
  String nombreEmpresaSucu;
  String nombreEmpresa;
  String rutaSucu;
  String foto;
  String estado;
  String dte;
  String facturarA;
  String organizacion;
  String nombreF;
  String apellidosF;
  String descuento;
  String idSerie;
  String idFact;
  String tipo;
  String ticket;
  String serie;
  String no;
  String telefono;
  String logoUrl;
  String logoNom;
  String direccion;
  String idCliente;
  String nombre;
  String apellidos;
  String direccionCli;
  String telefonoUsu;
  String nit;
  DateTime fecha;
  DateTime fechaV;
  String idVendedor;
  String nombreV;
  String apellidosV;
  String total;
  String forma;
  String obser;
  String observaciones;
  String ruta;
  String plantilla;
  String contenido;
  List<String> frases;
  String certificador;
  String nitCert;
  DateTime fechaCert;
  String serieDte;
  String noDte;
  String totalLetas;

  factory Encabezado.fromJson(Map<String, dynamic> json) => Encabezado(
        fel: json["FEL"],
        felSucu: json["FEL_SUCU"],
        teleSucu: json["TELE_SUCU"],
        idSucursal: json["ID_SUCURSAL"],
        direccionSucu: json["DIRECCION_SUCU"],
        nombreEmpresaSucu: json["NOMBRE_EMPRESA_SUCU"],
        nombreEmpresa: json["NOMBRE_EMPRESA"],
        rutaSucu: json["RUTA_SUCU"],
        foto: json["FOTO"],
        estado: json["ESTADO"],
        dte: json["DTE"],
        facturarA: json["FACTURAR_A"],
        organizacion: json["ORGANIZACION"],
        nombreF: json["NOMBRE_F"],
        apellidosF: json["APELLIDOS_F"],
        descuento: json["DESCUENTO"],
        idSerie: json["ID_SERIE"],
        idFact: json["ID_FACT"],
        tipo: json["TIPO"],
        ticket: json["TICKET"],
        serie: json["SERIE"],
        no: json["NO"],
        telefono: json["TELEFONO"],
        logoUrl: json["LOGO_URL"],
        logoNom: json["LOGO_NOM"],
        direccion: json["DIRECCION"],
        idCliente: json["ID_CLIENTE"],
        nombre: json["NOMBRE"],
        apellidos: json["APELLIDOS"],
        direccionCli: json["DIRECCION_CLI"],
        telefonoUsu: json["TELEFONO_USU"],
        nit: json["NIT"],
        fecha: DateTime.parse(json["FECHA"]),
        fechaV: DateTime.parse(json["FECHA_V"]),
        idVendedor: json["ID_VENDEDOR"],
        nombreV: json["NOMBRE_V"],
        apellidosV: json["APELLIDOS_V"],
        total: json["TOTAL"],
        forma: json["FORMA"],
        obser: json["OBSER"],
        observaciones: json["OBSERVACIONES"],
        ruta: json["RUTA"],
        plantilla: json["PLANTILLA"],
        contenido: json["CONTENIDO"],
        frases: List<String>.from(json["FRASES"].map((x) => x)),
        certificador: json["CERTIFICADOR"],
        nitCert: json["NIT_CERT"],
        fechaCert: DateTime.parse(json["FECHA_CERT"]),
        serieDte: json["SERIE_DTE"],
        noDte: json["NO_DTE"],
        totalLetas: json["TOTAL_LETAS"],
      );

  Map<String, dynamic> toJson() => {
        "FEL": fel,
        "FEL_SUCU": felSucu,
        "TELE_SUCU": teleSucu,
        "ID_SUCURSAL": idSucursal,
        "DIRECCION_SUCU": direccionSucu,
        "NOMBRE_EMPRESA_SUCU": nombreEmpresaSucu,
        "NOMBRE_EMPRESA": nombreEmpresa,
        "RUTA_SUCU": rutaSucu,
        "FOTO": foto,
        "ESTADO": estado,
        "DTE": dte,
        "FACTURAR_A": facturarA,
        "ORGANIZACION": organizacion,
        "NOMBRE_F": nombreF,
        "APELLIDOS_F": apellidosF,
        "DESCUENTO": descuento,
        "ID_SERIE": idSerie,
        "ID_FACT": idFact,
        "TIPO": tipo,
        "TICKET": ticket,
        "SERIE": serie,
        "NO": no,
        "TELEFONO": telefono,
        "LOGO_URL": logoUrl,
        "LOGO_NOM": logoNom,
        "DIRECCION": direccion,
        "ID_CLIENTE": idCliente,
        "NOMBRE": nombre,
        "APELLIDOS": apellidos,
        "DIRECCION_CLI": direccionCli,
        "TELEFONO_USU": telefonoUsu,
        "NIT": nit,
        "FECHA": fecha.toIso8601String(),
        "FECHA_V": fechaV.toIso8601String(),
        "ID_VENDEDOR": idVendedor,
        "NOMBRE_V": nombreV,
        "APELLIDOS_V": apellidosV,
        "TOTAL": total,
        "FORMA": forma,
        "OBSER": obser,
        "OBSERVACIONES": observaciones,
        "RUTA": ruta,
        "PLANTILLA": plantilla,
        "CONTENIDO": contenido,
        "FRASES": List<dynamic>.from(frases.map((x) => x)),
        "CERTIFICADOR": certificador,
        "NIT_CERT": nitCert,
        "FECHA_CERT": fechaCert.toIso8601String(),
        "SERIE_DTE": serieDte,
        "NO_DTE": noDte,
        "TOTAL_LETAS": totalLetas,
      };
}
