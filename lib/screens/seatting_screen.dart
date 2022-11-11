import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:factura_gozeri/providers/seattings_provider.dart';
import 'package:factura_gozeri/screens/checkouth_screen.dart';
import 'package:factura_gozeri/screens/escritorio_screen.dart';
import 'package:factura_gozeri/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<settingsProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const EscritorioScreen(),
          ),
        ).then((value) => setState(() {}));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          foregroundColor: settings.colorPrimary,
          backgroundColor: Colors.white,
          title: const Text('Ajustes'),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: settings.colorPrimary,
                  child: const Icon(
                    Icons.receipt_long,
                    color: Colors.white,
                  )),
              title: Text("Imprimir al facturar"),
              trailing: Switch(
                  value: Preferencias.printfactura,
                  onChanged: (value) async {
                    Preferencias.printfactura = value;
                    setState(() {});
                  }),
              onTap: () {},
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: settings.colorPrimary,
                  child: const Icon(
                    Icons.print,
                    color: Colors.white,
                  )),
              title: Text("Impresión Sunmi"),
              trailing: Switch(
                  value: Preferencias.sunmi_preferencia,
                  onChanged: (value) async {
                    Preferencias.sunmi_preferencia = value;
                    setState(() {});
                  }),
              onTap: () {},
            ),
            const Divider(color: Colors.grey),
            ExpansionTile(
              leading: CircleAvatar(
                  backgroundColor: settings.colorPrimary,
                  child: const Icon(
                    Icons.palette,
                    color: Colors.white,
                  )),
              title: const Text('Colores de Ambiente '),
              //backgroundColor: const Color.fromRGBO(246, 243, 244, 1),
              children: [
                GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: settings.list_Color.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5),
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: CircleAvatar(
                            backgroundColor: settings.list_Color[index],
                          ),
                        ),
                        onTap: () {
                          settings.colorChange(index);
                          setState(() {});
                        },
                      );
                    })),
              ],
            )
          ],
        ),
      ),
    );
  }
}
