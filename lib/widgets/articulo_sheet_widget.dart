import 'package:factura_gozeri/models/producto_x_departamento_models.dart';
import 'package:factura_gozeri/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ArticuloSheet extends StatefulWidget {
  ArticuloSheet(
      {Key? key,
      required this.listProd,
      required this.colorPrimary,
      required this.id_tmp,
      required this.edit_precio})
      : super(key: key);
  final Producto listProd;
  final Color colorPrimary;
  final String id_tmp;
  final String edit_precio;

  @override
  State<ArticuloSheet> createState() => _ArticuloSheetState();
}

class _ArticuloSheetState extends State<ArticuloSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        Chip(
          label: Text(widget.listProd.codigo),
          avatar: Icon(
            Icons.memory,
            color: widget.colorPrimary,
          ),
        ),
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
                        const SizedBox(
                          height: 5,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        RatingBar.builder(
                          itemSize: 20,
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Chip(
                                backgroundColor: (widget.listProd.modo_venta ==
                                            '2' ||
                                        widget.listProd.stock
                                            .contains(RegExp('-'), 0) ||
                                        widget.listProd.stock
                                            .contains(RegExp('.'), 0))
                                    ? const Color.fromARGB(243, 200, 230, 201)
                                    : (int.parse(widget.listProd.stock) <= 0)
                                        ? const Color.fromARGB(
                                            243, 240, 144, 132)
                                        : const Color.fromARGB(
                                            243, 200, 230, 201),
                                label: Text(
                                  'Stock: ${widget.listProd.stock}',
                                  style: const TextStyle(color: Colors.white),
                                ))
                          ],
                        ),
                      ])))
        ]),
        Container(
          height: 3,
          margin: const EdgeInsets.symmetric(vertical: 3),
          color: Color.fromARGB(255, 219, 225, 235),
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Descripción:',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                //(widget.listProd.descBreve)
                Text(
                  widget.listProd.descBreve,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                (widget.listProd.modo_venta == '2')
                    ? ModoVenta2(
                        colorPrimary: widget.colorPrimary,
                        listProd: widget.listProd,
                        id_tmp: widget.id_tmp,
                        edit_precio: widget.edit_precio)
                    : SingleChildScrollView(
                        child: ModoVenta1(
                            id_tmp: widget.id_tmp,
                            listProd: widget.listProd,
                            colorPrimary: widget.colorPrimary,
                            edit_precio: widget.edit_precio),
                      )
              ],
            ))
      ]),
    );
  }
}
