import 'package:factura_gozeri/print/print_page.dart';
import 'package:factura_gozeri/widgets/item_dataCliente.dart';
import 'package:factura_gozeri/widgets/items_cart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:intl/intl.dart';

/*ListView.builder(
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
)*/

class PrintScreen extends StatefulWidget {
  String id_tmp;
  Color colorPrimary;
  PrintScreen({Key? key, required this.id_tmp, required this.colorPrimary})
      : super(key: key);

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  final List<Map<String, dynamic>> data = [
    {'title': 'uurururu', 'price': 15, 'qty': 2},
    {'title': 'wewerdd', 'price': 2, 'qty': 20},
    {'title': 'www  wer ewr ', 'price': 150, 'qty': 22},
    {'title': 'eerere ', 'price': 5, 'qty': 442},
  ];

  final f = NumberFormat("\$###,###.00", "en_US");
  int open = 0;

  @override
  Widget build(BuildContext context) {
    int _total = 0;
    /*_total = data
        .map((e) => e['price'] * e['qty'])
        .reduce((value, element) => value + element);*/

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: widget.colorPrimary,
          title:
              const Text('Facturación', style: TextStyle(color: Colors.white))),
      body: Column(
        children: [
          Expanded(
              child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    key: Key('builder ${open.toString()}'),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: ((context, index) {
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.all(10),
                        child: ExpansionTile(
                          key: Key(index.toString()),
                          initiallyExpanded: open == index,
                          leading: CircleAvatar(
                            backgroundColor: widget.colorPrimary,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 25),
                            ),
                          ),
                          childrenPadding: const EdgeInsets.all(5),
                          title: (index == 0)
                              ? const Text('Detalle del Pedido')
                              : (index == 1)
                                  ? const Text('Datos de Cliente')
                                  : const Text('Detalle de Pago'),
                          children: [
                            (index == 0)
                                ? ItemsCart(
                                    id_tmp: widget.id_tmp,
                                    colorPrimary: widget.colorPrimary,
                                  )
                                : (index == 1)
                                    ? ItemCliente(
                                        colorPrimary: widget.colorPrimary)
                                    : const Text(''),
                            Container(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                  label: const Icon(
                                    Icons.arrow_forward,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (index == 0) {
                                        open = 1;
                                      } else if (index == 1) {
                                        open = 2;
                                      } else {
                                        open = 0;
                                      }
                                    });
                                    print(open);
                                  },
                                  style: TextButton.styleFrom(
                                      primary: Colors.white,
                                      backgroundColor: widget.colorPrimary),
                                  icon: const Text("Continuar")),
                            )
                          ],
                        ),
                      );
                    }),
                  ))),
          Container(
            color: Color.fromARGB(255, 233, 233, 233),
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                /*Text("Total: ${f.format(_total)}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(
                  width: 80,
                ),*/
                Expanded(
                    child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => Print(data)));
                  },
                  icon: const Icon(Icons.print),
                  label: const Text('Facturar'),
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
