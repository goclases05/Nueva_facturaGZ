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
              foregroundColor: Colors.white,
              title: Text('Historial de Facturas'),
              backgroundColor: this.colorPrimary,
              elevation: 0,
              actions: [
                /*CircleAvatar(
                    backgroundColor: Colors.white38,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.print),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),*/
                CircleAvatar(
                    backgroundColor: Colors.white38,
                    child: PopupMenuButton(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        // Callback that sets the selected popup menu item.
                        onSelected: (value) {},
                        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                              const PopupMenuItem(
                                value: "Escritorio",
                                child: ListTile(
                                  title: Text("Menu Principal"),
                                  trailing: Icon(
                                    Icons.home,
                                  ),
                                ),
                              ),
                              const PopupMenuItem(
                                value: "settings",
                                child: ListTile(
                                  title: Text("Ajustes"),
                                  trailing: Icon(
                                    Icons.settings,
                                  ),
                                ),
                              )
                            ])),
                const SizedBox(
                  width: 20,
                ),
              ],
              bottom: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Color.fromARGB(255, 219, 219, 219),
                isScrollable: false,
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
        child: FloatingActionButton(
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
          elevation: 50.0,
          backgroundColor: this.colorPrimary,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      )
    ]);
  }
}
