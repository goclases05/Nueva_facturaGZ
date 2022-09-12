import 'package:factura_gozeri/models/producto_x_departamento_models.dart';
import 'package:factura_gozeri/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ArticuloSheet extends StatefulWidget {
  ArticuloSheet({Key? key, required this.listProd}) : super(key: key);
  final Producto listProd;

  @override
  State<ArticuloSheet> createState() => _ArticuloSheetState();
}

class _ArticuloSheetState extends State<ArticuloSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        Chip(label: Text(widget.listProd.codigo)),
        Row(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Hero(
                tag: 'List_${widget.listProd.idProd}',
                child: /*Image.network(
                      widget.listProd.url + widget.listProd.foto,
                      width: MediaQuery.of(context).size.width * 0.3))*/
                    FadeInImage(
                        placeholder:
                            const AssetImage('assets/productos_gz.jpg'),
                        image: NetworkImage(
                            widget.listProd.url + widget.listProd.foto),
                        width: MediaQuery.of(context).size.width * 0.3),
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.listProd.producto,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 1,
                          letterSpacing: 0,
                          wordSpacing: 0,
                          fontSize: 15),
                    ),
                    Text(
                      widget.listProd.descBreve,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 15, color: Colors.black45),
                    ),

                  ]
                )
              )
            )
        ]),
        (widget.listProd.modo_venta=='2')?
        ModoVenta2()
        :
        Text('')
      ]),
    );
  }
}
