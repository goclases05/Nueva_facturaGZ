import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabsFacturacion extends StatelessWidget {
  TabsFacturacion({Key? key, required this.colorPrimary}) : super(key: key);
  Color colorPrimary;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Color colorSecundario=const Color.fromRGBO(242, 242, 247, 1);

    List<Tab> _tabs = [];
    List<Widget> _views = [];

    _tabs = const [
      Tab(
        text: 'Emitidas',
      ),
      Tab(
        text: 'Pendientes',
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
              backgroundColor: colorPrimary.withOpacity(0.1),
              elevation: 0,
              title: TabBar(
                labelColor: colorPrimary,
                indicatorColor: colorPrimary,
                unselectedLabelColor: Color.fromARGB(255, 206, 198, 198),
                isScrollable: false,
                labelStyle:const TextStyle(
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
            final _facturacion =
                Provider.of<Facturacion>(context, listen: false);
            final factuProv = await _facturacion.new_tmpFactura();
            print('factura no: ${factuProv[0]}');
            print('clave : ${factuProv[1]}');

            _facturacion.new_tmpFactura();

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
          icon:const Icon(
            Icons.add,
            color: Colors.white,
          ),
          label:const Text(
            'NUEVA FACTURA',
            style: TextStyle(color: Colors.white),
          ),
        ), 
      )
    ]);
  }
}
