import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:edge_alerts/edge_alerts.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/models/view_factura_print.dart';
import 'package:factura_gozeri/print/print_page.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/providers/impresoras_provider.dart';
import 'package:factura_gozeri/providers/print_provider.dart';
import 'package:factura_gozeri/screens/escritorio_screen.dart';
import 'package:factura_gozeri/screens/no_internet_screen.dart';
import 'package:factura_gozeri/screens/view_tabs_facturacion_screen.dart';
import 'package:factura_gozeri/widgets/itemCondicionesPago_widget.dart';
import 'package:factura_gozeri/widgets/item_observacion_widget.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:factura_gozeri/screens/view_tabs_screen.dart';
import 'package:factura_gozeri/services/auth_services.dart';
import 'package:factura_gozeri/widgets/item_dataCliente.dart';
import 'package:factura_gozeri/widgets/items_cart.dart';
import 'package:factura_gozeri/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';
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
  String condicionPagoVal;
  PrintScreen(
      {Key? key,
      required this.id_tmp,
      required this.colorPrimary,
      required this.serie,
      required this.condicionPagoVal})
      : super(key: key);

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  BluetoothManager bluetoothManager = BluetoothManager.instance;
  int open = 0;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  //SUNMIN
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  //SUNMIN
  bool state_bluetooth = false;

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
    } else {}

    super.initState();
  }

  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  //funcion impresion
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

  //funcion impresion

  @override
  void dispose() {
    // TODO: implement dispose
    _connectivitySubscription.cancel();
    super.dispose();
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
          title:
              Text('Facturación', style: TextStyle(color: widget.colorPrimary)),
          actions: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => EscritorioScreen(),
                              transitionDuration: Duration(seconds: 0)))
                      .then((value) => Navigator.of(context).pop());
                },
                icon: Icon(Icons.home),
                color: widget.colorPrimary,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: getScreenSize(context, 0.01, 0.08, 'w')),
          child: Column(
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
                        surfaceTintColor:Colors.transparent,
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
                          //print('valor de drop ' + serieProv.initialSerie);
                          var si_existe = false;
                          if (facturaService.initialSerie != '0') {
                            Preferencias.serie = facturaService.initialSerie;
                          }
                          for (var i = 0;
                              i < authService.list_serie.length;
                              i++) {
                            //print('item ' + authService.list_serie[i].idSerie);
          
                            if (!Preferencias.serie.isEmpty) {
                              if (Preferencias.serie ==
                                  authService.list_serie[i].idSerie) {
                                si_existe = true;
          
                                print('preferencia: ' +
                                    Preferencias.serie +
                                    ' id: ' +
                                    authService.list_serie[i].idSerie);
                                facturaService.serie(widget.id_tmp, 'add',
                                    authService.list_serie[i].idSerie);
                              }
                            }
          
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
                            value: (si_existe == true)
                                ? Preferencias.serie
                                : '0', //facturaService.initialSerie,
                            isExpanded: true,
                            dropdownColor: Color.fromARGB(255, 241, 238, 241),
                            onChanged: (String? newValue) async {
                              var cambio = await facturaService.serie(
                                  widget.id_tmp, 'add', newValue!);
                              Preferencias.serie = newValue;
                              if (cambio != '1') {
                                //Preferencias.serie = newValue!;
                                /*SnackBar snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  margin: const EdgeInsets.only(
                                      bottom: 100, right: 20, left: 20),
                                  padding: EdgeInsets.all(20),
                                  content: Text(
                                    '${cambio}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor:
                                      Color.fromARGB(255, 224, 96, 113),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);*/
                                edgeAlert(context,
                                    description: '${cambio}',
                                    gravity: Gravity.top,
                                    backgroundColor: Colors.redAccent);
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
                        itemCount: 6,
                        itemBuilder: ((context, index) {
                          if (index == 5) {
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
                                                              widget.id_tmp,
                                                              'tmp');
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
                            surfaceTintColor:Colors.transparent,
                            child: ExpansionTile(
                              key: Key(index.toString()),
                              shape: Border.all(color: Colors.transparent),
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
                                      : (index == 2)
                                          ? const Text('Condiciones de Pago')
                                          : (index == 3)
                                              ? const Text('Detalle de Pago')
                                              : const Text('Observaciones'),
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
                                            ? ItemCondicionesPago(
                                                colorPrimary: widget.colorPrimary,
                                                id: widget.id_tmp,
                                                tmp: 'tmp',
                                              )
                                            : (index == 3)
                                                ? RegistroMetodoPago(
                                                    colorPrimary:
                                                        widget.colorPrimary,
                                                    id_tmp: widget.id_tmp,
                                                    estado: 'tmp',
                                                  )
                                                : ItemObservacion(
                                                    colorPrimary:
                                                        widget.colorPrimary,
                                                    id: widget.id_tmp,
                                                    tmp: 'tmp',
                                                  ),
                                Row(
                                  mainAxisAlignment: (index == 0)
                                      ? MainAxisAlignment.spaceBetween
                                      : MainAxisAlignment.end,
                                  children: [
                                    (index == 0)
                                        ? Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 15),
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
                                                      builder: (context) =>
                                                          ViewTabsScreen(
                                                              colorPrimary: widget
                                                                  .colorPrimary,
                                                              id_tmp:
                                                                  widget.id_tmp,
                                                              clave: '2321'),
                                                    ),
                                                  );
                                                },
                                                style: TextButton.styleFrom(
                                                    primary: Colors.white,
                                                    backgroundColor:
                                                        Colors.green),
                                                icon: const Text(
                                                    "Agregar Articulos")),
                                          )
                                        : Text(''),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: (index == 4)
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
                                                  } else if (index == 2) {
                                                    open = 3;
                                                  } else if (index == 3) {
                                                    open = 4;
                                                  } else {
                                                    open = 1;
                                                  }
                                                });
                                                print(open);
                                              },
                                              style: TextButton.styleFrom(
                                                  primary: Colors.white,
                                                  backgroundColor:
                                                      widget.colorPrimary),
                                              icon: const Text("Continuar")),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                      ))),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    /*Text("Total: ${f.format(_total)}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(
                      width: 80,
                    ),*/
                    Expanded(
                        flex: 2,
                        child: TextButton.icon(
                          onPressed: () async {
                            if (facturaService.list_det.length < 1) {
                              //no tiene articulos la factyura
                              edgeAlert(context,
                                  description:
                                      'Error: Agrega articulos a la factura',
                                  gravity: Gravity.top,
                                  backgroundColor: Colors.redAccent);
                            } else if (facturaService.initialSerie == '0') {
                              //no se agrego serie a facturar
                              edgeAlert(context,
                                  description: 'Error: Seleccióna una serie',
                                  gravity: Gravity.top,
                                  backgroundColor: Colors.redAccent);
                            } else if (facturaService.id == '') {
                              //no tiene cliente agregado la factura
                              edgeAlert(context,
                                  description: 'Error: Seleccióne un cliente',
                                  gravity: Gravity.top,
                                  backgroundColor: Colors.redAccent);
                            } /*else if (double.parse(facturaService.saldo) >=
                                double.parse(facturaService.total_fac)) {
                              //no se aplico el pago
                              edgeAlert(context,
                                  description: 'Error: Aplicar pago',
                                  gravity: Gravity.top,
                                  backgroundColor: Colors.redAccent);
                            }*/
                            else {
                              //FACTURANDO
                              var facturar =
                                  await facturaService.facturar(widget.id_tmp);
                              var js = json.decode(facturar);
          
                              if (js['MENSAJE'] == 'OK') {
                                //si se facturo
                                edgeAlert(context,
                                    description: 'Factura Realizada',
                                    gravity: Gravity.top,
                                    backgroundColor:
                                        Color.fromARGB(255, 81, 131, 83));
          
                                if (Preferencias.printfactura == false) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      backgroundColor:
                                          Color.fromARGB(255, 109, 224, 186),
                                      content: Text(
                                        'Listo...',
                                        style:
                                            const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
          
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const EscritorioScreen()),
                                      (Route<dynamic> route) => false);
                                } else {
                                  //imprimir factura
                                  if (Preferencias.sunmi_preferencia) {
                                    //impresion sunmi
                                    await print_sunmi(context, js['ID']);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const EscritorioScreen()),
                                        (Route<dynamic> route) => false);
                                  } else {
                                    //impresion bluetooth
                                    //PRINT NO SUNMIN
                                    if (state_bluetooth == true) {
                                      //escaneo
                                      bt_initPrinter('f', js['ID']);
                                      //escaneo
                                    } else {
                                      print('off');
                                      showDialog(
                                        context: context,
                                        builder: (_) => const AlertDialog(
                                          backgroundColor:
                                              Color.fromARGB(255, 224, 140, 31),
                                          content: Text(
                                            'Bluetooth sin Conexión',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      );
                                    }
                                    //PRINT NO SUNMIN
                                    print('salio');
                                  }
                                }
                                // ignore: use_build_context_synchronously
                              } else {
                                /*SnackBar snackBar = SnackBar(
                              padding: const EdgeInsets.all(20),
                              dismissDirection: DismissDirection.up,
                              content: Text(
                                '${facturar}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 224, 96, 113),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                                edgeAlert(context,
                                    title: '${facturar}',
                                    gravity: Gravity.top,
                                    backgroundColor: Colors.redAccent);
                                print(facturar);
                              }
                            }
                          },
                          icon: const Icon(Icons.print),
                          label: const Text('Facturar'),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.green,
                          ),
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton.icon(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () async {
                            if (Preferencias.sunmi_preferencia) {
                              await print_sunmi_comanda(context, widget.id_tmp);
                            } else {
                              //PRINT NO SUNMIN
                              if (state_bluetooth == true) {
                                //escaneo
                                bt_initPrinter('comanda', widget.id_tmp);
                                //escaneo
                              } else {
                                print('off');
                                showDialog(
                                  context: context,
                                  builder: (_) => const AlertDialog(
                                    backgroundColor:
                                        Color.fromARGB(255, 224, 140, 31),
                                    content: Text(
                                      'Bluetooth sin Conexión',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }
                              //PRINT NO SUNMIN
                            }
                          },
                          icon: Icon(
                            Icons.newspaper,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Comanda',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
    print('esta es la accion ' + accion);
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
            ? Color.fromARGB(255, 109, 224, 186)
            : Color.fromARGB(255, 201, 124, 124),
        content: Text(
          (result.msg == 'Success') ? 'Listo..' : result.msg,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
    Navigator.of(context, rootNavigator: true).pop(result);
    if (accion == 'f') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const EscritorioScreen()),
          (Route<dynamic> route) => false);
    }
  }

  Future<List<int>> comanda_bluetho(String id_factura) async {
    final print_data = Provider.of<PrintProvider>(context, listen: false);
    final js = await print_data.generate_comanda(id_factura);
    print(js);
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
      ));

  //Direccion de empresa
  await SunmiPrinter.printText(
      (sede == 1)
          ? '${encabezado[0].direccionSucu}'
          : '${encabezado[0].direccion}',
      style: SunmiStyle(
        bold: true,
        align: SunmiPrintAlign.CENTER,
      ));

  //nit emisor
  if (encabezado[0].nit_emisor != '') {
    await SunmiPrinter.printText('NIT: ${encabezado[0].nit_emisor}',
        style: SunmiStyle(
          bold: true,
          align: SunmiPrintAlign.CENTER,
        ));
  }

  //telefono emisor
  if (sede == 1) {
    if (encabezado[0].teleSucu != '') {
      await SunmiPrinter.printText('Tel: ${encabezado[0].teleSucu}',
          style: SunmiStyle(
            bold: true,
            align: SunmiPrintAlign.CENTER,
          ));
    }
  } else {
    if (encabezado[0].telefono != '') {
      await SunmiPrinter.printText('Tel: ${encabezado[0].telefono}',
          style: SunmiStyle(
            bold: true,
            align: SunmiPrintAlign.CENTER,
          ));
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
          ));
    }
  } else {
    if (encabezado[0].nombre_comercial_emp != '') {
      await SunmiPrinter.printText('${encabezado[0].nombre_comercial_emp}',
          style: SunmiStyle(
            bold: true,
            align: SunmiPrintAlign.CENTER,
          ));
    }
  }

  //await SunmiPrinter.lineWrap(1);
  //FEL
  if (encabezado[0].dte != '') {
    await SunmiPrinter.printText('Factura Electrónica Documento Tributario',
        style: SunmiStyle(
          bold: true,
          align: SunmiPrintAlign.CENTER,
        ));
  }

  //await SunmiPrinter.lineWrap(1);

  //FECHA EN LETRAS
  await SunmiPrinter.printText('${encabezado[0].fecha_letras}',
      style: SunmiStyle(
        bold: false,
        align: SunmiPrintAlign.RIGHT,
      ));

  //await SunmiPrinter.lineWrap(1);

  if (encabezado[0].dte != '') {
    await SunmiPrinter.printText('Número de Autorización:',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.CENTER,
        ));
    await SunmiPrinter.printText('${encabezado[0].dte}',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.CENTER,
        ));
    await SunmiPrinter.printText('Serie: ${encabezado[0].serieDte}',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.CENTER,
        ));
    await SunmiPrinter.printText('Número de DTE: ${encabezado[0].noDte}',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.CENTER,
        ));
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
      ));

  //await SunmiPrinter.lineWrap(1);

  //serie
  await SunmiPrinter.printText('Serie: ${encabezado[0].serie}',
      style: SunmiStyle(
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ));

  //vendedor
  await SunmiPrinter.printText(
      'Vendedor : ${encabezado[0].nombreV} ${encabezado[0].apellidosV}',
      style: SunmiStyle(
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ));
  //cliente
  await SunmiPrinter.printText(
      'Cliente: ${encabezado[0].nombre} ${encabezado[0].apellidos}',
      style: SunmiStyle(
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ));
  //nit cliente
  await SunmiPrinter.printText('NIT: ${encabezado[0].nit}',
      style: SunmiStyle(
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ));

  //direccion cliente
  if (encabezado[0].direccionCli != '') {
    await SunmiPrinter.printText('Dirección: ${encabezado[0].direccionCli}',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.LEFT,
        ));
  }

  await SunmiPrinter.lineWrap(1);

  //condiciones de pago
  await SunmiPrinter.printText('Condiciones de pago:',
      style: SunmiStyle(
        bold: true,
        align: SunmiPrintAlign.CENTER,
      ));
  //forma
  await SunmiPrinter.printText('${encabezado[0].forma}',
      style: SunmiStyle(
        bold: true,
        align: SunmiPrintAlign.CENTER,
      ));

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
      ));

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
        ));
  }

  //datos certificador
  if (encabezado[0].dte != '') {
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('Certificador: ${encabezado[0].certificador}',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.LEFT,
        ));
    await SunmiPrinter.printText('NIT: ${encabezado[0].nitCert}',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.LEFT,
        ));
    await SunmiPrinter.printText('Fecha: ${encabezado[0].fechaCert}',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.LEFT,
        ));
  }

  //await SunmiPrinter.lineWrap(1);
  await SunmiPrinter.printText('Realizado en www.gozeri.com',
      style: SunmiStyle(
        bold: false,
        align: SunmiPrintAlign.CENTER,
      ));

  /*await SunmiPrinter.printQRCode('https://github.com/brasizza/sunmi_printer');
  await SunmiPrinter.printText('Normal font',
      style: SunmiStyle(fontSize: SunmiFontSize.MD));*/
  await SunmiPrinter.lineWrap(2);

  await SunmiPrinter.drawerStatus(); //check if the cash drawer is connect or disconnect

  await SunmiPrinter.openDrawer(); //open de cash drawer

  await SunmiPrinter.drawerTimesOpen();
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
  
  /*await SunmiPrinter.drawerStatus(); //check if the cash drawer is connect or disconnect

  await SunmiPrinter.openDrawer(); //open de cash drawer

  await SunmiPrinter.drawerTimesOpen();*/
}
