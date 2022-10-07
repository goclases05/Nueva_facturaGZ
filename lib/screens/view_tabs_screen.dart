import 'package:factura_gozeri/print/print_print.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/search/items_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool facturar_check = false;
    final departamentoService = Provider.of<DepartamentoService>(context);
    List<String> data = [];
    List<String> data_id = [];
    int initPosition = 0;

    if (departamentoService.isLoading)
      return LoadingScreen(
        colorPrimary: widget.colorPrimary,
      );

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

      _views.add(ViewProductoTab(
          id_departamento: departamentoService.depa[i].id,
          id_tmp: widget.id_tmp,
          colPrimary: widget.colorPrimary));
    }

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: widget.colorPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Image.asset(
            'assets/gozeri_blanco2.png',
            width: size.width * 0.25,
          ),
          actions: [
            const SizedBox(
              width: 15,
            ),
            CircleAvatar(
              backgroundColor: Colors.white38,
              child: IconButton(
                onPressed: () {
                  ItemsSearch.id_tmp = widget.id_tmp;
                  showSearch(context: context, delegate: ItemsSearch());
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            CircleAvatar(
              backgroundColor: Colors.white38,
              child: Consumer<Cart>(builder: (context, cart, child) {
                return Badge(
                  showBadge: (cart.count == 0) ? false : true,
                  badgeContent: Text(
                    '${cart.count}',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final _facturacion =
                          Provider.of<Facturacion>(context, listen: false);
                      await _facturacion.list_cart(widget.id_tmp);
                      await _facturacion.read_cliente(
                          'read', '0', widget.id_tmp);
                      await _facturacion.serie(widget.id_tmp, 'read', '');

                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PrintScreen(
                                    id_tmp: widget.id_tmp,
                                    colorPrimary: widget.colorPrimary,
                                    serie: _facturacion.initialSerie,
                                  )));
                    },
                    icon: const Icon(
                      Icons.receipt_long,
                      color: Colors.white,
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
            labelColor: Colors.white,
            unselectedLabelColor: Color.fromARGB(255, 219, 219, 219),
            isScrollable: true,
            tabs: _tabs,
          ),
        ),
        body: TabBarView(
          children: _views,
        ),
      ),
    );
  }
}
