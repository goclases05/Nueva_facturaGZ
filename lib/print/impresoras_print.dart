import 'dart:convert';

import 'package:factura_gozeri/global/globals.dart';
import 'package:flutter/material.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'dart:io' show Platform;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ImpresorasPrint extends StatefulWidget {
  ImpresorasPrint({Key? key, required this.id_tmp}) : super(key: key);
  String id_tmp;
  @override
  _ImpresorasPrint createState() => _ImpresorasPrint();
}

class _ImpresorasPrint extends State<ImpresorasPrint> {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  String _devicesMsg = "";
  BluetoothManager bluetoothManager = BluetoothManager.instance;
  bool isSwitched = false;

  @override
  void initState() {
    if (Platform.isAndroid) {
      bluetoothManager.state.listen((val) {
        print('state = $val');
        if (!mounted) return;
        if (val == 12) {
          print('on');
          initPrinter();
        } else if (val == 10) {
          print('off');
          setState(() => _devicesMsg = 'Bluetooth sin Conexión');
        }
      });
    } else {
      initPrinter();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        foregroundColor: Colors.cyan,
        title: const Text('Lista de Impresoras',
            style: TextStyle(fontSize: 18, color: Colors.cyan)),
        actions: [
          TextButton.icon(
            style:TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.redAccent,
              padding: EdgeInsets.symmetric(horizontal: 5)
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AlertDialog(
                  backgroundColor: Color.fromARGB(255, 115, 160, 236),
                  content: Text(
                    'Se realizo el cambio',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
              setState(() {
                Preferencias.mac='';
              });
            },
            icon: Icon(Icons.refresh),
            label: Text('restablecer'),
          ),
          //SizedBox(width: 10,),
        ],
      ),
      body: _devices.isEmpty
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.cyan),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    _devicesMsg,
                    style: TextStyle(fontSize: 18, color: Colors.cyan.shade900),
                    textAlign: TextAlign.center,
                  )
                ],
              )))
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (c, i) {
                return ListTile(
                  leading: Switch(
                      value: (Preferencias.mac == '')
                          ? false
                          : (Preferencias.mac == _devices[i].address)
                              ? true
                              : false,
                      onChanged: (value) async {
                        print(' el valor ' + value.toString());

                        final storage = new FlutterSecureStorage();

                        Map map = {
                          'name': _devices[i].name,
                          'address': _devices[i].address,
                          'type': _devices[i].type
                        };

                        final js = json.encode(map);
                        print(js);
                        //dynamic vare = _devices![i];
                        Preferencias.impresora = js;
                        print('este es el shared : ' + Preferencias.impresora);
                        if (value) {
                          //await storage.write(key: 'IMPRESORA', value: vare);

                          Preferencias.mac = _devices[i].address.toString();
                        } else {
                          //await storage.write(key: 'IMPRESORA', value: '');
                          Preferencias.mac = '';
                        }
                        /*print(
                            'mac ' + Preferencias.impresora.address.toString());*/
                        setState(() {});
                      }),
                  title: Text("${_devices[i].name}"),
                  subtitle: Text("${_devices[i].address}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _printerManager.stopScan();
                          _startPrint(_devices[i]);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              //color: Theme.of(context).primaryColor,
                              color: Colors.cyan,
                              borderRadius: BorderRadius.circular(15)),
                          child: const Icon(
                            Icons.print,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      )
                    ],
                  ),
                  onTap: () {},
                );
              },
            ),
    );
  }

  void initPrinter() {
    _printerManager.startScan(Duration(seconds: 5));
    //_printerManager.stopScan();
    _printerManager.scanResults.listen((val) {
      if (!mounted) return;
      setState(() => _devices = val);
      if (_devices.isEmpty)
        setState(
            () => _devicesMsg = 'No se encontraron Impresoras disponibles');
    });
  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    final result = await _printerManager.printTicket(
        await testTicket(printer.name.toString(), printer.address.toString()));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(result.msg),
      ),
    );
  }

  Future<List<int>> testTicket(String msg, String id_device) async {
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generatorr = Generator(PaperSize.mm58, profile);
    List<int> bytess = [];

    /*bytess += generatorr.text('Impresión Factura',
        styles: const PosStyles(
            codeTable: 'CP1252',
            align: PosAlign.center,
            bold: true,
            width: PosTextSize.size2));*/
    bytess += generatorr.text('Impresión Termica',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    bytess += generatorr.text('Esta es una prueba:' + msg + ' ' + id_device,
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    /*bytes += generator.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ');
    bytes += generator.text('Special 2: blåbærgrød');

    bytes += generator.text('Bold text', styles: PosStyles(bold: true));
    bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    bytes +=
        generator.text('Align left', styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.text('Text size 200%',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));*/

    //bytes += generator.feed(2);
    bytess += generatorr.cut();
    return bytess;
  }

  @override
  void dispose() {
    _printerManager.stopScan();
    super.dispose();
  }
}
