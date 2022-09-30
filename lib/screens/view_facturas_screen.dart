import 'dart:convert';

import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/models/data_facturas_models.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_plus/pull_to_refresh_plus.dart';

import 'package:http/http.dart' as http;

class ViewFacturas extends StatefulWidget {
  ViewFacturas({Key? key, required this.colorPrimary, required this.accion})
      : super(key: key);
  Color colorPrimary;
  final String accion;

  @override
  State<ViewFacturas> createState() => _ViewFacturasState();
}

class _ViewFacturasState extends State<ViewFacturas> {
  List<DataFacturas> list_tmp = [];
  List<String> list_emi = [];
  int i = 10;
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  Future<bool> getCursosData({bool isRefresh = false}) async {
    // Read all values
    final empresa = Preferencias.data_empresa;
    print(
        "https://app.gozeri.com/flutter_gozeri/factura/listFacturas.php?empresa=${empresa}&limit=${i}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/flutter_gozeri/factura/listFacturas.php?empresa=${empresa}&limit=${i}");

    final resp = await http.get(uri);
    final o = json.decode(resp.body).lenght;
    print('la e: ');
    print(o.toString());
    for (int e = 0; e < o; e++) {
      var lfac = DataFacturas.fromJson(json.decode(resp.body)[e]);
      list_tmp.add(lfac);
    }

    //final search = ProductosDepartamento.fromJson(resp.body);

    i = i + 10;
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(0),
        child: Scaffold(
          body: SmartRefresher(
              physics: const BouncingScrollPhysics(),
              header: WaterDropMaterialHeader(
                distance: 30,
                color: Colors.white,
                backgroundColor: widget.colorPrimary,
              ),
              controller: refreshController,
              enablePullUp: true,
              onRefresh: () async {
                final result = await getCursosData(isRefresh: true);
                if (result) {
                  refreshController.refreshCompleted();
                } else {
                  refreshController.refreshFailed();
                }
              },
              onLoading: () async {
                final result = await getCursosData();
                if (result) {
                  refreshController.loadComplete();
                } else {
                  refreshController.loadFailed();
                }
              },
              child: (widget.accion == 'pendiente')
                  ? (list_tmp.length > 0)
                      ? ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: list_tmp.length,
                          separatorBuilder: ((_, __) {
                            return const Divider(
                              height: 1,
                              color: Colors.blueGrey,
                            );
                          }),
                          itemBuilder: (context, index) {
                            return ListTile(
                              //tileColor: Color.fromARGB(255, 255, 226, 223),
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        //color: Theme.of(context).primaryColor,
                                        color: widget.colorPrimary,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Icon(
                                      Icons.receipt_long,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 2),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        //color: Theme.of(context).primaryColor,
                                        color:
                                            Color.fromARGB(255, 236, 125, 117),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                '${list_tmp[index].nombre} ${list_tmp[index].apellidos}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(167, 0, 0, 0)),
                              ),
                              subtitle: const Text(
                                '06/10/2022  8:55',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black38),
                              ),
                              onTap: () {},
                            );
                          })
                      : const Center(child: Text('Sin data'))
                  : (widget.accion == 'emitidas')
                      ? (list_emi.length > 0)
                          ? ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: list_emi.length,
                              separatorBuilder: ((_, __) {
                                return const Divider(
                                  height: 1,
                                  color: Colors.blueGrey,
                                );
                              }),
                              itemBuilder: (context, index) {
                                return ListTile(
                                  //tileColor: Color.fromARGB(255, 255, 226, 223),
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            //color: Theme.of(context).primaryColor,
                                            color: widget.colorPrimary,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Icon(
                                          Icons.visibility,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 2),
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            //color: Theme.of(context).primaryColor,
                                            color: Colors.lightBlue,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Icon(
                                          Icons.print,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                    'No ${index}: ${list_emi[index]}',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(167, 0, 0, 0)),
                                  ),
                                  subtitle: const Text(
                                    '06/10/2022  8:55',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black38),
                                  ),
                                  onTap: () {},
                                  trailing: const Chip(
                                      padding: EdgeInsets.all(1),
                                      backgroundColor:
                                          Color.fromARGB(255, 189, 209, 123),
                                      label: Text(
                                        'Pagada',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      )),
                                );
                              })
                          : const Center(child: Text('Sin data'))
                      : const Center(child: Text('Sin acciones'))),
        ));
  }
}
