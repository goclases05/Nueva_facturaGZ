import 'package:edge_alerts/edge_alerts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/factura_provider.dart';

class CreateClienteWidget extends StatefulWidget {
  CreateClienteWidget({Key? key, required this.colorPrimary, required this.tmp})
      : super(key: key);
  Color colorPrimary;
  String tmp;

  @override
  State<CreateClienteWidget> createState() => _CreateClienteWidgetState();
}

class _CreateClienteWidgetState extends State<CreateClienteWidget> {
  final nombre_controller = TextEditingController();
  final apellido_controller = TextEditingController();
  final nit_controller = TextEditingController(text: 'CF');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nombre_controller.dispose();
    apellido_controller.dispose();
    nit_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final facturaService = Provider.of<Facturacion>(context, listen: false);
    nombre_controller.selection = TextSelection.fromPosition(
        TextPosition(offset: nombre_controller.text.length));

    apellido_controller.selection = TextSelection.fromPosition(
        TextPosition(offset: apellido_controller.text.length));

    nit_controller.selection = TextSelection.fromPosition(
        TextPosition(offset: nit_controller.text.length));

    return Container(
      width: MediaQuery.of(context).size.width * 1,
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Registrar Cliente',
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nombre *',
                    style: TextStyle(
                        color: Color.fromARGB(255, 162, 174, 194),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  TextField(
                      controller: nombre_controller,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          nombre_controller.text = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'escribir nombre del cliente',
                        //icon: Text(Preferencias.moneda,style:const TextStyle(fontSize: 20,color: Colors.blueGrey))
                      )),
                  const Text(
                    'Apellido',
                    style: TextStyle(
                        color: Color.fromARGB(255, 162, 174, 194),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  TextField(
                      controller: apellido_controller,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          apellido_controller.text = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'escribir apellido del cliente',
                        //icon: Text(Preferencias.moneda,style:const TextStyle(fontSize: 20,color: Colors.blueGrey))
                      )),
                  const Text(
                    'NIT',
                    style: TextStyle(
                        color: Color.fromARGB(255, 162, 174, 194),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  TextField(
                      controller: nit_controller,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          nit_controller.text = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'escribir NIT del cliente',
                        //icon: Text(Preferencias.moneda,style:const TextStyle(fontSize: 20,color: Colors.blueGrey))
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextButton.icon(
                        onPressed: () async {
                          if (nombre_controller.text == '') {
                            edgeAlert(context,
                                description: 'Error: Nombre Requerido',
                                gravity: Gravity.top,
                                backgroundColor: Colors.redAccent);
                          } else {
                            await facturaService.create_cliente(
                                nombre_controller.text,
                                apellido_controller.text,
                                nit_controller.text,
                                widget.tmp);
                            Navigator.of(context, rootNavigator: true).pop();
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.person),
                        label: const Text('Agregar cliente'),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: widget.colorPrimary,
                        ),
                      )),
                  SizedBox(
                    height: 200,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
