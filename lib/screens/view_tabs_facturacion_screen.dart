import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:factura_gozeri/providers/carshop_provider.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/screens/screens.dart';
import 'package:factura_gozeri/services/departamentos_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabsFacturacion extends StatelessWidget {
  TabsFacturacion({Key? key, required this.colorPrimary}) : super(key: key);
  Color colorPrimary;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Color colorSecundario = const Color.fromRGBO(242, 242, 247, 1);

    List<Tab> _tabs = [];
    List<Widget> _views = [];

    _tabs = const [
      Tab(
        text: '  Emitidas  ',
      ),
      Tab(
        text: '  Pendientes  ',
      )
    ];

    _views = [
      ViewFacturas(
        colorPrimary: colorPrimary,
        accion: 'Emitidas',
      ),
      ViewFacturas(
        colorPrimary: colorPrimary,
        accion: 'Pendientes',
      )
    ];

    return Stack(children: [
      DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 2,
              title: TabBar(
                labelColor: colorPrimary,
                indicatorColor: colorPrimary,
                //indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelColor: Color.fromARGB(255, 206, 198, 198),
                isScrollable: false,
                labelStyle: const TextStyle(
                  fontSize: 18,
                ),
                tabs: _tabs,
              ),
            ),
            body: TabBarView(
              children: _views,
            )),
      ),
      Positioned(
        bottom: 30,
        right: 30,
        child: FloatingActionButton.extended(
          backgroundColor: colorPrimary,
          elevation: 5,
          onPressed: () async {
            final _depa =Provider.of<DepartamentoService>(context, listen: false);
            _depa.isLoading = true;
            _depa.LoadDepa();

            final _cart = Provider.of<Cart>(context, listen: false);
            _cart.cantidad = 0;

            final _facturacion =Provider.of<Facturacion>(context, listen: false);
            final factuProv = await _facturacion.new_tmpFactura();
            
            if (_facturacion.tmp_creada == '') {
              var snackBar = SnackBar(
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
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewTabsScreen(
                      colorPrimary: colorPrimary,
                      id_tmp: factuProv[0],
                      clave: factuProv[1]),
                ),
              );
            }
          },
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          label: const Text(
            'NUEVA FACTURA',
            style: TextStyle(color: Colors.white),
          ),
        ),
      )
    ]);
  }
}
