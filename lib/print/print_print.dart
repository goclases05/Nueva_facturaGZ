import 'package:factura_gozeri/print/print_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:intl/intl.dart';

class PrintScreen extends StatelessWidget {
  String id_tmp;
  PrintScreen({Key? key, required this.id_tmp}) : super(key: key);
  final List<Map<String, dynamic>> data = [
    {'title': 'uurururu', 'price': 15, 'qty': 2},
    {'title': 'wewerdd', 'price': 2, 'qty': 20},
    {'title': 'www  wer ewr ', 'price': 150, 'qty': 22},
    {'title': 'eerere ', 'price': 5, 'qty': 442},
  ];

  final f = NumberFormat("\$###,###.00", "en_US");

  @override
  Widget build(BuildContext context) {
    int _total = 0;
    _total = data
        .map((e) => e['price'] * e['qty'])
        .reduce((value, element) => value + element);

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter - Therminal Printer'),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            color: Colors.white,
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (c, i) {
                  return ListTile(
                    title: Text(data[i]['title'].toString(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        "${f.format(data[i]['price'])} x ${data[i]['qty']}"),
                    trailing: Text(f.format(data[i]['price'] * data[i]['qty'])),
                  );
                }),
          )),
          Container(
            color: Color.fromARGB(255, 233, 233, 233),
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Text("Total: ${f.format(_total)}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(
                  width: 80,
                ),
                Expanded(
                    child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => PrintPage(data)));
                  },
                  icon: const Icon(Icons.print),
                  label: const Text('Print'),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
