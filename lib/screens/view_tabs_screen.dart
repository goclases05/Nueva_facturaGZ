import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:factura_gozeri/print/print_print.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/screens/no_internet_screen.dart';
import 'package:factura_gozeri/search/items_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:factura_gozeri/providers/carshop_provider.dart';
import 'package:factura_gozeri/screens/screens.dart';
import 'package:factura_gozeri/services/services.dart';

class ViewTabsScreen extends StatefulWidget {
  ViewTabsScreen(
      {Key? key,
      required this.id_tmp,
      required this.clave,
      required this.colorPrimary})
      : super(key: key);
  final id_tmp;
  final clave;
  Color colorPrimary;
  @override
  State<ViewTabsScreen> createState() => _ViewTabsScreen();
}

class _ViewTabsScreen extends State<ViewTabsScreen> {
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
    var size = MediaQuery.of(context).size;
    print('conexion :' + _connectionStatus.name);
    if (_connectionStatus.name != 'wifi' &&
        _connectionStatus.name != 'mobile') {
      return const NoInternet();
    }

    //final departamentoService = Provider.of<DepartamentoService>(context);

    /*if (departamentoService.isLoading)
      return LoadingScreen(
        colorPrimary: widget.colorPrimary,
      );*/

    return Consumer<DepartamentoService>(
        builder: (context, departamentoService, child) {
      List<String> data = [];
      List<String> data_id = [];
      int initPosition = 0;

      List<Tab> _tabs = [];
      List<Widget> _views = [];

      for (int i = 0; i < departamentoService.depa.length; i++) {
        data.add(departamentoService.depa[i].departamento);
        data_id.add(departamentoService.depa[i].id);

        _tabs.add(
          Tab(
            text: departamentoService.depa[i].departamento,
          ),
        );
        print('la tmp tab: ' + widget.id_tmp);
        _views.add(ViewProductoTab(
            id_departamento: departamentoService.depa[i].id,
            id_tmp: widget.id_tmp,
            colPrimary: widget.colorPrimary));
      }

      if (departamentoService.isLoading)
        return LoadingScreen(
          colorPrimary: widget.colorPrimary,
        );

      return DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: widget.colorPrimary,
              elevation: 2,
              title: Image.asset(
                'assets/gozeri_blanco2.png',
                color: widget.colorPrimary,
                height: getScreenSize(context, 0.05,0.08,'h'),
              ),
              actions: [
                const SizedBox(
                  width: 15,
                ),
                CircleAvatar(
                  backgroundColor: const Color.fromRGBO(242, 242, 247, 1),
                  child: IconButton(
                    onPressed: () {
                      ItemsSearch.id_tmp = widget.id_tmp;
                      showSearch(context: context, delegate: ItemsSearch());
                    },
                    icon: Icon(
                      Icons.search,
                      color: widget.colorPrimary,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                CircleAvatar(
                  backgroundColor: const Color.fromRGBO(242, 242, 247, 1),
                  child: Consumer<Cart>(builder: (context, cart, child) {
                    return badges.Badge(
                      showBadge: (cart.count == 0) ? false : true,
                      badgeContent: Text(
                        '${cart.count}',
                        style: TextStyle(color: Colors.white),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          final _facturacion =
                              Provider.of<Facturacion>(context, listen: false);

                          _facturacion.list_cart(widget.id_tmp);

                          _facturacion.read_cliente('read', '0', widget.id_tmp);

                          _facturacion.serie(widget.id_tmp, 'read', '');

                          _facturacion.transacciones(widget.id_tmp, 'tmp');

                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PrintScreen(
                                        id_tmp: widget.id_tmp,
                                        colorPrimary: widget.colorPrimary,
                                        serie: _facturacion.initialSerie,
                                        condicionPagoVal: '0',
                                      )));
                        },
                        icon: Icon(
                          Icons.receipt_long,
                          color: widget.colorPrimary,
                        ),
                      ),
                    );
                    return Text(
                      '${cart.count}',
                      style: TextStyle(color: Colors.white),
                    );
                  }),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
              bottom: TabBar(
                labelColor: widget.colorPrimary,
                indicatorColor: widget.colorPrimary,
                unselectedLabelColor: const Color.fromARGB(255, 200, 194, 194),
                isScrollable: true,
                tabs: _tabs,
              ),
            ),
            body: TabBarView(
              children: _views,
            ),
            bottomSheet: Row(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: TextButton.icon(
                    onPressed: () async {
                      final _facturacion =
                          Provider.of<Facturacion>(context, listen: false);
                      _facturacion.list_cart(widget.id_tmp);
                      _facturacion.read_cliente('read', '0', widget.id_tmp);
                      _facturacion.serie(widget.id_tmp, 'read', '');
                      _facturacion.transacciones(widget.id_tmp, 'tmp');

                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PrintScreen(
                                    id_tmp: widget.id_tmp,
                                    colorPrimary: widget.colorPrimary,
                                    serie: _facturacion.initialSerie,
                                    condicionPagoVal: '0',
                                  )));
                    },
                    icon: const Icon(Icons.receipt_long),
                    label: const Text('Ver Detalles  ➔'),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
            ])),
      );
    });
  }
}
