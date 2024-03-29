import 'dart:convert';

ViewFacturaPrint viewFacturaPrintFromJson(String str) =>
    ViewFacturaPrint.fromJson(json.decode(str));

String viewFacturaPrintToJson(ViewFacturaPrint data) =>
    json.encode(data.toJson());

class ViewFacturaPrint {
  ViewFacturaPrint(
      {required this.encabezado, required this.detalle, required this.trans});

  Encabezado encabezado;
  List<Detalle> detalle;
  List<Trans> trans;

  factory ViewFacturaPrint.fromJson(Map<String, dynamic> json) =>
      ViewFacturaPrint(
        encabezado: Encabezado.fromJson(json["ENCABEZADO"]),
        detalle:
            List<Detalle>.from(json["DETALLE"].map((x) => Detalle.fromJson(x))),
        trans: List<Trans>.from(json["TRANS"].map((x) => Trans.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ENCABEZADO": encabezado.toJson(),
        "DETALLE": List<dynamic>.from(detalle.map((x) => x.toJson())),
        "TRANS": List<dynamic>.from(trans.map((x) => x.toJson())),
      };
}

class Encabezado {
  Encabezado(
      {required this.fel,
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
      required this.qr,
      required this.fecha_letras,
      required this.nombre_comercial_emp,
      required this.nombre_comercial_sucu,
      required this.nit_emisor});

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
  dynamic facturarA;
  dynamic organizacion;
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
  dynamic telefonoUsu;
  dynamic nit;
  String fecha;
  String fechaV;
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
  String fechaCert;
  String serieDte;
  String noDte;
  String totalLetas;
  String qr;
  String fecha_letras, nombre_comercial_emp, nombre_comercial_sucu, nit_emisor;

  factory Encabezado.fromJson(Map<String, dynamic> json) => Encabezado(
      fel: json["FEL"] == null ? '' : json["FEL"],
      felSucu: json["FEL_SUCU"] == null ? '' : json["FEL_SUCU"],
      teleSucu: json["TELE_SUCU"] == null ? '' : json["TELE_SUCU"],
      idSucursal: json["ID_SUCURSAL"] == null ? '' : json["ID_SUCURSAL"],
      direccionSucu:
          json["DIRECCION_SUCU"] == null ? '' : json["DIRECCION_SUCU"],
      nombreEmpresaSucu: json["NOMBRE_EMPRESA_SUCU"] == null
          ? ''
          : json["NOMBRE_EMPRESA_SUCU"],
      nombreEmpresa:
          json["NOMBRE_EMPRESA"] == null ? '' : json["NOMBRE_EMPRESA"],
      rutaSucu: json["RUTA_SUCU"] == null ? '' : json["RUTA_SUCU"],
      foto: json["FOTO"] == null ? '' : json["FOTO"],
      estado: json["ESTADO"] == null ? '' : json["ESTADO"],
      dte: json["DTE"] == null ? '' : json["DTE"],
      facturarA: json["FACTURAR_A"] == null ? '' : json["FACTURAR_A"],
      organizacion: json["ORGANIZACION"] == null ? '' : json["ORGANIZACION"],
      nombreF: json["NOMBRE_F"] == null ? '' : json["NOMBRE_F"],
      apellidosF: json["APELLIDOS_F"] == null ? '' : json["APELLIDOS_F"],
      descuento: json["DESCUENTO"] == null ? '' : json["DESCUENTO"],
      idSerie: json["ID_SERIE"] == null ? '' : json["ID_SERIE"],
      idFact: json["ID_FACT"] == null ? '' : json["ID_FACT"],
      tipo: json["TIPO"] == null ? '' : json["TIPO"],
      ticket: json["TICKET"] == null ? '' : json["TICKET"],
      serie: json["SERIE"] == null ? '' : json["SERIE"],
      no: json["NO"] == null ? '' : json["NO"],
      telefono: json["TELEFONO"] == null ? '' : json["TELEFONO"],
      logoUrl: json["LOGO_URL"] == null ? '' : json["LOGO_URL"],
      logoNom: json["LOGO_NOM"] == null ? '' : json["LOGO_NOM"],
      direccion: json["DIRECCION"] == null ? '' : json["DIRECCION"],
      idCliente: json["ID_CLIENTE"] == null ? '' : json["ID_CLIENTE"],
      nombre: json["NOMBRE"] == null ? '' : json["NOMBRE"],
      apellidos: json["APELLIDOS"] == null ? '' : json["APELLIDOS"],
      direccionCli: json["DIRECCION_CLI"] == null ? '' : json["DIRECCION_CLI"],
      telefonoUsu: json["TELEFONO_USU"] == null ? '' : json["TELEFONO_USU"],
      nit: json["NIT"] == null ? '' : json["NIT"],
      fecha: json["FECHA"] == null ? '' : json["FECHA"],
      fechaV: json["FECHA_V"] == null ? '' : json["FECHA_V"],
      idVendedor: json["ID_VENDEDOR"] == null ? '' : json["ID_VENDEDOR"],
      nombreV: json["NOMBRE_V"] == null ? '' : json["NOMBRE_V"],
      apellidosV: json["APELLIDOS_V"] == null ? '' : json["APELLIDOS_V"],
      total: json["TOTAL"] == null ? '' : json["TOTAL"],
      forma: json["FORMA"] == null ? '' : json["FORMA"],
      obser: json["OBSER"] == null ? '' : json["OBSER"],
      observaciones: json["OBSERVACIONES"] == null ? '' : json["OBSERVACIONES"],
      ruta: json["RUTA"] == null ? '' : json["RUTA"],
      plantilla: json["PLANTILLA"] == null ? '' : json["PLANTILLA"],
      contenido: json["CONTENIDO"] == null ? '' : json["CONTENIDO"],
      frases: json["FRASES"] == null
          ? []
          : List<String>.from(json["FRASES"].map((x) => x)),
      certificador: json["CERTIFICADOR"] == null ? '' : json["CERTIFICADOR"],
      nitCert: json["NIT_CERT"] == null ? '' : json["NIT_CERT"],
      fechaCert: json["FECHA_CERT"] == null ? '' : json["FECHA_CERT"],
      serieDte: json["SERIE_DTE"] == null ? '' : json["SERIE_DTE"],
      noDte: json["NO_DTE"] == null ? '' : json["NO_DTE"],
      totalLetas: json["TOTAL_LETAS"] == null ? '' : json["TOTAL_LETAS"],
      qr: json["QR"] == null ? '' : json["QR"],
      fecha_letras: json["FECHA_LETRAS"] == null ? '' : json["FECHA_LETRAS"],
      nombre_comercial_emp: json["NOMBRE_COMERCIAL_EMP"] == null
          ? ''
          : json["NOMBRE_COMERCIAL_EMP"],
      nombre_comercial_sucu: json["NOMBRE_COMERCIAL_SUCU"] == null
          ? ''
          : json["NOMBRE_COMERCIAL_SUCU"],
      nit_emisor: json["NIT_EMISOR"] == null ? '' : json["NIT_EMISOR"]);

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
        "FECHA": fecha,
        "FECHA_V": fechaV,
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
        "FECHA_CERT": fechaCert,
        "SERIE_DTE": serieDte,
        "NO_DTE": noDte,
        "TOTAL_LETAS": totalLetas,
        "QR": qr,
        "FECHA_LETRAS": fecha_letras,
        "NOMBRE_COMERCIAL_EMP": nombre_comercial_emp,
        "NOMBRE_COMERCIAL_SUCU": nombre_comercial_sucu,
        "NIT_EMISOR": nit_emisor,
      };
}

class Detalle {
  Detalle({
    required this.contenido,
    required this.idProd,
    required this.codigo,
    required this.descripcion,
    required this.costo,
    required this.idFact,
    required this.producto,
    required this.cantidad,
    required this.precio,
  });

