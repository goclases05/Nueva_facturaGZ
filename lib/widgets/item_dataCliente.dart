import 'dart:convert';

import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:flutter/material.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:http/http.dart' as http;

class ItemCliente extends StatefulWidget {
  ItemCliente({Key? key, required this.colorPrimary}) : super(key: key);
  Color colorPrimary;

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

    print(
        "https://${_baseUrl}/flutter_gozeri/factura/clientes_factura.php?empresa=${empresa}&idusuario=${id_usuario}&clientes=${_inputText}");
    final Uri uri = Uri.parse(
        "https://${_baseUrl}/flutter_gozeri/factura/clientes_factura.php?empresa=${empresa}&idusuario=${id_usuario}&clientes=${_inputText}");

    final resp = await http.get(uri);
    int count = json.decode(resp.body).length;

    List _jsonList = json.decode(resp.body);

    for (int i = 0; i < count; i++) {
      _list.add(new TestItem.fromJson(_jsonList[i]));
    }
    return _list;
  }

  TextEditingController searchC = TextEditingController();
  String cliente = '';
  String nit_cliente = '';
  String id_cliente = '';

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
                child: /*const TextField(
                  decoration: InputDecoration(
                      label: Text('NIT, usuario, nombre, correo'),
                      icon: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 15, 96, 106),
                      ),
                      border: OutlineInputBorder())),*/
                    TextFieldSearch(
                        decoration: const InputDecoration(
                            label: Text('NIT, usuario, nombre, correo'),
                            border: OutlineInputBorder()),
                        label: 'NIT, usuario, nombre, correo',
                        controller: searchC,
                        minStringLength: 1,
                        future: () async {
                          return await fetchData();
                        },
                        getSelectedValue: (value) {
                          searchC.text = value.label;
                          setState(() {
                            if (searchC.text.length > 0) {
                              cliente = value.label;
                              id_cliente = value.id;
                              nit_cliente = value.nit;
                            } else {
                              cliente = '';
                              id_cliente = '';
                              nit_cliente = '';
                            }
                          }); // this prints the selected option which could be an object
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
                    onPressed: () {},
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
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 25,
                    )),
              ),
            )
          ],
        ),
        const SizedBox(height: 5),
        (searchC.text.length == 0)
            ? Text('')
            : Container(
                width: MediaQuery.of(context).size.width * 1,
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 231, 245, 248)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Cliente:',
                            style: TextStyle(
                                color: widget.colorPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        Expanded(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchC.text = '';
                                    cliente = '';
                                    id_cliente = '';
                                    nit_cliente = '';
                                  });
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: widget.colorPrimary,
                                )),
                          ],
                        ))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                const Text('Nombre',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 168, 184, 192),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Text(cliente)
                              ])),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text('NIT',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 168, 184, 192),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text(nit_cliente)
                            ],
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
