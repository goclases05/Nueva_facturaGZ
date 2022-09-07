// To parse this JSON data, do
//
//     final productosDepartamento = productosDepartamentoFromMap(jsonString);

import 'dart:convert';

class ProductosDepartamento {
  ProductosDepartamento({
    required this.total,
    required this.productos,
  });

  String total;
  List<Producto> productos;

  factory ProductosDepartamento.fromJson(String str) =>
      ProductosDepartamento.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductosDepartamento.fromMap(Map<String, dynamic> json) =>
      ProductosDepartamento(
        total: json["total"],
        productos: List<Producto>.from(
            json["productos"].map((x) => Producto.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "total": total,
        "productos": List<dynamic>.from(productos.map((x) => x.toMap())),
      };
}

class Producto {
  Producto({
    required this.idProd,
    required this.producto,
    required this.codigo,
    required this.descBreve,
    required this.descComp,
    required this.precio,
    required this.modo_venta,
    required this.stock,
    required this.foto,
    required this.url,
    required this.precio_2,
    required this.precio_3,
    required this.precio_4,
  });

  String idProd;
  String producto;
  String codigo;
  String descBreve;
  String descComp;
  String precio;
  String modo_venta;
  String stock;
  String foto;
  String url;
  String precio_2;
  String precio_3;
  String precio_4;

  factory Producto.fromJson(String str) => Producto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Producto.fromMap(Map<String, dynamic> json) => Producto(
        idProd: json["ID_PROD"],
        producto: json["PRODUCTO"],
        codigo: json["CODIGO"],
        descBreve: json["DESC_BREVE"],
        descComp: json["DESC_COMP"],
        precio: json["PRECIO"],
        modo_venta: json["MODO_VENTA"],
        stock: json["STOCK"],
        foto: json["FOTO"],
        url: json["URL"],
        precio_2: json["PRECIO_2"],
        precio_3: json["PRECIO_3"],
        precio_4: json["PRECIO_4"],
      );

  Map<String, dynamic> toMap() => {
        "ID_PROD": idProd,
        "PRODUCTO": producto,
        "CODIGO": codigo,
        "DESC_BREVE": descBreve,
        "DESC_COMP": descComp,
        "PRECIO": precio,
        "MODO_VENTA": modo_venta,
        "STOCK": stock,
        "FOTO": foto,
        "URL": url,
        "PRECIO_2": precio_2,
        "PRECIO_3": precio_3,
        "PRECIO_4": precio_4
      };
}
