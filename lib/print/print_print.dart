import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/print/print_page.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/providers/print_provider.dart';
import 'package:factura_gozeri/screens/escritorio_screen.dart';
import 'package:factura_gozeri/screens/no_internet_screen.dart';
import 'package:factura_gozeri/screens/view_tabs_facturacion_screen.dart';
import 'package:factura_gozeri/services/auth_services.dart';
import 'package:factura_gozeri/widgets/item_dataCliente.dart';
import 'package:factura_gozeri/widgets/items_cart.dart';
import 'package:factura_gozeri/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:intl/intl.dart';

/*ListView.builder(
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
      }),
)*/

class PrintScreen extends StatefulWidget {
  String id_tmp;
  Color colorPrimary;
  String serie;
  PrintScreen(
      {Key? key,
      required this.id_tmp,
      required this.colorPrimary,
      required this.serie})
      : super(key: key);

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  int open = 0;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> initialActivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    initialActivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _printerManager.startScan(Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int _total = 0;
    List<DropdownMenuItem<String>> menuItems = [];

    print('conexion :' + _connectionStatus.name);
    if (_connectionStatus.name != 'wifi' &&
        _connectionStatus.name != 'mobile') {
      return const NoInternet();
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    final facturaService = Provider.of<Facturacion>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        _printerManager.stopScan();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            elevation: 2,
            foregroundColor: widget.colorPrimary,
            backgroundColor: Colors.white,
            title: Text('Facturación',
                style: TextStyle(color: widget.colorPrimary))),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30, right: 10, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Serie: ",
                    style: TextStyle(
                        color: widget.colorPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Card(
                        child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Consumer<Facturacion>(
                          builder: ((context, serieProv, child) {
                        List<DropdownMenuItem<String>> menuItems = [];

                        menuItems.add(const DropdownMenuItem(
                            value: '0',
                            child: Text(
                              'Selecciona una serie',
                              textAlign: TextAlign.center,
                            )));
                        print('valor de drop ' + serieProv.initialSerie);

                        for (var i = 0;
                            i < authService.list_serie.length;
                            i++) {
                          print('item ' + authService.list_serie[i].idSerie);

                          menuItems.add(DropdownMenuItem(
                              value: authService.list_serie[i].idSerie,
                              child: Text(
                                authService.list_serie[i].nombre,
                                textAlign: TextAlign.center,
                              )));
                        }

                        if (serieProv.cargainiSerie == true) {
                          return Center(
                              child: LinearProgressIndicator(
                            color: widget.colorPrimary,
                            backgroundColor: Colors.white,
                          ));
                        }

                        return DropdownButton(
                          itemHeight: null,
                          value: facturaService
                              .initialSerie, //facturaService.initialSerie,
                          isExpanded: true,
                          dropdownColor: Color.fromARGB(255, 241, 238, 241),
                          onChanged: (String? newValue) async {
                            var cambio = await facturaService.serie(
                                widget.id_tmp, 'add', newValue!);
                            if (cambio != '1') {
                              //Preferencias.serie = newValue!;
                              SnackBar snackBar = SnackBar(
                                padding: EdgeInsets.all(20),
                                content: Text(
                                  '${cambio}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 224, 96, 113),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              facturaService.initialSerie = newValue;
                              setState(() {});
                            }
                          },
                          items: menuItems,
                          elevation: 0,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          //icon: Icon(Icons.arrow_drop_down),
                          iconDisabledColor: Colors.red,
                          iconEnabledColor: widget.colorPrimary,
                          underline: SizedBox(),
                        );
                      })),
                    )),
                  )
                ],
              ),
            ),
            Expanded(
                child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                      key: Key('builder ${open.toString()}'),
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: ((context, index) {
                        if (index == 3) {
                          return Consumer<Facturacion>(
                              builder: (context, fact, child) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 2,
                                      style: BorderStyle.solid,
                                      color:
                                          Color.fromARGB(255, 199, 193, 197)),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(children: [
                                (fact.loadTransaccion)
                                    ? Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        padding: const EdgeInsets.all(0),
                                        child: Center(
                                          child: LinearProgressIndicator(
                                            color: widget.colorPrimary,
                                            backgroundColor: Colors.white,
                                          ),
                                        ))
                                    : ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: fact.list_transaccion.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            leading: IconButton(
                                                onPressed: () async {
                                                  final dele = await facturaService
                                                      .delete_transaccion(
                                                          widget.id_tmp,
                                                          fact
                                                              .list_transaccion[
                                                                  index]
                                                              .idTrans);
                                                  if (dele.toString() == 'OK') {
                                                    facturaService
                                                        .transacciones(
                                                            widget.id_tmp);
                                                  } else {
                                                    print('error');
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  color: widget.colorPrimary,
                                                )),
                                            title: Text(fact
                                                .list_transaccion[index].forma),
                                            trailing: Text(Preferencias.moneda +
                                                fact.list_transaccion[index]
                                                    .abono),
                                          );
                                        },
                                      ),
                                ListTile(
                                  title: const Text(
                                    'Total: ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing: Text(
                                    Preferencias.moneda + fact.total_fac,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    (double.parse(fact.saldo) < 0)
                                        ? 'Cambio: '
                                        : 'Saldo: ',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing: Text(
                                    (double.parse(fact.saldo) < 0)
                                        ? '${Preferencias.moneda}${double.parse(fact.saldo) * (-1)}'
                                        : Preferencias.moneda + fact.saldo,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ]),
                            );
                          });
                        }
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.all(10),
                          child: ExpansionTile(
                            key: Key(index.toString()),
                            initiallyExpanded: open == index,
                            leading: CircleAvatar(
                              backgroundColor: widget.colorPrimary,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                            childrenPadding: const EdgeInsets.all(5),
                            title: (index == 0)
                                ? const Text('Detalle del Pedido')
                                : (index == 1)
                                    ? const Text('Datos de Cliente')
                                    : const Text('Detalle de Pago'),
                            children: [
                              (index == 0)
                                  ? ItemsCart(
                                      id_tmp: widget.id_tmp,
                                      colorPrimary: widget.colorPrimary,
                                    )
                                  : (index == 1)
                                      ? ItemCliente(
                                          colorPrimary: widget.colorPrimary,
                                          tmp: widget.id_tmp)
                                      : (index == 2)
                                          ? RegistroMetodoPago(
                                              colorPrimary: widget.colorPrimary,
                                              id_tmp: widget.id_tmp)
                                          : const Text(''),
                              Container(
                                alignment: Alignment.centerRight,
                                child: (index == 2)
                                    ? const Text('')
                                    : ElevatedButton.icon(
                                        label: const Icon(
                                          Icons.arrow_forward,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (index == 0) {
                                              open = 1;
                                            } else if (index == 1) {
                                              open = 2;
                                            } else {
                                              //open = 0;
                                            }
                                          });
                                          print(open);
                                        },
                                        style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor:
                                                widget.colorPrimary),
                                        icon: const Text("Continuar")),
                              )
                            ],
                          ),
                        );
                      }),
                    ))),
            Container(
              color: Color.fromARGB(255, 233, 233, 233),
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  /*Text("Total: ${f.format(_total)}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: 80,
                  ),*/
                  Expanded(
                      child: TextButton.icon(
                    onPressed: () async {
                      /*final storage = new FlutterSecureStorage();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();*/
                      //dynamic device_store=await storage.read(key: 'IMPRESORA');
                      //final dynamic din = await Preferencias.impresora as dynamic;
                      //PrinterBluetooth device = await Preferencias.impresora as dynamic;
                      print('entro');
                      _printerManager.stopScan();
                      _printerManager.scanResults.listen((devices) async {
                        print(devices);
                        devices.forEach((printer) async {
                          //print(printer);
                          //get saved printer
                          if (printer.address == Preferencias.mac) {
                            //store the element.
                            await _startPrint(printer);
                          }
                        });
                      });
                      print('salio');
                      //print('el deivis : ' + device['name']);

                      /*var facturar = await facturaService.facturar(widget.id_tmp);
                      var js = json.decode(facturar);
                      if (js['MENSAJE'] == 'OK') {
                        /*SnackBar snackBar = const SnackBar(
                          padding: EdgeInsets.all(20),
                          content: Text(
                            'Facturacion Completada',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
    
    
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const EscritorioScreen()));
                      } else {
                        SnackBar snackBar = SnackBar(
                          padding: const EdgeInsets.all(20),
                          content: Text(
                            '${facturar}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 224, 96, 113),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        print(facturar);
                      }*/
                    },
                    icon: const Icon(Icons.print),
                    label: const Text('Facturar'),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
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
            ? Color.fromARGB(255, 109, 224, 186)
            : Color.fromARGB(255, 201, 124, 124),
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
