import 'dart:convert';

import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/models/data_facturas_models.dart';
import 'package:factura_gozeri/models/view_factura_print.dart';
import 'package:factura_gozeri/print/print_page.dart';
import 'package:factura_gozeri/print/print_print.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/providers/print_provider.dart';
import 'package:factura_gozeri/screens/screens.dart';
import 'package:factura_gozeri/services/departamentos_services.dart';
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
  void dispose() {
    // TODO: implement dispose
    _printerManager.stopScan();
    super.dispose();
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
                                      _printerManager.stopScan();
                                      final _depa =
                                          Provider.of<DepartamentoService>(
                                              context,
                                              listen: false);
                                      _depa.isLoading = true;
                                      _depa.LoadDepa();

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
                                          _printerManager.stopScan();
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
                                                                              i],
                                                                          list_emi[index]
                                                                              .idFactTmp);
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
                                                  await _startPrint(
                                                      printer,
                                                      list_emi[index]
                                                          .idFactTmp);
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

  Future<void> _startPrint(PrinterBluetooth printer, String id_factura) async {
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
    final result =
        await _printerManager.printTicket(await testTicket(id_factura));
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

  Future<List<int>> testTicket(String id_factura) async {
    final print_data = Provider.of<PrintProvider>(context, listen: false);
    await print_data.dataFac(id_factura);
    List<Encabezado> encabezado = print_data.list;
    List<Detalle> detalle = print_data.list_detalle;

    int sede = 0;
    //0= empresa
    //1= sucursal
    if ((encabezado[0].fel == '0' && encabezado[0].felSucu == '1') ||
        (encabezado[0].fel == '1' && encabezado[0].felSucu == '1')) {
      sede = 1;
    } else if (encabezado[0].fel == '1' && encabezado[0].felSucu == '0') {
      sede = 0;
    }

    // Using default profile
    final profile = await CapabilityProfile.load();
    final generatorr = Generator(PaperSize.mm58, profile);

    List<int> bytess = [];
    bytess += generatorr.setGlobalCodeTable('CP1252');

    //nombre de la empresa
    (sede == 1)
        ? bytess += generatorr.text(encabezado[0].nombreEmpresaSucu,
            styles: const PosStyles(
                codeTable: 'CP1252',
                align: PosAlign.center,
                bold: true,
                width: PosTextSize.size1))
        : bytess += generatorr.text(encabezado[0].nombreEmpresa,
            styles: const PosStyles(
                codeTable: 'CP1252',
                align: PosAlign.center,
                bold: true,
                width: PosTextSize.size1));

    //DIreccion empresa
    (sede == 1)
        ? bytess += generatorr.text(encabezado[0].direccionSucu,
            styles: const PosStyles(
                    width: PosTextSize.size1, bold: true, codeTable: 'CP1252')
                .copyWith(align: PosAlign.center))
        : bytess += generatorr.text(encabezado[0].direccion,
            styles: const PosStyles(
                    width: PosTextSize.size1, bold: true, codeTable: 'CP1252')
                .copyWith(align: PosAlign.center));

    //NIT EMPRESA
    if (encabezado[0].nit_emisor != '') {
      bytess += generatorr.text('NIT: ${encabezado[0].nit_emisor}',
          styles: const PosStyles(
                  width: PosTextSize.size1, bold: true, codeTable: 'CP1252')
              .copyWith(align: PosAlign.center));
    }

    //TELEFONO EMPRESA
    if (sede == 1) {
      if (encabezado[0].teleSucu != '') {
        bytess += generatorr.text('Teléfono: ${encabezado[0].teleSucu}',
            styles: const PosStyles(
                align: PosAlign.center,
                width: PosTextSize.size1,
                bold: true,
                codeTable: 'CP1252'));
      }
    } else if (encabezado[0].telefono != '') {
      bytess += generatorr.text('Teléfono: ${encabezado[0].telefono}',
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));
    }

    //espacio
    bytess += generatorr.feed(1);

    //NOMBRE COMERCIAL
    if (sede == 1) {
      if (encabezado[0].nombre_comercial_sucu != '') {
        bytess += generatorr.text(encabezado[0].nombre_comercial_sucu,
            styles: const PosStyles(
                align: PosAlign.center,
                width: PosTextSize.size1,
                bold: true,
                codeTable: 'CP1252'));
      }
    } else if (encabezado[0].nombre_comercial_emp != '') {
      bytess += generatorr.text(encabezado[0].nombre_comercial_emp,
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));
    }

    //espacio
    bytess += generatorr.feed(1);

    //FEL
    if (encabezado[0].dte != '') {
      bytess += generatorr.text('Factura Electrónica Documento Tributario',
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));
    }

    //espacio
    bytess += generatorr.feed(1);

    //FECHA EMITIDA
    bytess += generatorr.text(encabezado[0].fecha_letras,
        styles: const PosStyles(
            align: PosAlign.right,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //AUTORIZACION
    if (encabezado[0].dte != '') {
      bytess += generatorr.text('Número de Autorización:',
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));

      bytess += generatorr.text(encabezado[0].dte,
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));

      bytess += generatorr.text('Serie: ${encabezado[0].serieDte}',
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));

      bytess += generatorr.text('Número de DTE: ${encabezado[0].noDte}',
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));
    }

    //espacio
    bytess += generatorr.feed(1);

    //No
    bytess += generatorr.text('No: ${encabezado[0].no}',
        styles: const PosStyles(
            align: PosAlign.right,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //SERIE
    bytess += generatorr.text('Serie: ${encabezado[0].serie}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //VENDEDOR
    bytess += generatorr.text(
        'Vendedor : ${encabezado[0].nombreV} ${encabezado[0].apellidosV}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //CLIENTE
    bytess += generatorr.text(
        'Cliente: ${encabezado[0].nombre} ${encabezado[0].apellidos}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //NIT CLIENTE
    bytess += generatorr.text('NIT: ${encabezado[0].nit}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //DIRECCION CLIENTE
    if (encabezado[0].direccionCli != '') {
      bytess += generatorr.text('Dirección: ${encabezado[0].direccionCli}',
          styles: const PosStyles(
              align: PosAlign.left,
              width: PosTextSize.size1,
              codeTable: 'CP1252'));
    }

    //espacio
    bytess += generatorr.feed(1);

    //CONDICIONES DE PAGO
    bytess += generatorr.text('Condiciones de pago:',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    bytess += generatorr.text('${encabezado[0].forma}',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //TABLA PRODUCTOS
    bytess += generatorr.row([
      PosColumn(
        text: 'Descripción',
        width: 9,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: 'Subtotal',
        width: 3,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    //Detalle productos
    for (int al = 0; al < detalle.length; al++) {
      double tota =
          double.parse(detalle[al].cantidad) * double.parse(detalle[al].precio);
      bytess += generatorr.row([
        PosColumn(
          text: '${detalle[al].producto}',
          width: 9,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: '',
          width: 3,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      bytess += generatorr.row([
        PosColumn(
          text:
              '${detalle[al].cantidad} * ${detalle[al].contenido}${detalle[al].precio}',
          width: 9,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: '${detalle[al].contenido}${tota}',
          width: 3,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    //DESCUENTOS
    bytess += generatorr.row([
      PosColumn(
        text: 'Descuento(-):',
        width: 9,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
      PosColumn(
        text: encabezado[0].contenido + encabezado[0].descuento,
        width: 3,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    //TOTAL PRODUCTOS
    bytess += generatorr.row([
      PosColumn(
        text: 'Total:',
        width: 9,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
      PosColumn(
        text: encabezado[0].contenido + encabezado[0].total,
        width: 3,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    //espacio
    bytess += generatorr.feed(1);

    //TOTAL LETRAS
    bytess += generatorr.text('${encabezado[0].totalLetas}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //Frases
    for (int rl = 0; rl < encabezado[0].frases.length; rl++) {
      bytess += generatorr.text(encabezado[0].frases[rl],
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              codeTable: 'CP1252'));
    }

    //espacio
    bytess += generatorr.feed(1);

    //DATOS DE CERTIFICADOR
    if (encabezado[0].dte != '') {
      bytess += generatorr.text('Certificador: ${encabezado[0].certificador}',
          styles: const PosStyles(
              align: PosAlign.left,
              width: PosTextSize.size1,
              codeTable: 'CP1252'));

      bytess += generatorr.text('NIT: ${encabezado[0].nitCert}',
          styles: const PosStyles(
              align: PosAlign.left,
              width: PosTextSize.size1,
              codeTable: 'CP1252'));

      bytess += generatorr.text('Fecha: ${encabezado[0].fechaCert}',
          styles: const PosStyles(
              align: PosAlign.left,
              width: PosTextSize.size1,
              codeTable: 'CP1252'));
    }

    //espacio
    bytess += generatorr.feed(1);

    //datos del sistema
    bytess += generatorr.text('Realizado en www.gozeri.com',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    bytess += generatorr.cut();
    return bytess;
  }
}
