import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/providers/carshop_provider.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/providers/seattings_provider.dart';
import 'package:factura_gozeri/screens/screens.dart';
import 'package:factura_gozeri/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//Crie suas global keys e adicione aos componentes que deverão ser
//localizados e exibidos.
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyButton = GlobalKey();
  GlobalKey keyFacturar = GlobalKey();
  GlobalKey keyHistorial = GlobalKey();
  GlobalKey keysucursal = GlobalKey();

  //Iniciando o estado.
  @override
  void initState() {
    createTutorial();
    Future.delayed(Duration.zero, showTutorial);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  String selectedValue = "${Preferencias.sucursal}";

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
    final settings = Provider.of<settingsProvider>(context, listen: false);

    Color ColPrimary = settings.colorPrimary;
    //Color ColPrimary =Color.fromARGB(int.parse('251'), int.parse('251'), int.parse('251'), 1);

    List<DropdownMenuItem<String>> menuItems = [];
    for (var i = 0; i < authService.list_sucu.length; i++) {
      menuItems.add(DropdownMenuItem(
          child: Center(
            child: Text(
              authService.list_sucu[i].nombre,
              textAlign: TextAlign.center,
            ),
          ),
          value: authService.list_sucu[i].idSucursal));
      ;
    }

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
              decoration: BoxDecoration(
                  /*gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 93, 225, 240), 
                      Colors.cyan
                  ])),*/
                  color: ColPrimary //Color.fromARGB(255, 203, 209, 218)
                  )),
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
                  CircleAvatar(
                    backgroundColor: Colors.white38,
                    child: IconButton(
                      key: keyButton,
                      onPressed: () {},
                      icon: Icon(Icons.print),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                      backgroundColor: Colors.white38,
                      child: PopupMenuButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          // Callback that sets the selected popup menu item.
                          onSelected: (value) {
                            if (value == 'exit') {
                              authService.logout();
                              Navigator.pushReplacementNamed(
                                  context, 'checking');
                            } else if (value == 'settings') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
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
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.white60, width: 2.0)),
                        child: (foto_usuario == '' ||
                                foto_usuario ==
                                    'https://imagenes.gozeri.com/ImagenesGozeri/siluetas_perfil.gif')
                            ? const CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    AssetImage('assets/perfil_user.png'),
                              )
                            : CircleAvatar(
                              backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(foto_usuario),
                              )),
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
                  height: 2,
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  /*decoration: BoxDecoration(
                      color: const Color.fromARGB(63, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10)),*/
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white),
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        child: DropdownButton(
                          key: keysucursal,
                          itemHeight: null,
                          value: selectedValue,
                          dropdownColor: Colors.white,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue!;
                              Preferencias.sucursal = selectedValue;
                            });
                          },
                          items: menuItems,
                          elevation: 0,
                          style: TextStyle(
                              color: ColPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          //icon: Icon(Icons.arrow_drop_down),
                          iconDisabledColor: Colors.red,
                          iconEnabledColor: settings.colorPrimary,
                          underline: SizedBox(),
                        ),
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
            margin: EdgeInsets.only(top: size.height * 0.33),
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

                          if (index == 0) {
                            final factuProv =
                                await _facturacion.new_tmpFactura();
                            print('factura no: ${factuProv[0]}');
                            print('clave : ${factuProv[1]}');
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
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewTabsScreen(
                                      colorPrimary: ColPrimary,
                                      id_tmp: factuProv[0],
                                      clave: factuProv[1]),
                                ),
                              );
                            }
                          } else if (index == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TabsFacturacion(colorPrimary: ColPrimary),
                              ),
                            );
                          }
                        },
                        child: Card(
                          key: (index == 0) ? keyFacturar : keyHistorial,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Container(
                            color: Colors.white,
                            margin: const EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset((index == 0)
                                    ? 'assets/add_factura_2.png'
                                    : (index == 1)
                                        ? 'assets/fhistorial_2.png'
                                        : 'gozeri_blanco.png'),
                                Text(
                                  (index == 0)
                                      ? 'Facturar'
                                      : (index == 1)
                                          ? "Historial F."
                                          : '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColPrimary,
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

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black45,
      textSkip: "Saltar Presentación",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print('termino');
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyButton,
        color: Colors.black54,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      "Impresoras",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Predetermina tu impresora de preferencia",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );

    targets.add(
      TargetFocus(
        identify: "Target 5",
        keyTarget: keysucursal,
        color: Colors.black54,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Sucursal",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Selecciona la sucursal con la que se realizaran las facturas",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                        icon: const Icon(
                          Icons.chevron_left,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          controller.previous();
                        },
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.cyan),
                        label: const Text("Ver Anterior"))
                  ],
                ),
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );

    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: keyFacturar,
        color: Colors.black54,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Facturar:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Realiza tus facturas.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                        icon: const Icon(
                          Icons.chevron_left,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          controller.previous();
                        },
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.cyan),
                        label: const Text("Ver Anterior"))
                  ],
                ),
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );

    targets.add(
      TargetFocus(
        identify: "Target 3",
        keyTarget: keyHistorial,
        color: Colors.black54,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Historial",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Área asignada para el registro de las facturas realizadas (terminadas y pendientes de terminar).",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                        icon: const Icon(
                          Icons.chevron_left,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          controller.previous();
                        },
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.cyan),
                        label: const Text("Ver Anterior"))
                  ],
                ),
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );

    return targets;
  }
}
