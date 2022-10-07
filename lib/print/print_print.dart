import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/print/print_page.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/services/auth_services.dart';
import 'package:factura_gozeri/widgets/item_dataCliente.dart';
import 'package:factura_gozeri/widgets/items_cart.dart';
import 'package:factura_gozeri/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  String serie;
  PrintScreen({Key? key, required this.id_tmp, required this.colorPrimary, required this.serie})
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
    List<DropdownMenuItem<String>> menuItems = [];
    final authService = Provider.of<AuthService>(context, listen: false);
    final facturaService = Provider.of<Facturacion>(context, listen: false);

    menuItems.add(DropdownMenuItem(
        child: Text(
          'Selecciona una serie',
          textAlign: TextAlign.center,
        ),
        value: '0'));

    for (var i = 0; i < authService.list_serie.length; i++) {
      menuItems.add(DropdownMenuItem(
          child: Text(
            authService.list_serie[i].nombre,
            textAlign: TextAlign.center,
          ),
          value: authService.list_serie[i].idSerie));
    }

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: widget.colorPrimary,
          title:
              const Text('Facturación', style: TextStyle(color: Colors.white))),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 30, right: 10, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Serie: ",
                  style: TextStyle(
                      color: widget.colorPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Card(
                      child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: DropdownButton(
                      itemHeight: null,
                      value: facturaService.initialSerie,
                      isExpanded: true,
                      dropdownColor: Color.fromARGB(255, 241, 238, 241),
                      onChanged: (String? newValue) async{
                        var cambio=await facturaService.serie(widget.id_tmp, 'add', newValue!);
                          if(cambio!='1'){
                            Preferencias.serie = newValue!;
                            SnackBar snackBar = SnackBar(
                              padding: EdgeInsets.all(20),
                              content: Text(
                                '${cambio}',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Color.fromARGB(255, 224, 96, 113),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }

                        setState(() {
                          
                        });
                      },
                      items: menuItems,
                      elevation: 0,
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      //icon: Icon(Icons.arrow_drop_down),
                      iconDisabledColor: Colors.red,
                      iconEnabledColor: widget.colorPrimary,
                      underline: SizedBox(),
                    ),
                  )),
                )
              ],
            ),
          ),
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
                                        colorPrimary: widget.colorPrimary,
                                        tmp: widget.id_tmp)
                                    : (index == 2)
                                        ? RegistroMetodoPago(colorPrimary: widget.colorPrimary, id_tmp: widget.id_tmp)
                                        : const Text(''),
                            Container(
                              alignment: Alignment.centerRight,
                              child: (index==2)?const Text(''):ElevatedButton.icon(
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
                                        //open = 0;
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
