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

    //final departamentoService = Provider.of<DepartamentoService>(context);



    

    /*if (departamentoService.isLoading)
      return LoadingScreen(
        colorPrimary: widget.colorPrimary,
      );*/

    return Consumer<DepartamentoService>(builder: (context, departamentoService, child){
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
                width: size.width * 0.25,
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
                    return Badge(
                      showBadge: (cart.count == 0) ? false : true,
                      badgeContent: Text(
                        '${cart.count}',
                        style: TextStyle(color: Colors.white),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          final _facturacion =Provider.of<Facturacion>(context, listen: false);

                          _facturacion.list_cart(widget.id_tmp);

                          _facturacion.read_cliente('read', '0', widget.id_tmp);

                          _facturacion.serie(widget.id_tmp, 'read', '');

                          _facturacion.transacciones(widget.id_tmp);

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
          ),
        );
      });
  }
}
