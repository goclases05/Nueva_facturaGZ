import 'package:factura_gozeri/providers/carshop_provider.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/providers/items_provider.dart';
import 'package:factura_gozeri/providers/print_provider.dart';
import 'package:factura_gozeri/providers/seattings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'global/globals.dart';
import 'screens/screens.dart';
import 'services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Preferences.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Preferencias.init();
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
        ChangeNotifierProvider(create: (_)=> ItemProvider()),
        ChangeNotifierProvider(create: (_)=> settingsProvider()),
        ChangeNotifierProvider(create: (_)=>PrintProvider()),
        ChangeNotifierProvider(
          create: (context) => Facturacion(),
        )
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
