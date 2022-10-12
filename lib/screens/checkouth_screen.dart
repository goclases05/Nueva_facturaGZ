import 'package:factura_gozeri/screens/escritorio_screen.dart';
import 'package:factura_gozeri/screens/home2_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:factura_gozeri/services/services.dart';
import 'package:factura_gozeri/screens/screens.dart';

class CheckOuthScreen extends StatelessWidget {
  const CheckOuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [Colors.cyan, Colors.cyan])),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.asset(
                      "assets/gozeri_factura2.png",
                      width: 250.0,
                      height: 250.0,
                    ),
                    const Text(
                      "Sistema de Facturación",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0),
                    ),
                  ],
                ),
                const CircularProgressIndicator(
                  color: Colors.white,
                  backgroundColor: Color.fromARGB(255, 178, 235, 242),
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
                } else {
                  Future.microtask(() {
                    //Future.delayed(Duration(seconds: 5));

                    Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (_, __, ___) => EscritorioScreen(),
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
