import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:factura_gozeri/controllers/mantenimiento_screen.dart';
import 'package:factura_gozeri/controllers/membresia_screen.dart';
import 'package:factura_gozeri/controllers/permission_screen.dart';
import 'package:factura_gozeri/controllers/version_screen.dart';
import 'package:factura_gozeri/screens/escritorio_screen.dart';
import 'package:factura_gozeri/screens/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:factura_gozeri/services/services.dart';
import 'package:factura_gozeri/screens/screens.dart';

class CheckOuthScreen extends StatefulWidget {
  const CheckOuthScreen({Key? key}) : super(key: key);

  @override
  State<CheckOuthScreen> createState() => _CheckOuthScreenState();
}

class _CheckOuthScreenState extends State<CheckOuthScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.wifi;
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
    Future.delayed(Duration.zero, () async{
      bool serviceEnabled;
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if(permission==LocationPermission.whileInUse || permission==LocationPermission.always){
        print('si hay localizacion');
      }else{
        print('no localizacion');
        return Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => PermissionScream(),
                transitionDuration: Duration(seconds: 0)))
        .then((value) => Navigator.of(context).pop());
      }
    });
    initialActivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('conexion :' + _connectionStatus.name);
    if (_connectionStatus.name != 'wifi' &&
        _connectionStatus.name != 'mobile') {
      return NoInternet();
    }
    final authService = Provider.of<AuthService>(context, listen: false);

    


    /*Future.delayed(Duration.zero, () {
      Geolocator geolocator = 
      Geolocator()..forceAndroidLocationManager = true;
      GeolocationStatus geolocationStatus  = await 
      geolocator.checkGeolocationPermissionStatus();
      final authService = Provider.of<AuthService>(context, listen: false);
      if (1 == 1) {
        Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) => PermissionScream(),
                    transitionDuration: Duration(seconds: 0)))
            .then((value) => Navigator.of(context).pop());
      }
    });*/

    

    return Scaffold(
      body: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.white])),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Image.asset(
                      "assets/gozeri_factura2.png",
                      color: Colors.cyan.withOpacity(0.4),
                      width: 250.0,
                      height: 250.0,
                    ),
                    const Text(
                      "Sistema de Facturación",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromARGB(255, 13, 205, 230),
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0),
                    ),
                  ],
                ),
                /*const CircularProgressIndicator(
                  color: Colors.white,
                  backgroundColor: Color.fromARGB(255, 178, 235, 242),
                )*/
                Image.asset(
                  "assets/out_preloader_image.gif",
                  width: MediaQuery.of(context).size.width * 0.4,
                )
              ]),
        ),
        Center(
          child: FutureBuilder(
            future: authService.readUsuario(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (!snapshot.hasData) {
                return const Text('');
              }
              print(snapshot.data);

              Future.delayed(const Duration(seconds: 1), () {
                if (snapshot.data == '' || snapshot.data == null) {
                  Future.microtask(() {
                    //Future.delayed(Duration(seconds: 5));
                    Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (_, __, ___) => LoginScreen(),
                                transitionDuration: Duration(seconds: 0)))
                        .then((value) => Navigator.of(context).pop());
                  });
                } else if (snapshot.data == 'membresia') {
                  Future.microtask(() {
                    //Future.delayed(Duration(seconds: 5));
                    Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (_, __, ___) => MembresiaScreen(),
                                transitionDuration: Duration(seconds: 0)))
                        .then((value) => Navigator.of(context).pop());
                  });
                } else if (snapshot.data == 'version') {
                  Future.microtask(() {
                    //Future.delayed(Duration(seconds: 5));
                    Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (_, __, ___) => VersionScreen(),
                                transitionDuration: Duration(seconds: 0)))
                        .then((value) => Navigator.of(context).pop());
                  });
                } else if (snapshot.data == 'mantenimiento') {
                  Future.microtask(() {
                    //Future.delayed(Duration(seconds: 5));
                    Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    MantenimientoScreen(),
                                transitionDuration: Duration(seconds: 0)))
                        .then((value) => Navigator.of(context).pop());
                  });
                } else {
                  Future.microtask(() {
                    //Future.delayed(Duration(seconds: 5));
                    Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    EscritorioScreen(), //EscritorioScreen(),
                                transitionDuration: Duration(seconds: 0)))
                        .then((value) => Navigator.of(context).pop());
                  });
                }
              });

              return Container();
            },
          ),
        ),
      ]),
    );
  }
}
