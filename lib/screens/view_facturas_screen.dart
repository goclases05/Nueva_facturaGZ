import 'dart:convert';

import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/models/data_facturas_models.dart';
import 'package:factura_gozeri/print/print_page.dart';
import 'package:factura_gozeri/print/print_print.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/providers/print_provider.dart';
import 'package:factura_gozeri/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  List<DataFacturas> list_emi = [];
  int i = 0;
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  Future<bool> getCursosData({bool isRefresh = false}) async {
    // Read all values
    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;
    /*if(i==10){
      list_emi.clear();
      list_emi.clear();
    }*/
    if (isRefresh == true) {
      i = 0;
      list_emi.clear();
    }
    print(
        "https://app.gozeri.com/flutter_gozeri/factura/listFacturas.php?empresa=${empresa}&limit=${i}&accion=${widget.accion}&idusuario=${id_usuario}&sucu=${Preferencias.sucursal}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/flutter_gozeri/factura/listFacturas.php?empresa=${empresa}&limit=${i}&accion=${widget.accion}&idusuario=${id_usuario}&sucu=${Preferencias.sucursal}");

    final resp = await http.get(uri);
    final o = json.decode(resp.body);
    print('la e: ');
    print(o.length);
    if (o.length == 0) {
    } else {
      for (int e = 0; e < o.length; e++) {
        var lfac = DataFacturas.fromJson(json.decode(resp.body)[e]);

        if (widget.accion == 'Emitidas') {
          print('entro final');
          list_emi.add(lfac);
          print('salio final');
        } else if (widget.accion == 'Pendientes') {
          print('entro tmp');
          list_tmp.add(lfac);
          print('salio tmp');
        }
      }

      //final search = ProductosDepartamento.fromJson(resp.body);

      i = i + 10;
    }
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
              child: (widget.accion == 'Pendientes')
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
                                  GestureDetector(
                                    onTap: () async {
                                      final _facturacion =
                                          Provider.of<Facturacion>(context,
                                              listen: false);
                                       _facturacion
                                          .list_cart(list_tmp[index].idFactTmp);
                                       _facturacion.read_cliente('read',
                                          '0', list_tmp[index].idFactTmp);

                                       _facturacion.serie(
                                          list_tmp[index].idFactTmp,
                                          'read',
                                          '');
                                       _facturacion.transacciones(
                                          list_tmp[index].idFactTmp);
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => PrintScreen(
                                                    id_tmp: list_tmp[index]
                                                        .idFactTmp,
                                                    colorPrimary:
                                                        widget.colorPrimary,
                                                    serie: _facturacion
                                                        .initialSerie,
                                                  )));
                                    },
                                    child: Container(
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
                              subtitle: Text(
                                '${list_tmp[index].fecha}',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black38),
                              ),
                              onTap: () {},
                            );
                          })
                      : Center(child: Text('Sin data'))
                  : (widget.accion == 'Emitidas')
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
                                      GestureDetector(
                                        onTap: () {
                                          final printProvider =
                                              Provider.of<PrintProvider>(
                                                  context,
                                                  listen: false);
                                          printProvider.dataFac(
                                              list_emi[index].idFactTmp);
                                          /*await printProvider.dataFac(
                                              list_emi[index].idFactTmp);

                                          final _facturacion =
                                              Provider.of<Facturacion>(context,
                                                  listen: false);
                                          await _facturacion.list_cart(
                                              list_emi[index].idFactTmp);
                                          await _facturacion.read_cliente(
                                              'read',
                                              '0',
                                              list_emi[index].idFactTmp);
                                          await _facturacion.serie(
                                              list_emi[index].idFactTmp,
                                              'read',
                                              '');
                                          await _facturacion.transacciones(
                                              list_emi[index].idFactTmp);*/
                                          // ignore: use_build_context_synchronously
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => ViewTicket(
                                                        colorPrimary:
                                                            widget.colorPrimary,
                                                        estado: list_emi[index]
                                                            .estado,
                                                        factura: list_emi[index]
                                                            .idFactTmp,
                                                      )));
                                        },
                                        child: Container(
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
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          print('print ' +
                                              list_emi[index].idFactTmp);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PrintSC(
                                                  id_tmp:
                                                      list_emi[index].idFactTmp,
                                                ),
                                              ));
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 2),
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
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                    'No ${list_emi[index].no}: ${list_emi[index].nombre} ${list_emi[index].apellidos}',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(167, 0, 0, 0)),
                                  ),
                                  subtitle: Text(
                                    '${list_emi[index].fecha}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black38),
                                  ),
                                  onTap: () {},
                                  trailing: Chip(
                                      padding: const EdgeInsets.all(1),
                                      backgroundColor:
                                          (list_emi[index].estado == '2')
                                              ? const Color.fromARGB(255, 169,
                                                  189, 105)
                                              : const Color.fromARGB(
                                                  255, 232, 116, 107),
                                      label: Text(
                                        (list_emi[index].estado == '2')
                                            ? 'Pagada'
                                            : 'Anulada',
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      )),
                                );
                              })
                          : const Center(child: Text('Sin data'))
                      : const Center(child: Text('Sin acciones'))),
        ));
  }
}
