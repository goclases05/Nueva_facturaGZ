import 'package:edge_alerts/edge_alerts.dart';
import 'package:factura_gozeri/screens/checkouth_screen.dart';
import 'package:factura_gozeri/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class PermissionScream extends StatefulWidget {
  const PermissionScream({Key? key}) : super(key: key);

  @override
  State<PermissionScream> createState() => _PermissionScreamState();
}

class _PermissionScreamState extends State<PermissionScream> {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    // Test if location services are enabled.
    
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

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
    final authService = Provider.of<AuthService>(context, listen: false);
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 1,
          color: Colors.white,
        ),
        Positioned(
          left: -50,
          top: 20,
          child: CircleAvatar(
            backgroundColor:
                Color.fromARGB(255, 174, 192, 195).withOpacity(0.2),
            radius: 60,
          ),
        ),
        Positioned(
          right: -70,
          top: -5,
          child: CircleAvatar(
            backgroundColor:
                Color.fromARGB(255, 174, 192, 195).withOpacity(0.2),
            radius: 150,
          ),
        ),
        Positioned(
          left: -70,
          bottom: -70,
          child: CircleAvatar(
            backgroundColor:
                Color.fromARGB(255, 174, 192, 195).withOpacity(0.2),
            radius: 150,
          ),
        ),
        /*Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children:const [
              Text('Mempresía Expirada',style: TextStyle(color: Colors.cyanAccent),),
              Text('Tu panel de Control ha sido bloqueado temporalmente')
            ],
          )
        )*/
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Image.asset(
              'assets/gozeri_blanco2.png',
              color: Colors.cyan.withOpacity(0.8),
              width: MediaQuery.of(context).size.width * 0.3,
            ),
            actions: const [
              SizedBox(
                width: 10,
              ),
              /*CircleAvatar(
                  backgroundColor: const Color.fromRGBO(242, 242, 247, 1),
                  child: PopupMenuButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.cyan,
                    ),
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
                              trailing: Icon(
                                Icons.logout,
                              ),
                            ),
                          )
                        ])),*/
            ],
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Image.asset('assets/gozeri_blanco2.png',color: Colors.cyan.withOpacity(0.3), width: MediaQuery.of(context).size.width*0.3,),
                Card(
                    elevation: 5,
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.cyan,
                          size: 120,
                        ))),
                const SizedBox(
                  height: 10,
                ),
                const Text('Permiso de Localización',
                    style: TextStyle(color: Colors.cyan, fontSize: 25),
                    textAlign: TextAlign.center),
                const Text(
                  'Gozeri Facturación recoge datos de ubicación para habilitar las funciones de Impresión y busqueda de dispositivos locales (ESC POS) aunque la aplicación esté cerrada o no se esté usando',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                )
              ],
            ),
          ),
          bottomSheet: Row(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextButton.icon(
                  onPressed: () async {
                    bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();
                    if(!isLocationServiceEnabled){
                       edgeAlert(context,
                            description: 'GPS deshabilitado',
                            gravity: Gravity.top,
                            backgroundColor: Colors.redAccent);

                      await Geolocator.openLocationSettings();

                    }else{
                      //await _determinePosition();
                      LocationPermission permission;
                      if(await Geolocator.checkPermission()==LocationPermission.deniedForever){
                        print('esta forever');
                        await Geolocator.openAppSettings();
                      }else{
                        print('esta '+Geolocator.checkPermission().toString());
                        permission = await Geolocator.requestPermission();
                      }
                      
                      permission = await Geolocator.checkPermission();
                      if(permission==LocationPermission.whileInUse || permission==LocationPermission.always){
                          Navigator.pushReplacementNamed(context, 'checking');
                      }else if(permission==LocationPermission.deniedForever){
                        await Geolocator.openAppSettings();
                      }else{
                        setState(() {
                          
                        });
                      }
                    }
                    
                    //
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Solicitar Acceso'),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.cyan,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
          ]),
        )
      ],
    );
  }
}
