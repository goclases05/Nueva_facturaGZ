import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:image/image.dart' as Image;
import 'dart:typed_data';
import 'package:flutter/services.dart';
class Print extends StatefulWidget {
  dynamic id_tmp;
  Print({Key? key, required this.id_tmp}) : super(key: key);

  @override
  State<Print> createState() => _PrintState();
}

class _PrintState extends State<Print> {
  PrinterBluetoothManager _printerBluetoothManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  String _deviceMsg = '';

  @override
  void initState() {
    print(widget.id_tmp);
    initPrinter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _devices.isEmpty
          ? Center(child: Text(_deviceMsg ?? ''))
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (c, i) {
                return ListTile(
                  leading: Icon(Icons.print),
                  title: Text(_devices[i].name.toString()),
                  subtitle: Text(_devices[i].address.toString()),
                  onTap: () {
                    _startPrint(_devices[i]);
                  },
                );
              },
            ),
    );
  }

  void initPrinter() {
    _printerBluetoothManager.startScan(Duration(seconds: 2));
    _printerBluetoothManager.scanResults.listen((val) {
      if (!mounted) return;
      setState(() {
        _devices = val;
        print(_devices);
        if (_deviceMsg.isEmpty) {
          setState(() {
            _deviceMsg = 'No se encuentran dispositivos';
          });
        }
      });
    });
  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerBluetoothManager.selectPrinter(printer);
    final result= await _printerBluetoothManager.printTicket(await _ticket(PaperSize.mm80));
    //final result = await _printerBluetoothManager.printTicket(ticket);
  }

  Future<dynamic> _ticket(paper) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(paper, profile);
    List<int> bytes = [];

    bytes += generator.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: PosStyles(codeTable: 'CP1252'));
    bytes += generator.text('Special 2: blåbærgrød',
        styles: PosStyles(codeTable: 'CP1252'));

    bytes += generator.text('Bold text', styles: PosStyles(bold: true));
    bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    bytes +=
        generator.text('Align left', styles: PosStyles(align: PosAlign.left));
    bytes +=
        generator.text('Align center', styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    bytes += generator.text('Text size 200%',
        styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    // Print image:
    final ByteData data = await rootBundle.load('assets/logo.png');
    final Uint8List imgBytes = data.buffer.asUint8List();
    final Image.Image image = Image.decodeImage(imgBytes)!;
    bytes += generator.image(image);
    // Print image using an alternative (obsolette) command
    // bytes += generator.imageRaster(image);

    // Print barcode
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));

    // Print mixed (chinese + latin) text. Only for printers supporting Kanji mode
    // ticket.text(
    //   'hello ! 中文字 # world @ éphémère &',
    //   styles: PosStyles(codeTable: PosCodeTable.westEur),
    //   containsChinese: true,
    // );

    bytes += generator.feed(2);
    bytes += generator.cut();
  }

  
}

