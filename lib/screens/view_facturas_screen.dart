import 'dart:convert';

import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
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
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();

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
  void initState() {
    if (widget.accion == 'Emitidas') {
      _printerManager.startScan(const Duration(seconds: 2));
    } else {
      _printerManager.stopScan();
    }

    super.initState();
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
                                      _facturacion.read_cliente('read', '0',
                                          list_tmp[index].idFactTmp);

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
                                        color: const Color.fromARGB(
                                            255, 236, 125, 117),
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
                      : const Center(child: Text('Sin data'))
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
                                          // ignore: await_only_futures

                                          _printerManager.scanResults
                                              .listen((devices) async {
                                            print(devices);

                                            if (Preferencias.mac == '') {
                                              showDialog(
                                                  context: context,
                                                  builder: ((context) {
                                                    if (devices.length == 0) {
                                                      return const AlertDialog(
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                236, 133, 115),
                                                        content: Text(
                                                          'No se encontraron impresoras disponibles.',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      );
                                                    }

                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Impresoras Disponibles'),
                                                      content: Container(
                                                        height:
                                                            300.0, // Change as per your requirement
                                                        width:
                                                            300.0, // Change as per your requirement
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              devices.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int i) {
                                                            return ListTile(
                                                              title: Text(
                                                                  "${devices[i].name}"),
                                                              subtitle: Text(
                                                                  "${devices[i].address}"),
                                                              trailing: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      _printerManager
                                                                          .stopScan();
                                                                      _startPrint(
                                                                          devices[
                                                                              i]);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      margin:
                                                                          const EdgeInsets.all(
                                                                              5),
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              10),
                                                                      decoration: BoxDecoration(
                                                                          //color: Theme.of(context).primaryColor,
                                                                          color: widget.colorPrimary,
                                                                          borderRadius: BorderRadius.circular(15)),
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .print,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            25,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              onTap: () {},
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  }));
                                            } else {
                                              //impresion en predeterminada

                                              devices.forEach((printer) async {
                                                print(printer);
                                                //get saved printer
                                                if (printer.address ==
                                                    Preferencias.mac) {
                                                  //store the element.
                                                  await _startPrint(printer);
                                                }
                                              });
                                            }
                                          });
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

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        backgroundColor: Color.fromARGB(255, 115, 160, 236),
        content: Text(
          'Imprimiendo...',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    final result = await _printerManager.printTicket(
        await testTicket(printer.name.toString(), printer.address.toString()));
    Navigator.of(context, rootNavigator: true).pop(result);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: (result.msg == 'Success')
            ? const Color.fromARGB(255, 109, 224, 186)
            : const Color.fromARGB(255, 201, 124, 124),
        content: Text(
          (result.msg == 'Success') ? 'Listo..' : result.msg,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<List<int>> testTicket(String msg, String id_device) async {
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generatorr = Generator(PaperSize.mm58, profile);
    List<int> bytess = [];

    /*bytess += generatorr.text('Impresión Factura',
        styles: const PosStyles(
            codeTable: 'CP1252',
            align: PosAlign.center,
            bold: true,
            width: PosTextSize.size2));*/

    //DIreccion empresa
    bytess += generatorr.text('4ta calle 5-63 zona 8',
        styles: const PosStyles(
                width: PosTextSize.size1, bold: true, codeTable: 'CP1252')
            .copyWith(align: PosAlign.center));

    //nombre empresa
    bytess += generatorr.text('Corporación H&T',
        styles: const PosStyles(
                width: PosTextSize.size1, bold: true, codeTable: 'CP1252')
            .copyWith(align: PosAlign.center));

/*
    //NIT EMPRESA
    bytess += generatorr.text('NIT: 857421-96',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //TELEFONO EMPRESA
    bytess += generatorr.text('Tel: 5522-3355',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //NOMBRE COMERCIAL
    bytess += generatorr.text('Hich Tecto',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //FEL
    bytess += generatorr.text('Factura Electrónica Documento Tributario',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //FECHA EMITIDA
    bytess += generatorr.text('25 de octuble 2022',
        styles: const PosStyles(
            align: PosAlign.right,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //AUTORIZACION
    bytess += generatorr.text('Número de Autorización:',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    bytess += generatorr.text('BBaSDFDFDF-56556-aSDFAS',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    bytess += generatorr.text('Serie: BBDF65',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    bytess += generatorr.text('Número de DTE: 25633554785',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //No
    bytess += generatorr.text('No: 128',
        styles: const PosStyles(
            align: PosAlign.right,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //SERIE
    bytess += generatorr.text('Serie: DGTD',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //VENDEDOR
    bytess += generatorr.text('Vendedor : Jerson Hernandez',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //CLIENTE
    bytess += generatorr.text('Cliente: Magdalena España de la Rosa',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //NIT CLIENTE
    bytess += generatorr.text('NIT: 54545454',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //DIRECCION CLIENTE
    bytess += generatorr.text('Dirección: 8va ave 7-88 Villa Nueva',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //CONDICIONES DE PAGO
    bytess += generatorr.text('Condiciónes de pago:',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    bytess += generatorr.text('Contado',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //TABLA PRODUCTOS
    generatorr.row([
      PosColumn(
        text: 'Descripción',
        width: 9,
        styles: const PosStyles(align: PosAlign.right, underline: true),
      ),
      PosColumn(
        text: 'Subtotal',
        width: 3,
        styles: const PosStyles(align: PosAlign.right, underline: true),
      ),
    ]);

    //DESCUENTO DE PRODUCTOS
    generatorr.row([
      PosColumn(
        text: 'Descuentos(-):',
        width: 9,
        styles: const PosStyles(align: PosAlign.right, underline: true),
      ),
      PosColumn(
        text: 'Q0.00',
        width: 3,
        styles: const PosStyles(align: PosAlign.right, underline: true),
      ),
    ]);

    //TOTAL PRODUCTOS
    generatorr.row([
      PosColumn(
        text: 'Total:',
        width: 9,
        styles: const PosStyles(align: PosAlign.right, underline: true),
      ),
      PosColumn(
        text: 'Q0.00',
        width: 3,
        styles: const PosStyles(align: PosAlign.right, underline: true),
      ),
    ]);

    //espacio
    bytess += generatorr.feed(1);

    //TOTAL LETRAS
    bytess += generatorr.text('novecientos cuarenta con 00/100',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //Frases
    bytess += generatorr.text('Sujeto a pagos trimestrales',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //DATOS DE CERTIFICADOR
    bytess += generatorr.text('Certificador: Megaprint S.A',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    bytess += generatorr.text('NIT: 558471-63',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    bytess += generatorr.text('Fecha: 85-69-2022 10:00',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //datos del sistema
    bytess += generatorr.text('Factura realizada en www.gozeri.com',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));
*/
    /*bytes += generator.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ');
    bytes += generator.text('Special 2: blåbærgrød');

    bytes += generator.text('Bold text', styles: PosStyles(bold: true));
    bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    bytes +=
        generator.text('Align left', styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.text('Text size 200%',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));*/

    //bytes += generator.feed(2);
    bytess += generatorr.cut();
    return bytess;
  }
}
