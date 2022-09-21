// To parse this JSON data, do
//
//     final dataProductos = dataProductosFromMap(jsonString);
import 'dart:convert';

List<DataProductos> dataProductosFromMap(String str) =>
    List<DataProductos>.from(
        json.decode(str).map((x) => DataProductos.fromMap(x)));

String dataProductosToMap(List<DataProductos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class DataProductos {
  DataProductos({
    required this.dataFact,
    required this.productos,
  });

  dynamic dataFact;
  List<Producto> productos;

  factory DataProductos.fromMap(Map<String, dynamic> json) => DataProductos(
        dataFact: json["data_fact"],
        productos: List<Producto>.from(
            json["productos"].map((x) => Producto.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data_fact": dataFact,
        "productos": List<dynamic>.from(productos.map((x) => x.toMap())),
      };
}

class DataFactElement {
  DataFactElement({
    required this.idTmpItem,
    required this.cantidad,
    required this.precio,
    required this.tipoPrecio,
  });

  String idTmpItem;
  String cantidad;
  String precio;
  String tipoPrecio;

  factory DataFactElement.fromMap(Map<String, dynamic> json) => DataFactElement(
        idTmpItem: json["ID_TMP_ITEM"],
        cantidad: json["CANTIDAD"],
        precio: json["PRECIO"],
        tipoPrecio: json["TIPO_PRECIO"],
      );

  Map<String, dynamic> toMap() => {
        "ID_TMP_ITEM": idTmpItem,
        "CANTIDAD": cantidad,
        "PRECIO": precio,
        "TIPO_PRECIO": tipoPrecio,
      };
}

class Producto {
  Producto({
    required this.idProd,
    required this.producto,
    required this.codigo,
    required this.descBreve,
    required this.descComp,
    required this.modoVenta,
    required this.facturar,
    required this.precio,
    required this.precio2,
    required this.precio3,
    required this.precio4,
    required this.stock,
    required this.foto,
    required this.url,
  });

  String idProd;
  String producto;
  String codigo;
  String descBreve;
  String descComp;
  String modoVenta;
  String facturar;
  String precio;
  String precio2;
  String precio3;
  String precio4;
  String stock;
  String foto;
  String url;

  factory Producto.fromMap(Map<String, dynamic> json) => Producto(
        idProd: json["ID_PROD"],
        producto: json["PRODUCTO"],
        codigo: json["CODIGO"],
        descBreve: json["DESC_BREVE"],
        descComp: json["DESC_COMP"],
        modoVenta: json["MODO_VENTA"],
        facturar: json["FACTURAR"],
        precio: json["PRECIO"],
        precio2: json["PRECIO_2"],
        precio3: json["PRECIO_3"],
        precio4: json["PRECIO_4"],
        stock: json["STOCK"],
        foto: json["FOTO"],
        url: json["URL"],
      );

  Map<String, dynamic> toMap() => {
        "ID_PROD": idProd,
        "PRODUCTO": producto,
        "CODIGO": codigo,
        "DESC_BREVE": descBreve,
        "DESC_COMP": descComp,
        "MODO_VENTA": modoVenta,
        "FACTURAR": facturar,
        "PRECIO": precio,
        "PRECIO_2": precio2,
        "PRECIO_3": precio3,
        "PRECIO_4": precio4,
        "STOCK": stock,
        "FOTO": foto,
        "URL": url,
      };
}
