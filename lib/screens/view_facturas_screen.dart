import 'dart:convert';
import 'dart:typed_data';

import 'package:edge_alerts/edge_alerts.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:factura_gozeri/models/data_facturas_models.dart';
import 'package:factura_gozeri/models/view_factura_print.dart';
import 'package:factura_gozeri/print/print_print.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/providers/impresoras_provider.dart';
import 'package:factura_gozeri/providers/print_provider.dart';
import 'package:factura_gozeri/screens/view_ticket_desing_screen.dart';
import 'package:factura_gozeri/services/departamentos_services.dart';
import 'package:factura_gozeri/widgets/registro_metodoPago_listas_widget.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:factura_gozeri/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_plus/pull_to_refresh_plus.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

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
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  List<DataFacturas> list_tmp = [];
  List<DataFacturas> list_emi = [];
  int i = 0;
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  

  //SUNMIN
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  //SUNMIN
  bool state_bluetooth = false;

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
      list_tmp.clear();
    }
    print(
        "https://app.gozeri.com/versiones/v1.5.5/factura/listFacturas.php?empresa=${empresa}&limit=${i}&accion=${widget.accion}&idusuario=${id_usuario}&sucu=${Preferencias.sucursal}&usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/versiones/v1.5.5/factura/listFacturas.php?empresa=${empresa}&limit=${i}&accion=${widget.accion}&idusuario=${id_usuario}&sucu=${Preferencias.sucursal}&usuario=${id_usuario}");

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
    super.initState();

    //estado del bluetooth
    bluetoothManager.state.listen((val) {
      print('state = $val');
      if (val == 12) {
        print('on');
        //escaneo
        setState(() {
          state_bluetooth = true;
        });
        //escaneo
      } else if (val == 10) {
        setState(() {
          state_bluetooth = false;
        });
      }
    });
    //estado del bluetooth

    if (Preferencias.sunmi_preferencia) {
      _bindingPrinter().then((bool? isBind) async {
        SunmiPrinter.paperSize().then((int size) {
          setState(() {
            paperSize = size;
          });
        });

        SunmiPrinter.printerVersion().then((String version) {
          setState(() {
            printerVersion = version;
          });
        });

        SunmiPrinter.serialNumber().then((String serial) {
          setState(() {
            serialNumber = serial;
          });
        });

        setState(() {
          printBinded = isBind!;
        });
      });
    }
  }

  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  void bt_initPrinter(String accion, String id_f) async {
    _printerManager.stopScan();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.locationWhenInUse.request();
    _printerManager.startScan(Duration(seconds: 2));
    print('escaneando');

    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        backgroundColor: Color.fromARGB(255, 243, 231, 155),
        content: ListTile(
          leading: CircularProgressIndicator(
            color: Colors.white,
          ),
          title: Text(
            'Escaneando dispositivos de impresión',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
      print('termino');
      _printerManager.stopScan();

      if (Preferencias.mac != '') {
        //impresora predeterminada
        _printerManager.scanResults.listen((event) {
          print("preferencia impresora");
          print(Preferencias.mac);
          int u = 0;
          //existe una impresora predeterminada
          for (var y = 0; y < event.length; y++) {
            if (event[y].address == Preferencias.mac) {
              //store the element.
              print('esta es');
              _startPrint(event[y], id_f, accion);
            }
          }
        });
      } else {
        //lista de impresoras
        showDialog(
            context: context,
            builder: ((context) {
              return Consumer<ImpresorasProvider>(
                  builder: (context, impresoras, child) {
                _printerManager.scanResults.listen((devices) async {
                  impresoras.impresoras_disponibles(devices);
                });

                if (Preferencias.mac != '') {
                  print("preferencia impresora");
                  print(Preferencias.mac);
                  int u = 0;
                  //existe una impresora predeterminada
                  for (var y = 0; y < impresoras.devices.length; y++) {
                    if (impresoras.devices[y].address == Preferencias.mac) {
                      //store the element.
                      print('esta es');
                      _startPrint(impresoras.devices[y], id_f, accion);
                    }
                  }

                  print('salio de ciclo');
                  if (u == 0) {
                    return AlertDialog(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        content: Text('impresión realizada'));
                  } else {
                    return AlertDialog(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        content: Text('error'));
                  }
                } else {
                  //no existe predeterminada
                  return AlertDialog(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Impresoras',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        (impresoras.devices.length == 0)
                            ? Text(
                                'No se encuentran Impresoras disponibles',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : Container(
                                height: 300.0, // Change as per your requirement
                                width: 300.0,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: impresoras.devices.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return ListTile(
                                      title:
                                          Text("${impresoras.devices[i].name}"),
                                      subtitle: Text(
                                          "${impresoras.devices[i].address}"),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              _startPrint(impresoras.devices[i],
                                                  id_f, accion);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(5),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  //color: Theme.of(context).primaryColor,
                                                  color: widget.colorPrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: const Icon(
                                                Icons.print,
                                                color: Colors.white,
                                                size: 25,
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
                      ],
                    ),
                  );
                }
              });
            }));
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (Preferencias.sunmi_preferencia == false) {
      _printerManager.stopScan();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final facturaService = Provider.of<Facturacion>(context, listen: false);
    double fuente=getScreenSize(context, 0.033,0.016,'w');

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
                                      //_printerManager.stopScan();
                                      final _depa =
                                          Provider.of<DepartamentoService>(
                                              context,
                                              listen: false);
                                      _depa.isLoading = true;
                                      _depa.LoadDepa();

                                      final _facturacion =
                                          Provider.of<Facturacion>(context,
                                              listen: false);

                                      await _facturacion
                                          .readOB(list_tmp[index].idFactTmp);
                                      _facturacion
                                          .list_cart(list_tmp[index].idFactTmp);
                                      _facturacion.read_cliente('read', '0',
                                          list_tmp[index].idFactTmp);

                                      _facturacion.serie(
                                          list_tmp[index].idFactTmp,
                                          'read',
                                          '');
                                      _facturacion.transacciones(
                                          list_tmp[index].idFactTmp, 'tmp');
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
                                                    condicionPagoVal:
                                                        list_tmp[index]
                                                            .terminos,
                                                  )));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          //color: Theme.of(context).primaryColor,
                                          color:
                                              Color.fromARGB(255, 167, 197, 34),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Icon(
                                        Icons.receipt_long,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (Preferencias.sunmi_preferencia) {
                                        await print_sunmi_comanda(
                                            context, list_tmp[index].idFactTmp);
                                      } else {
                                        //PRINT NO SUNMIN
                                        if (state_bluetooth == true) {
                                          //escaneo
                                          bt_initPrinter('comanda',
                                              list_tmp[index].idFactTmp);
                                          //escaneo
                                        } else {
                                          print('off');
                                          showDialog(
                                            context: context,
                                            builder: (_) => const AlertDialog(
                                              backgroundColor: Color.fromARGB(
                                                  255, 224, 140, 31),
                                              content: Text(
                                                'Bluetooth sin Conexión',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                        }
                                        //PRINT NO SUNMIN
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 2),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          //color: Theme.of(context).primaryColor,
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Icon(
                                        Icons.newspaper,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      final data = facturaService.delete_tmp(
                                          list_tmp[index].idFactTmp);

                                      list_tmp.removeAt(index);
                                      edgeAlert(context,
                                          description:
                                              'Factura pendiente anulada',
                                          gravity: Gravity.top,
                                          backgroundColor:
                                              Color.fromARGB(255, 81, 131, 83));

                                      setState(() {});
                                    },
                                    child: Container(
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
                                  ),
                                ],
                              ),
                              title: Text(
                                '${list_tmp[index].nombre} ${list_tmp[index].apellidos}',
                                style: TextStyle(
                                    fontSize: fuente,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(167, 0, 0, 0)),
                              ),
                              subtitle: Text(
                                '${list_tmp[index].fecha}',
                                style: TextStyle(
                                    fontSize: fuente,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black38),
                              ),
                              onTap: () {},
                            );
                          })
                      : Center(child: Text('Sin Registros'))
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
                                        onTap: () async {
                                          // ignore: await_only_futures

                                          if (Preferencias.sunmi_preferencia) {
                                            await print_sunmi(context,
                                                list_emi[index].idFactTmp);
                                          } else {
                                            //PRINT NO SUNMIN
                                            if (state_bluetooth == true) {
                                              //escaneo
                                              bt_initPrinter('f',
                                                  list_emi[index].idFactTmp);
                                              //escaneo
                                            } else {
                                              print('off');
                                              showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    const AlertDialog(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 224, 140, 31),
                                                  content: Text(
                                                    'Bluetooth sin Conexión',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              );
                                            }
                                            //PRINT NO SUNMIN
                                          }
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
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                    'No ${list_emi[index].no}: ${list_emi[index].nombre} ${list_emi[index].apellidos}',
                                    style: TextStyle(
                                        fontSize: fuente,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(167, 0, 0, 0)),
                                  ),
                                  subtitle: Text(
                                    '${list_emi[index].fecha}',
                                    style: TextStyle(
                                        fontSize: fuente,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black38),
                                  ),
                                  onTap: () {
                                    final printProvider =
                                        Provider.of<PrintProvider>(context,
                                            listen: false);
                                    final _facturacion =
                                        Provider.of<Facturacion>(context,
                                            listen: false);

                                    _facturacion.transacciones(
                                        list_emi[index].idFactTmp, 'emitida');

                                    printProvider
                                        .dataFac(list_emi[index].idFactTmp);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ViewTicket(
                                                  colorPrimary:
                                                      widget.colorPrimary,
                                                  estado:
                                                      list_emi[index].estado,
                                                  factura:
                                                      list_emi[index].idFactTmp,
                                                )));
                                  },
                                  trailing: Chip(
                                      padding: const EdgeInsets.all(1),
                                      backgroundColor:
                                          (list_emi[index].estado == '2')
                                              ? Color.fromARGB(255, 28, 192, 28)
                                              : (list_emi[index].estado == '1')
                                                  ? Color.fromARGB(
                                                      255, 233, 195, 72)
                                                  : const Color.fromARGB(
                                                      255, 232, 116, 107),
                                      label: Text(
                                        (list_emi[index].estado == '2')
                                            ? 'Pagada'
                                            : (list_emi[index].estado == '1')
                                                ? 'Pendiente de Pago'
                                                : 'Anulada',
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      )),
                                );
                              })
                          : const Center(child: Text('Cargando resultados..'))
                      : const Center(child: Text('Sin acciones'))),
        ));
  }

  Future<void> _startPrint(
      PrinterBluetooth printer, String id_factura, String accion) async {
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
    final result;
    if (accion == 'f') {
      result = await _printerManager.printTicket(await testTicket(id_factura));
    } else {
      result =
          await _printerManager.printTicket(await comanda_bluetho(id_factura));
    }
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

  Future<List<int>> comanda_bluetho(String id_factura) async {
    final print_data = Provider.of<PrintProvider>(context, listen: false);
    final js = await print_data.generate_comanda(id_factura);
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generatorr = Generator(PaperSize.mm58, profile);

    List<int> bytess = [];
    //espacio
    bytess += generatorr.feed(1);
    bytess += generatorr.setGlobalCodeTable('CP1252');
    String name = '';
    if (js['ENCABEZADO']['NOMBRE_EMPRESA_SUCU'] != null ||
        js['ENCABEZADO']['NOMBRE_EMPRESA_SUCU'] != '') {
      name = js['ENCABEZADO']['NOMBRE_EMPRESA_SUCU'];
    } else {
      name = js['ENCABEZADO']['NOMBRE_EMPRESA'];
    }

    //cliente
    bytess += generatorr.text(
        '${js['ENCABEZADO']['NOMBRE']}  ${js['ENCABEZADO']['APELLIDOS']}',
        styles: const PosStyles(
            codeTable: 'CP1252',
            align: PosAlign.center,
            bold: true,
            width: PosTextSize.size1));

    //numero
    bytess += generatorr.text('#${js['ENCABEZADO']['NO']}',
        styles: const PosStyles(
                width: PosTextSize.size2,
                height: PosTextSize.size2,
                bold: true,
                codeTable: 'CP1252')
            .copyWith(align: PosAlign.center));

    //espacio
    bytess += generatorr.feed(1);

    //TABLA PRODUCTOS
    bytess += generatorr.row([
      PosColumn(
        text: 'Cantidad',
        width: 4,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: 'Producto',
        width: 8,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
    ]);

    for (int al = 0; al < js['DETALLE'].length; al++) {
      bytess += generatorr.row([
        PosColumn(
          text: '${js['DETALLE'][al]['CANTIDAD']}',
          width: 4,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: '${js['DETALLE'][al]['PRODUCTO']}',
          width: 8,
          styles: const PosStyles(align: PosAlign.left),
        ),
      ]);
    }

    String ob = js['ENCABEZADO']['OBSER'];

    if (ob.length > 0) {
      bytess += generatorr.feed(1);
      bytess += generatorr.feed(1);
      bytess += generatorr.text('Observación:',
          styles: const PosStyles(
                  width: PosTextSize.size1, bold: false, codeTable: 'CP1252')
              .copyWith(align: PosAlign.left));
      bytess += generatorr.text('${ob}',
          styles: const PosStyles(
                  width: PosTextSize.size1, bold: false, codeTable: 'CP1252')
              .copyWith(align: PosAlign.left));
    }
    //espacio
    bytess += generatorr.feed(1);
    bytess += generatorr.feed(1);

    bytess += generatorr.text('${name}',
        styles: const PosStyles(
                width: PosTextSize.size1, bold: true, codeTable: 'CP1252')
            .copyWith(align: PosAlign.center));

    bytess += generatorr.text('realizado en www.gozeri.com',
        styles: const PosStyles(
                width: PosTextSize.size1, bold: true, codeTable: 'CP1252')
            .copyWith(align: PosAlign.center));

    bytess += generatorr.cut();
    return bytess;
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

    //estado factura
    if (encabezado[0].estado == '1') {
      bytess += generatorr.text('PENDIENTE DE PAGO',
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));
    } else if (encabezado[0].estado == '2') {
      bytess += generatorr.text('PAGADA',
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));
    } else {
      bytess += generatorr.text('ANULADA',
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

    //fecha vencimiento
    if (encabezado[0].forma != 'Contado') {
      bytess += generatorr.text('Fecha Vence: ${encabezado[0].fechaV}',
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));
    }

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

    String ob = encabezado[0].obser;

    if (ob.length > 0) {
      bytess += generatorr.feed(1);
      bytess += generatorr.text('Observación:',
          styles: const PosStyles(
              align: PosAlign.left,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));
      bytess += generatorr.text('${ob}',
          styles: const PosStyles(
              align: PosAlign.left,
              width: PosTextSize.size1,
              bold: true,
              codeTable: 'CP1252'));
    }

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
  double getScreenSize(BuildContext context, double t1, double t2, String area) {
      // Obtenemos el tamaño de la pantalla utilizando MediaQuery
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;

    if(orientation == Orientation.portrait){
      //vertical
      if(area=='h'){
        return size.height * t1;
      }else{
        return size.width*t1;
      }
      
    }else{
      if(area=='h'){
        return size.height * t2;
      }else{
        return size.width*t2;
      }
    }
  }
}

print_sunmi(BuildContext context, String id_factura) async {
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

  await SunmiPrinter.initPrinter();
  await SunmiPrinter.startTransactionPrint(true);

  /*if (sede == 1) {
    if (encabezado[0].foto != '') {
      String url = encabezado[0].rutaSucu + encabezado[0].foto;
      // convert image to Uint8List format
      Uint8List byte = (await NetworkAssetBundle(Uri.parse(url)).load(url))
          .buffer
          .asUint8List();
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.startTransactionPrint(true);
      await SunmiPrinter.printImage(byte);
    }
  } else {
    if (encabezado[0].logoNom != '') {
      String url = encabezado[0].logoUrl + encabezado[0].logoNom;
      // convert image to Uint8List format
      Uint8List byte = (await NetworkAssetBundle(Uri.parse(url)).load(url))
          .buffer
          .asUint8List();
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.startTransactionPrint(true);
      await SunmiPrinter.printImage(byte);
    }
  }*/
  //await SunmiPrinter.lineWrap(2);

  //nombre de empresa
  await SunmiPrinter.printText(
      (sede == 1)
          ? '${encabezado[0].nombreEmpresaSucu}'
          : '${encabezado[0].nombreEmpresa}',
      style: SunmiStyle(
          bold: true,
          align: SunmiPrintAlign.CENTER,
          fontSize: SunmiFontSize.MD));

  //Direccion de empresa
  await SunmiPrinter.printText(
      (sede == 1)
          ? '${encabezado[0].direccionSucu}'
          : '${encabezado[0].direccion}',
      style: SunmiStyle(
          bold: true,
          align: SunmiPrintAlign.CENTER,
          fontSize: SunmiFontSize.MD));

  //nit emisor
  if (encabezado[0].nit_emisor != '') {
    await SunmiPrinter.printText('NIT: ${encabezado[0].nit_emisor}',
        style: SunmiStyle(
            bold: true,
            align: SunmiPrintAlign.CENTER,
            fontSize: SunmiFontSize.MD));
  }

  //telefono emisor
  if (sede == 1) {
    if (encabezado[0].teleSucu != '') {
      await SunmiPrinter.printText('Tel: ${encabezado[0].teleSucu}',
          style: SunmiStyle(
              bold: true,
              align: SunmiPrintAlign.CENTER,
              fontSize: SunmiFontSize.MD));
    }
  } else {
    if (encabezado[0].telefono != '') {
      await SunmiPrinter.printText('Tel: ${encabezado[0].telefono}',
          style: SunmiStyle(
              bold: true,
              align: SunmiPrintAlign.CENTER,
              fontSize: SunmiFontSize.MD));
    }
  }

  //await SunmiPrinter.lineWrap(1);

  //nombre comercial
  if (sede == 1) {
    if (encabezado[0].nombre_comercial_sucu != '') {
      await SunmiPrinter.printText('${encabezado[0].nombre_comercial_sucu}',
          style: SunmiStyle(
              bold: true,
              align: SunmiPrintAlign.CENTER,
              fontSize: SunmiFontSize.MD));
    }
  } else {
    if (encabezado[0].nombre_comercial_emp != '') {
      await SunmiPrinter.printText('${encabezado[0].nombre_comercial_emp}',
          style: SunmiStyle(
              bold: true,
              align: SunmiPrintAlign.CENTER,
              fontSize: SunmiFontSize.MD));
    }
  }

  //await SunmiPrinter.lineWrap(1);
  //FEL
  if (encabezado[0].dte != '') {
    await SunmiPrinter.printText('Factura Electrónica Documento Tributario',
        style: SunmiStyle(
            bold: true,
            align: SunmiPrintAlign.CENTER,
            fontSize: SunmiFontSize.MD));
  }

  //await SunmiPrinter.lineWrap(1);

  //FECHA EN LETRAS
  await SunmiPrinter.printText('${encabezado[0].fecha_letras}',
      style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.RIGHT,
          fontSize: SunmiFontSize.MD));

  //await SunmiPrinter.lineWrap(1);

  if (encabezado[0].dte != '') {
    await SunmiPrinter.printText('Número de Autorización:',
        style: SunmiStyle(
            bold: false,
            align: SunmiPrintAlign.CENTER,
            fontSize: SunmiFontSize.MD));
    await SunmiPrinter.printText('${encabezado[0].dte}',
        style: SunmiStyle(
            bold: false,
            align: SunmiPrintAlign.CENTER,
            fontSize: SunmiFontSize.MD));
    await SunmiPrinter.printText('Serie: ${encabezado[0].serieDte}',
        style: SunmiStyle(
            bold: false,
            align: SunmiPrintAlign.CENTER,
            fontSize: SunmiFontSize.MD));
    await SunmiPrinter.printText('Número de DTE: ${encabezado[0].noDte}',
        style: SunmiStyle(
            bold: false,
            align: SunmiPrintAlign.CENTER,
            fontSize: SunmiFontSize.MD));
  }

  //estado factura
  if (encabezado[0].estado == '1') {
    await SunmiPrinter.printText('PENDIENTE DE PAGO',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.CENTER,
        ));
  } else if (encabezado[0].estado == '2') {
    await SunmiPrinter.printText('PAGADA',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.CENTER,
        ));
  } else {
    await SunmiPrinter.printText('ANULADA',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.CENTER,
        ));
  }
  //await SunmiPrinter.lineWrap(1);

  //No
  await SunmiPrinter.printText('No: ${encabezado[0].no}',
      style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.RIGHT,
          fontSize: SunmiFontSize.MD));

  //await SunmiPrinter.lineWrap(1);

  //serie
  await SunmiPrinter.printText('Serie: ${encabezado[0].serie}',
      style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.LEFT,
          fontSize: SunmiFontSize.MD));

  //vendedor
  await SunmiPrinter.printText(
      'Vendedor : ${encabezado[0].nombreV} ${encabezado[0].apellidosV}',
      style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.LEFT,
          fontSize: SunmiFontSize.MD));
  //cliente
  await SunmiPrinter.printText(
      'Cliente: ${encabezado[0].nombre} ${encabezado[0].apellidos}',
      style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.LEFT,
          fontSize: SunmiFontSize.MD));
  //nit cliente
  await SunmiPrinter.printText('NIT: ${encabezado[0].nit}',
      style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.LEFT,
          fontSize: SunmiFontSize.MD));

  //direccion cliente
  if (encabezado[0].direccionCli != '') {
    await SunmiPrinter.printText('Dirección: ${encabezado[0].direccionCli}',
        style: SunmiStyle(
            bold: false,
            align: SunmiPrintAlign.LEFT,
            fontSize: SunmiFontSize.MD));
  }

  await SunmiPrinter.lineWrap(1);

  //condiciones de pago
  await SunmiPrinter.printText('Condiciones de pago:',
      style: SunmiStyle(
          bold: true,
          align: SunmiPrintAlign.CENTER,
          fontSize: SunmiFontSize.MD));
  //forma
  await SunmiPrinter.printText('${encabezado[0].forma}',
      style: SunmiStyle(
          bold: true,
          align: SunmiPrintAlign.CENTER,
          fontSize: SunmiFontSize.MD));

  //fecha vence
  if (encabezado[0].forma != 'Contado') {
    await SunmiPrinter.printText('Fecha Vence: ${encabezado[0].fechaV}',
        style: SunmiStyle(
          bold: true,
          align: SunmiPrintAlign.CENTER,
        ));
  }

  //await SunmiPrinter.lineWrap(1);

  await SunmiPrinter.line();
  await SunmiPrinter.printRow(cols: [
    ColumnMaker(text: 'Descripción', width: 20, align: SunmiPrintAlign.LEFT),
    ColumnMaker(text: 'Subtotal', width: 10, align: SunmiPrintAlign.CENTER),
  ]);
  await SunmiPrinter.line();

  //DETALLES
  for (int al = 0; al < detalle.length; al++) {
    double tota =
        double.parse(detalle[al].cantidad) * double.parse(detalle[al].precio);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
          text: '${detalle[al].producto}',
          width: 24,
          align: SunmiPrintAlign.LEFT),
      ColumnMaker(text: '', width: 6, align: SunmiPrintAlign.CENTER),
    ]);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
          text:
              '${detalle[al].cantidad} * ${detalle[al].contenido}${detalle[al].precio}',
          width: 20,
          align: SunmiPrintAlign.LEFT),
      ColumnMaker(
          text: '${detalle[al].contenido}${tota}',
          width: 10,
          align: SunmiPrintAlign.RIGHT),
    ]);
  }
  await SunmiPrinter.line();
  await SunmiPrinter.printRow(cols: [
    ColumnMaker(text: 'Descuento(-):', width: 20, align: SunmiPrintAlign.RIGHT),
    ColumnMaker(
        text: encabezado[0].contenido + encabezado[0].descuento,
        width: 10,
        align: SunmiPrintAlign.CENTER),
  ]);
  await SunmiPrinter.printRow(cols: [
    ColumnMaker(text: 'Total:', width: 20, align: SunmiPrintAlign.RIGHT),
    ColumnMaker(
        text: encabezado[0].contenido + encabezado[0].total,
        width: 10,
        align: SunmiPrintAlign.CENTER),
  ]);
  //await SunmiPrinter.lineWrap(1);

  //total en letras
  await SunmiPrinter.printText('${encabezado[0].totalLetas}',
      style: SunmiStyle(
          bold: true,
          align: SunmiPrintAlign.CENTER,
          fontSize: SunmiFontSize.MD));

  String ob = encabezado[0].obser;

  if (ob.length > 0) {
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('Observación:',
        style: SunmiStyle(
          bold: true,
          align: SunmiPrintAlign.LEFT,
        ));
    await SunmiPrinter.printText('${ob}',
        style: SunmiStyle(
          align: SunmiPrintAlign.LEFT,
        ));
    await SunmiPrinter.lineWrap(1);
  }

  //frases
  for (int rl = 0; rl < encabezado[0].frases.length; rl++) {
    await SunmiPrinter.printText('${encabezado[0].frases[rl]}',
        style: SunmiStyle(
            bold: false,
            align: SunmiPrintAlign.CENTER,
            fontSize: SunmiFontSize.MD));
  }

  //datos certificador
  if (encabezado[0].dte != '') {
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('Certificador: ${encabezado[0].certificador}',
        style: SunmiStyle(
            bold: false,
            align: SunmiPrintAlign.LEFT,
            fontSize: SunmiFontSize.MD));
    await SunmiPrinter.printText('NIT: ${encabezado[0].nitCert}',
        style: SunmiStyle(
            bold: false,
            align: SunmiPrintAlign.LEFT,
            fontSize: SunmiFontSize.MD));
    await SunmiPrinter.printText('Fecha: ${encabezado[0].fechaCert}',
        style: SunmiStyle(
            bold: false,
            align: SunmiPrintAlign.LEFT,
            fontSize: SunmiFontSize.MD));
  }

  //await SunmiPrinter.lineWrap(1);
  await SunmiPrinter.printText('Realizado en www.gozeri.com',
      style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.CENTER,
          fontSize: SunmiFontSize.MD));

  /*await SunmiPrinter.printQRCode('https://github.com/brasizza/sunmi_printer');
  await SunmiPrinter.printText('Normal font',
      style: SunmiStyle(fontSize: SunmiFontSize.MD));*/
  await SunmiPrinter.lineWrap(2);
  await SunmiPrinter.exitTransactionPrint(true);
}


