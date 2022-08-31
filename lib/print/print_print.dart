import 'package:flutter/material.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';

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
                    print(_devices[i]);
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
    //final result = await _printerBluetoothManager.printTicket(ticket);
  }
}
/*
Ticket testTicket() {
  final Ticket ticket = Ticket(PaperSize.mm80);

  ticket.text(
      'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
  ticket.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
      styles: PosStyles(codeTable: PosCodeTable.westEur));
  ticket.text('Special 2: blåbærgrød',
      styles: PosStyles(codeTable: PosCodeTable.westEur));

  ticket.text('Bold text', styles: PosStyles(bold: true));
  ticket.text('Reverse text', styles: PosStyles(reverse: true));
  ticket.text('Underlined text',
      styles: PosStyles(underline: true), linesAfter: 1);
  ticket.text('Align left', styles: PosStyles(align: PosAlign.left));
  ticket.text('Align center', styles: PosStyles(align: PosAlign.center));
  ticket.text('Align right',
      styles: PosStyles(align: PosAlign.right), linesAfter: 1);

  ticket.text('Text size 200%',
      styles: PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ));

  ticket.feed(2);
  ticket.cut();
  return ticket;
}*/
