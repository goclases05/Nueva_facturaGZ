import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:edge_alerts/edge_alerts.dart';
import 'package:factura_gozeri/print/impresoras_print.dart';
import 'package:factura_gozeri/providers/carshop_provider.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/providers/seattings_provider.dart';
import 'package:factura_gozeri/screens/no_internet_screen.dart';
import 'package:factura_gozeri/screens/screens.dart';
import 'package:factura_gozeri/services/auth_services.dart';
import 'package:factura_gozeri/services/departamentos_services.dart';
import 'package:factura_gozeri/widgets/drawer_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EscritorioScreen extends StatefulWidget {
  const EscritorioScreen({Key? key}) : super(key: key);

  @override
  State<EscritorioScreen> createState() => _EscritorioScreenState();
}

class _EscritorioScreenState extends State<EscritorioScreen> {
  int currentPage = 1;

  ConnectivityResult _connectionStatus = ConnectivityResult.wifi;
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
    super.initState();
    initialActivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print('conexion :' + _connectionStatus.name);
    if (_connectionStatus.name != 'wifi' &&
        _connectionStatus.name != 'mobile') {
      return NoInternet();
    }
    Size size = MediaQuery.of(context).size;
    final settings = Provider.of<settingsProvider>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    Color colorPrimary = settings.colorPrimary;
    Color colorSecundario = const Color.fromRGBO(242, 242, 247, 1);

    return WillPopScope(
      onWillPop: () => _onback(context),
      child: Scaffold(
          appBar: AppBar(
              foregroundColor: colorPrimary,
              title: Image.asset(
                'assets/gozeri_blanco2.png',
                color: colorPrimary,
                width: size.width * 0.25,
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                CircleAvatar(
                  backgroundColor: const Color.fromRGBO(242, 242, 247, 1),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImpresorasPrint(id_tmp: ''),
                          ));
                    },
                    icon: Icon(Icons.print),
                    color: colorPrimary,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                    backgroundColor: const Color.fromRGBO(242, 242, 247, 1),
                    child: PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: colorPrimary,
                        ),
                        // Callback that sets the selected popup menu item.
                        onSelected: (value) {
                          if (value == 'exit') {
                            authService.logout();
                            Navigator.pushReplacementNamed(context, 'checking');
                          } else if (value == 'settings') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                              const PopupMenuItem(
                                value: "settings",
                                child: ListTile(
                                  title: Text("Ajustes"),
                                  trailing: Icon(
                                    Icons.settings,
                                  ),
                                ),
                              ),
                              const PopupMenuItem(
                                value: "exit",
                                child: ListTile(
                                  title: Text("Cerrar Sesión"),
                                  trailing: Icon(
                                    Icons.logout,
                                  ),
                                ),
                              )
                            ])),
                const SizedBox(
                  width: 20,
                ),
              ]),
          drawer: Drawer(
            backgroundColor: const Color.fromRGBO(241, 242, 247, 1),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    HeaderDrawer(
                      colorPrimary: colorPrimary,
                      cont: context,
                    ),
                    MyDrawerList(context, colorPrimary)
                  ],
                ),
              ),
            ),
          ),
          body: (currentPage == 1)
              ? TabsFacturacion(colorPrimary: colorPrimary)
              : Text(currentPage.toString())),
    );
  }
}

Widget MyDrawerList(BuildContext context, Color colo) {
  return Container(
    padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        menuItem(1, "Historial de Facturas", Icons.app_registration, true,
            context, colo),
        const SizedBox(
          height: 5,
        ),
        menuItem(0, "Facturar", Icons.receipt_long, false, context, colo),
      ],
    ),
  );
}

Widget menuItem(int id, String title, IconData icon, bool selected,
    BuildContext context, Color colo) {
  return Material(
    color: selected ? colo.withOpacity(0.2) : Colors.transparent,
    borderRadius: BorderRadius.circular(10),
    child: InkWell(
      radius: 100,
      onTap: () async {
        if (id == 0) {
          final _facturacion = Provider.of<Facturacion>(context, listen: false);
          final factuProv = await _facturacion.new_tmpFactura();
          print('factura no: ${factuProv[0]}');
          print('clave : ${factuProv[1]}');

          final _cart = Provider.of<Cart>(context, listen: false);
          _cart.cantidad = 0;

          final _depa =
              Provider.of<DepartamentoService>(context, listen: false);
          _depa.isLoading = true;
          _depa.LoadDepa();

          if (_facturacion.tmp_creada == '') {
            print('tap tap 5');
            edgeAlert(context,
                title: 'Error!',
                description: 'Fallo al crear la factura temporal.',
                gravity: Gravity.top,
                backgroundColor: Colors.redAccent);
            /*var snackBar = SnackBar(
              /// need to set following properties for best effect of awesome_snackbar_content
              duration: const Duration(seconds: 1),
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Error!',
                message: 'Fallo al crear la factura temporal.',

                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                contentType: ContentType.failure,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
          } else {
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewTabsScreen(
                    colorPrimary: colo,
                    id_tmp: factuProv[0],
                    clave: factuProv[1]),
              ),
            );
          }
        } else {
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Icon(
                icon,
                size: 20,
                color: Colors.black,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Future<bool> _onback(BuildContext context) async {
  bool? exitApp = await showDialog(
    context: context,
    builder: ((context) {
      return AlertDialog(
        title: const Text('¿Quieres salir de la Aplicación?',
            style: TextStyle(
              fontSize: 15,
            )),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Si'))
        ],
      );
    }),
  );

  return exitApp ?? false;
}
