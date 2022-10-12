import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:factura_gozeri/providers/carshop_provider.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/providers/seattings_provider.dart';
import 'package:factura_gozeri/screens/screens.dart';
import 'package:factura_gozeri/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
class Home2Screen extends StatefulWidget {
  const Home2Screen({Key? key}) : super(key: key);

  @override
  State<Home2Screen> createState() => _Home2ScreenState();
}

class _Home2ScreenState extends State<Home2Screen> {
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyButton = GlobalKey();
  GlobalKey keyFacturar = GlobalKey();
  GlobalKey keyHistorial = GlobalKey();
  GlobalKey keysucursal = GlobalKey();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
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

    List<String> portadas=[
      "https://img.freepik.com/psd-premium/coffee-time-mejor-menu-cafe-ciudad-promocion-cafeteria-restaurante-publicacion-redes-sociales-plantilla-banner-portada-facebook_485905-525.jpg",
      "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/coffee-header-design-template-87206fc2b4e59e55a2287706a117e361_screen.jpg",
      "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/coffee-bar-design-template-cb1714903c87981246357a6884d3775f_screen.jpg"
    ];
    
    return Stack(
      children:[
        Expanded(
        child: Container(
          width: size.width*1,
          height: size.height*1,
          color: Colors.white,
          ),
        ),
      Expanded(
        child: Container(
          width: size.width*1,
          height: size.height*1,
          color: ColPrimary.withOpacity(0.06),
          ),
        ),
       Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Image.asset(
            'assets/gozeri_blanco2.png',
            width: size.width * 0.25,
          ),
          backgroundColor: ColPrimary,
          elevation: 5,
          actions: [
            CircleAvatar(
              backgroundColor: Colors.white54,
              child: IconButton(
                key: keyButton,
                onPressed: () {},
                icon: const Icon(Icons.print),
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            CircleAvatar(
                backgroundColor: Colors.white54,
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
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                CarouselSlider.builder(
                  itemCount: portadas.length,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex){
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: FadeInImage(
                        placeholder: const AssetImage('assets/out_preloader_image.gif'),
                        image: NetworkImage(portadas[itemIndex]),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  options: CarouselOptions(
                      height: size.height*0.2,
                      aspectRatio: 16/9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                  )
                ),
                Container(
                  padding:const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(grupo+' | '+data_usuario, style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w800,
                          fontSize: 18
                        ),
                      ),
                      Card(
                        elevation: 4,
                        child: ListTile(
                          onTap: ()=>null,
                          contentPadding: EdgeInsets.all(10),
                          title: Text(name+' '+apellido, style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 90, 89, 89),
                            fontWeight: FontWeight.bold
                          ),),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: (
                              foto_usuario == '' ||
                              foto_usuario == 'https://imagenes.gozeri.com/ImagenesGozeri/siluetas_perfil.gif')?
                              const FadeInImage(placeholder: AssetImage('assets/cilUser.jpg'), image:  AssetImage('assets/cilUser.jpg')):
                              FadeInImage(placeholder: const AssetImage('assets/cilUser.jpg'), image: NetworkImage(foto_usuario))
                          ),
                        ),
                      ),
                      const SizedBox(height:10),
                      const Text("Sucursal", style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w800,
                          fontSize: 18
                        ),
                      ),
          
          
                      //sucursal
                      Card(
                        elevation: 4,
                        child: ListTile(
                          onTap: ()=>null,
                          contentPadding: EdgeInsets.all(10),
                          title: Text(name+' '+apellido, style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 90, 89, 89),
                            fontWeight: FontWeight.bold
                          ),),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: (
                              foto_usuario == '' ||
                              foto_usuario == 'https://imagenes.gozeri.com/ImagenesGozeri/siluetas_perfil.gif')?
                              const FadeInImage(placeholder: AssetImage('assets/cilUser.jpg'), image:  AssetImage('assets/cilUser.jpg')):
                              FadeInImage(placeholder: const AssetImage('assets/cilUser.jpg'), image: NetworkImage(foto_empresa,),width: size.width*0.2,)
                          ),
                        ),
                      ),
                      //*sucursal
          
                      const SizedBox(height:10),
                      const Text("Menú", style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w800,
                          fontSize: 18
                        ),
                      ),
                      const SizedBox(height:5),
          
                      //grid layout
                      GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap :true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 2,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
                              elevation: 4,
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
                                            : 'assets/gozeri_blanco.png'),
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
                          )
                        ),
                      //*grid layout
          
                    ]
                  ),
                )
              ],
            ),
          ),
      ),
      ]
    );
  }
}