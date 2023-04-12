import 'dart:async';
import 'dart:io';

import 'package:factura_gozeri/providers/carshop_provider.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/providers/impresoras_provider.dart';
import 'package:factura_gozeri/providers/items_provider.dart';
import 'package:factura_gozeri/providers/preferencias_art_provider.dart';
import 'package:factura_gozeri/providers/print_provider.dart';
import 'package:factura_gozeri/providers/reportes_provider.dart';
import 'package:factura_gozeri/providers/seattings_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:factura_gozeri/screens/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

import 'global/globals.dart';
import 'screens/screens.dart';
import 'services/services.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Preferences.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Preferencias.init();

  HttpOverrides.global = new MyHttpOverrides();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => DepartamentoService()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => settingsProvider()),
        ChangeNotifierProvider(create: (_) => PrintProvider()),
        ChangeNotifierProvider(create: (_) => ReporteProvider()),
        ChangeNotifierProvider(create: (_) => ImpresorasProvider()),
        ChangeNotifierProvider(create: (_) => Preferencias_art()),
        ChangeNotifierProvider(
          create: (context) => Facturacion(),
        )
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      //statusBarColor: const Color(0xff0061a7),
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gozeri Facturacion',
      /*localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        RefreshLocalizations.delegate,
      ],*/
      /*supportedLocales: const [
        Locale('en'), // English, no country code
        Locale('es'), // Spanish, no country code
      ],*/
      initialRoute: 'checking',
      routes: {
        //'splashScreen': (_) => const SplashCheckAuth(),
        'checking': (_) => const CheckOuthScreen(),
        /*'login': (_) => const LoginScreen(),
        'home': (_) => const HomeScreen(),
        'articulos': (_) => const VistaArticulos(),
        'productosActual': (_) => ProductosActualScreen()*/
      },
      //scaffoldMessengerKey: AlertsService.messengerKey,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
    );
  }
}
