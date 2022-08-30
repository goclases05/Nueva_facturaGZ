// To parse this JSON data, do
//
//     final productosDepartamento = productosDepartamentoFromMap(jsonString);

import 'dart:convert';

class ProductosDepartamento {
    ProductosDepartamento({
      required  this.total,
      required  this.productos,
    });

    String total;
    List<Producto> productos;

    factory ProductosDepartamento.fromJson(String str) => ProductosDepartamento.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProductosDepartamento.fromMap(Map<String, dynamic> json) => ProductosDepartamento(
        total: json["total"],
        productos: List<Producto>.from(json["productos"].map((x) => Producto.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "total": total,
        "productos": List<dynamic>.from(productos.map((x) => x.toMap())),
    };
}

class Producto {
    Producto({
      required  this.idProd,
      required  this.producto,
      required  this.codigo,
      required  this.descBreve,
      required  this.descComp,
      required  this.precio,
      required  this.stock,
      required  this.foto,
      required  this.url,
    });

    String idProd;
    String producto;
    String codigo;
    String descBreve;
    String descComp;
    String precio;
    String stock;
    String foto;
    String url;

    factory Producto.fromJson(String str) => Producto.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Producto.fromMap(Map<String, dynamic> json) => Producto(
        idProd: json["ID_PROD"],
        producto: json["PRODUCTO"],
        codigo: json["CODIGO"],
        descBreve: json["DESC_BREVE"],
        descComp: json["DESC_COMP"],
        precio: json["PRECIO"],
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
        "PRECIO": precio,
        "STOCK": stock,
        "FOTO": foto,
        "URL": url,
    };
}