  dynamic contenido;
  String idProd;
  String codigo;
  String descripcion;
  String costo;
  String idFact;
  String producto;
  String cantidad;
  String precio;

  factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
        contenido: json["CONTENIDO"],
        idProd: json["ID_PROD"],
        codigo: json["CODIGO"],
        descripcion: json["DESCRIPCION"],
        costo: json["COSTO"],
        idFact: json["ID_FACT"],
        producto: json["PRODUCTO"],
        cantidad: json["CANTIDAD"],
        precio: json["PRECIO"],
      );

  Map<String, dynamic> toJson() => {
        "CONTENIDO": contenido,
        "ID_PROD": idProd,
        "CODIGO": codigo,
        "DESCRIPCION": descripcion,
        "COSTO": costo,
        "ID_FACT": idFact,
        "PRODUCTO": producto,
        "CANTIDAD": cantidad,
        "PRECIO": precio,
      };
}

class Trans {
  Trans({
    required this.idtrans,
    required this.abono,
    required this.fecha,
    required this.forma,
  });

  String idtrans;
  String abono;
  String fecha;
  String forma;

  factory Trans.fromJson(Map<String, dynamic> json) => Trans(
        idtrans: json["ID_TRANS"],
        abono: json["ABONO"],
        fecha: json["FECHA"],
        forma: json["FORMA"],
      );

  Map<String, dynamic> toJson() => {
        "ID_TRANS": idtrans,
        "ABONO": abono,
        "FECHA": fecha,
        "FORMA": forma,
      };
}
