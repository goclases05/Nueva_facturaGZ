import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/providers/carshop_provider.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/screens/screens.dart';
import 'package:factura_gozeri/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context, listen: false);
    final _depa = Provider.of<DepartamentoService>(context, listen: false);
    final _cart = Provider.of<Cart>(context, listen: false);
    String name = Preferencias.name;
    String apellido = Preferencias.apellido;
    String data_usuario = Preferencias.data_usuario;
    String grupo = Preferencias.grupo;
    String foto_usuario = Preferencias.foto_usuario;
    String foto_empresa = Preferencias.foto_empresa;
    String data_id = Preferencias.data_id;
    String data_empresa = Preferencias.data_empresa;
    String nombre_empresa = Preferencias.nombre_empresa;

    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(1.3, -1.1),
            child: Container(
              width: 150.0,
              height: 150.0,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white30),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 93, 225, 240), Colors.cyan])),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                foregroundColor: Colors.white,
                title: Image.asset(
                  'assets/gozeri_blanco2.png',
                  width: size.width * 0.25,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  PopupMenuButton(
                      // Callback that sets the selected popup menu item.
                      onSelected: (value) {
                        if (value == 'exit') {
                          authService.logout();
                          Navigator.pushReplacementNamed(context, 'checking');
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                            const PopupMenuItem(
                              value: "exit",
                              child: ListTile(
                                title: Text("Cerrar Sesión"),
                                trailing: Icon(Icons.logout),
                              ),
                            ),
                          ])
                ]),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.white60, width: 2.0)),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(foto_usuario),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  "${name} ${apellido}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white),
                ),
                Text(
                  "${grupo} | ${data_usuario}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(63, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10)),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Image.network(
                        '${foto_empresa}',
                        width: size.width * 0.2,
                      ),
                      Text(
                        "${nombre_empresa}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                            color: Colors.white54),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height * 0.50),
            decoration: const BoxDecoration(
                color: Color.fromARGB(210, 255, 255, 255),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height * 0.38),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                  itemCount: 2,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) => GestureDetector(
                        onTap: () async {
                          final _facturacion =
                              Provider.of<Facturacion>(context, listen: false);
                          final factuProv = await _facturacion.new_tmpFactura();

                          if (index == 0) {
                            _depa.isLoading = true;
                            _cart.cantidad = 0;
                            _depa.LoadDepa();

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
                                  message:
                                      'Fallo al crear la factura temporal.',

                                  /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                  contentType: ContentType.failure,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewTabsScreen(id_tmp: factuProv)),
                              );
                            }
                          }
                        },
                        child: Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Container(
                            color: Colors.white,
                            margin: EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset((index == 0)
                                    ? 'assets/factura_create.png'
                                    : (index == 1)
                                        ? 'assets/h_factura.png'
                                        : 'gozeri_blanco.png'),
                                Text(
                                  (index == 0)
                                      ? 'Facturar'
                                      : (index == 1)
                                          ? "Historial F."
                                          : '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 13, 144, 161),
                                      fontSize: 18.0),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
            ),
          )
        ],
      ),
    ));
  }
}
