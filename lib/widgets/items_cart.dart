import 'dart:convert';

import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/models/producto_x_departamento_models.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/screens/screens.dart';
import 'package:factura_gozeri/widgets/articulo_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ItemsCart extends StatefulWidget {
  // ignore: non_constant_identifier_names
  ItemsCart({Key? key, required this.id_tmp, required this.colorPrimary})
      : super(key: key);
  String id_tmp;
  Color colorPrimary;

  @override
  State<ItemsCart> createState() => _ItemsCart();
}

class _ItemsCart extends State<ItemsCart> {
  void customBottomSheet(BuildContext context, List<dynamic> listProd) {
    String j = jsonEncode(listProd[0]);

    Producto p = Producto.fromJson(j);
    print('esta es : ');
    print(p.codigo);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.7,
                minChildSize: 0.2,
                maxChildSize: 1,
                builder: (_, controller) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.remove,
                          color: Colors.grey[600],
                          size: 30,
                        ),
                        Expanded(
                            child: /*ListView.builder(
                            controller: controller,
                            itemCount: 1,
                            itemBuilder: (_, index) {
                              return ArticuloSheet(
                                  listProd: widget
                                      .listProd); /*Card(
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text("Element at index($index)"),
                                ),
                              );*/
                            },
                          ),*/
                                SingleChildScrollView(
                                    controller: controller,
                                    child: Column(
                                      children: [
                                        ArticuloSheet(
                                          listProd: p,
                                          colorPrimary: widget.colorPrimary,
                                          id_tmp: widget.id_tmp,
                                          edit_precio: '0',
                                        ),
                                      ],
                                    ))),
                      ],
                    ),
                  );
                  //return ArticuloSheet(listProd: widget.listProd);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  final f = NumberFormat("\$###,###.00", "en_US");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ListDet = Provider.of<Facturacion>(context);
    /*Future.delayed(Duration.zero, () {
        List_det.list_cart(widget.id_tmp);
    });*/

    if (ListDet.list_load)
      // ignore: curly_braces_in_flow_control_structures
      return Container(
          padding: const EdgeInsets.all(0),
          child: Center(
            child: LinearProgressIndicator(
              color: widget.colorPrimary,
              backgroundColor: Colors.white,
            ),
          ));
    if (ListDet.contenido == false) {
      // ignore: curly_braces_in_flow_control_structures
      /*return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 15),
        child: ElevatedButton.icon(
            label: const Icon(
              Icons.add,
              size: 20,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewTabsScreen(
                      colorPrimary: widget.colorPrimary,
                      id_tmp: widget.id_tmp,
                      clave: '2321'),
                ),
              );
            },
            style: TextButton.styleFrom(
                primary: Colors.white, backgroundColor: Colors.green),
            icon: const Text("Agregar Articulos")),
      );*/
    }

    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: ListDet.list_det.length,
        itemBuilder: ((context, index) {
          print(ListDet.list_det[0]);
          String producto = ListDet.list_det[index].productos[0].producto;
          String precio2 = ListDet.list_det[index].dataFact.precio;
          String cantidadS = ListDet.list_det[index].dataFact.cantidad;
          String item_id = ListDet.list_det[index].dataFact.idTmpItem;

          String foto = ListDet.list_det[index].productos[0].url +
              ListDet.list_det[index].productos[0].foto;

          return Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 207, 216, 220),
                    style: BorderStyle.solid)),
            child: ListTile(
              leading: FadeInImage(
                  placeholder: const AssetImage('assets/productos_gz.jpg'),
                  image: NetworkImage(foto),
                  width: MediaQuery.of(context).size.width * 0.15),
              title: Text(producto,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              subtitle: Text('${cantidadS} * ${Preferencias.moneda}${precio2}'),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red[300],
                  size: 30,
                ),
                onPressed: () async {
                  print('adios articulo');
                  await ListDet.delete_producto(widget.id_tmp, item_id);
                  ListDet.transacciones(widget.id_tmp);
                  print('listo');
                },
              ),
              onTap: () {
                //customBottomSheet(context,lispr ListDet.list_det[index].productos[0]);

                //customBottomSheet(context, ListDet.list_det[index].productos);
              },
            ),
          );
        }));
    /*return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap:true,
      itemCount: data.length,
      itemBuilder: (c, i) {
        return ListTile(
          title: Text(data[i]['title'].toString(),
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: Text(
              "${f.format(data[i]['price'])} x ${data[i]['qty']}"),
          trailing: Text(f.format(data[i]['price'] * data[i]['qty'])),
        );
      });*/
  }
}
