import 'dart:convert';

List<ClassListCart> classListCartFromJson(String str) => List<ClassListCart>.from(json.decode(str).map((x) => ClassListCart.fromJson(x)));

String classListCartToJson(List<ClassListCart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClassListCart {
    ClassListCart({
        required this.dataFact,
        required this.productos,
    });

    DataFact dataFact;
    List<Producto> productos;

    factory ClassListCart.fromJson(Map<String, dynamic> json) => ClassListCart(
        dataFact: DataFact.fromJson(json["data_fact"]),
        productos: List<Producto>.from(json["productos"].map((x) => Producto.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data_fact": dataFact.toJson(),
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
    };
}

class DataFact {
    DataFact({
        required this.idTmpItem,
        required this.cantidad,
        required this.precio,
        required this.tipoPrecio,
    });

    String idTmpItem;
    String cantidad;
    String precio;
    String tipoPrecio;

    factory DataFact.fromJson(Map<String, dynamic> json) => DataFact(
        idTmpItem: json["ID_TMP_ITEM"],
        cantidad: json["CANTIDAD"],
        precio: json["PRECIO"],
        tipoPrecio: json["TIPO_PRECIO"],
    );

    Map<String, dynamic> toJson() => {
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

    factory Producto.fromJson(Map<String, dynamic> json) => Producto(
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

    Map<String, dynamic> toJson() => {
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
