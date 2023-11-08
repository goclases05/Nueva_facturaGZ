import 'dart:convert';

import 'package:edge_alerts/edge_alerts.dart';
import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:http/http.dart' as http;

class ItemCliente extends StatefulWidget {
  ItemCliente({Key? key, required this.colorPrimary, required this.tmp})
      : super(key: key);
  Color colorPrimary;
  String tmp;

  @override
  State<ItemCliente> createState() => _ItemCliente();
}

class _ItemCliente extends State<ItemCliente> {
  Future<List> fetchData() async {
    await Future.delayed(Duration(milliseconds: 0));
    final String _baseUrl = "app.gozeri.com";
    List _list = [];
    String _inputText = searchC.text;

    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;
    final tipo = Preferencias.tipo;

    print(
        "https://${_baseUrl}/versiones/v1.5.5/factura/clientes_factura.php?empresa=${empresa}&idusuario=${id_usuario}&clientes=${_inputText}&tipo=${tipo}&usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://${_baseUrl}/versiones/v1.5.5/factura/clientes_factura.php?empresa=${empresa}&idusuario=${id_usuario}&clientes=${_inputText}&tipo=${tipo}&usuario=${id_usuario}");

    final resp = await http.get(uri);
    int count = json.decode(resp.body).length;

    List _jsonList = json.decode(resp.body);

    for (int i = 0; i < count; i++) {
      _list.add(new TestItem.fromJson(_jsonList[i]));
    }
    return _list;
  }

  TextEditingController searchC = TextEditingController();

  void customBottomSheet(BuildContext context) {
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
                                    child: CreateClienteWidget(
                                      colorPrimary: widget.colorPrimary,
                                      tmp: widget.tmp,
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

  @override
  void initState() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var FacturaProvider = Provider.of<Facturacion>(context, listen: false);

    String cliente = FacturaProvider.cliente
        .replaceAll("(${FacturaProvider.nit_cliente})", "");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Divider(
          height: 20,
        ),
        Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextFieldSearch(
                    decoration: const InputDecoration(
                        label: Text('NIT, usuario, nombre, correo'),
                        border: OutlineInputBorder()),
                    label: 'NIT, usuario, nombre, correo',
                    controller: searchC,
                    minStringLength: 1,
                    future: () async {
                      return await fetchData();
                    },
                    getSelectedValue: (value) async {
                      searchC.text = value.label;
                      if (searchC.text.length > 0) {
                        await FacturaProvider.read_cliente(
                            'remove', value.id, widget.tmp);
                      } else {
                        /*cliente = '';
                      id_cliente = '';
                      nit_cliente = '';*/
                      }
                      setState(
                          () {}); // this prints the selected option which could be an object
                    })),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(37, 0, 0, 0),
                      width: 2,
                    ),
                    color: Color.fromARGB(255, 43, 131, 182)),
                padding: const EdgeInsets.symmetric(vertical: 3.6),
                //color: Color.fromARGB(255, 65, 185, 214),
                alignment: Alignment.center,
                child: IconButton(
                    onPressed: () async {
                      /*const snackBar = SnackBar(
                        padding: EdgeInsets.all(20),
                        content: Text(
                          'Buscando NIT en SAT ...',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Color.fromARGB(255, 19, 126, 164),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                      edgeAlert(context,
                          description: 'Buscando NIT en SAT ...',
                          gravity: Gravity.top,
                          backgroundColor: Color.fromARGB(255, 19, 126, 164));

                      await FacturaProvider.get_Sat(widget.tmp, searchC.text);
                      if (FacturaProvider.cambio_c != '0') {
                        /*SnackBar snackBar = SnackBar(
                          padding: EdgeInsets.all(20),
                          content: Text(
                            FacturaProvider.cambio_c,
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color.fromARGB(255, 210, 92, 83),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                        edgeAlert(context,
                            description: '${FacturaProvider.cambio_c}',
                            gravity: Gravity.top,
                            backgroundColor: Colors.redAccent);
                      } else {
                        /* const snackBar = SnackBar(
                          padding: EdgeInsets.all(20),
                          content: Text(
                            'Cliente Agregado',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color.fromARGB(255, 93, 202, 164),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                        edgeAlert(context,
                            description: 'Cliente Agregado',
                            gravity: Gravity.top,
                            backgroundColor: Color.fromARGB(255, 81, 131, 83));
                      }
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 25,
                    )),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    border: Border.all(
                      color: Color.fromARGB(37, 0, 0, 0),
                      width: 2,
                    ),
                    color: widget.colorPrimary),
                padding: const EdgeInsets.symmetric(vertical: 3.6),
                alignment: Alignment.center,
                child: IconButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      searchC.text = '';
                      setState(() {});
                      customBottomSheet(context);
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 25,
                    )),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Cliente',
          style: TextStyle(
              fontSize: 18,
              color: widget.colorPrimary,
              fontWeight: FontWeight.bold),
        ),
        (FacturaProvider.id == '')
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26, width: 1)),
                child: const ListTile(
                    title: Text(
                      'Sin Cliente',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 221, 221, 221),
                      child: Icon(
                        Icons.warning,
                        size: 25,
                        color: Colors.white,
                      ),
                    )),
              )
            : Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26, width: 1)),
                child: ListTile(
                  title: Text(
                    '${cliente}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'NIT: ${FacturaProvider.nit_cliente}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 221, 221, 221),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: () async {
                        searchC.text = '';
                        /*FacturaProvider.cliente='';
                          FacturaProvider.nit_cliente='';
                          FacturaProvider.id_cliente='';*/
                        await FacturaProvider.read_cliente(
                            'remove', '0', widget.tmp);
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.close,
                        color: widget.colorPrimary,
                      )),
                ),
              )
        /*Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: const TextField(
              decoration: InputDecoration(
            label: Text('Descuento'),
            icon: Icon(
              Icons.percent,
              color: Color.fromARGB(255, 15, 96, 106),
            ),
            border: OutlineInputBorder(),
            focusColor: Colors.red,
            fillColor: Colors.red,
          )),
        ),*/
      ],
    );
  }
}

class TestItem {
  String label;
  String id;
  String nit;
  TestItem({required this.label, required this.id, required this.nit});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], id: json['id'], nit: json['nit']);
  }
}