print_sunmi_comanda(BuildContext context, String id_f_tmp) async {
  final print_data = Provider.of<PrintProvider>(context, listen: false);
  final js = await print_data.generate_comanda(id_f_tmp);

  showDialog(
    context: context,
    builder: (_) => const AlertDialog(
      backgroundColor: Color.fromARGB(255, 226, 178, 49),
      content: ListTile(
        leading: CircularProgressIndicator(
          color: Colors.white,
        ),
        title: Text(
          'Imprimiendo comanda...',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
  String name = '';
  if (js['ENCABEZADO']['NOMBRE_EMPRESA_SUCU'] != null ||
      js['ENCABEZADO']['NOMBRE_EMPRESA_SUCU'] != '') {
    name = js['ENCABEZADO']['NOMBRE_EMPRESA_SUCU'];
  } else {
    name = js['ENCABEZADO']['NOMBRE_EMPRESA'];
  }

  await SunmiPrinter.initPrinter();
  await SunmiPrinter.startTransactionPrint(true);
  await SunmiPrinter.lineWrap(1);
  await SunmiPrinter.lineWrap(1);
  await SunmiPrinter.printText(
      '${js['ENCABEZADO']['NOMBRE']}  ${js['ENCABEZADO']['APELLIDOS']}',
      style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.CENTER,
          fontSize: SunmiFontSize.MD));
  await SunmiPrinter.printText('#${js['ENCABEZADO']['NO']}',
      style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.CENTER,
          fontSize: SunmiFontSize.XL));
  //DETALLES
  //for (int al = 0; al < detalle.length; al++) {
  await SunmiPrinter.line();
  await SunmiPrinter.printRow(cols: [
    ColumnMaker(text: 'Cantidad', width: 15, align: SunmiPrintAlign.LEFT),
    ColumnMaker(text: 'Producto', width: 20, align: SunmiPrintAlign.LEFT),
  ]);

  await SunmiPrinter.line();
  for (int al = 0; al < js['DETALLE'].length; al++) {
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
          text: '${js['DETALLE'][al]['CANTIDAD']}',
          width: 6,
          align: SunmiPrintAlign.CENTER),
      ColumnMaker(
          text: '${js['DETALLE'][al]['PRODUCTO']}',
          width: 24,
          align: SunmiPrintAlign.LEFT),
    ]);
  }
  String ob = js['ENCABEZADO']['OBSER'];

  if (ob.length > 0) {
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('Observación:',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.LEFT,
        ));
    await SunmiPrinter.printText('${js['ENCABEZADO']['OBSER']}',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.LEFT,
        ));
  }

  await SunmiPrinter.lineWrap(1);
  await SunmiPrinter.printText('${name}',
      style: SunmiStyle(
        bold: false,
        align: SunmiPrintAlign.CENTER,
      ));
  await SunmiPrinter.printText('Realizado en www.gozeri.com',
      style: SunmiStyle(
        bold: false,
        align: SunmiPrintAlign.CENTER,
      ));
  await SunmiPrinter.lineWrap(1);
  await SunmiPrinter.line();
  /*await SunmiPrinter.printQRCode('https://github.com/brasizza/sunmi_printer');
  await SunmiPrinter.printText('Normal font',
      style: SunmiStyle(fontSize: SunmiFontSize.MD));*/
  await SunmiPrinter.lineWrap(2);
  await SunmiPrinter.exitTransactionPrint(true);
}
