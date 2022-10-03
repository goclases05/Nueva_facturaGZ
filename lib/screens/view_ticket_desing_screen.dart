import 'package:factura_gozeri/global/globals.dart';
import 'package:flutter/material.dart';

class ViewTicket extends StatelessWidget {
  ViewTicket({Key? key, required this.colorPrimary}) : super(key: key);
  Color colorPrimary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: colorPrimary,
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Text('Factura', style: TextStyle(color: Colors.white)),
            actions: [
              CircleAvatar(
                backgroundColor: Colors.white38,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.print),
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ]),
        bottomSheet: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 1,
          child: TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: colorPrimary,
            ),
            label: const Text(
              'Imprimir Factura',
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(
              Icons.print,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(
                      width: 2,
                      color: const Color.fromARGB(255, 182, 182, 182),
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(5)),
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                children: [
                  FadeInImage(
                      width: MediaQuery.of(context).size.width * 0.3,
                      placeholder: AssetImage('assets/productos_gz.jpg'),
                      image: NetworkImage(Preferencias.foto_empresa))
                ],
              ),
            )
          ]),
        ));
  }
}
