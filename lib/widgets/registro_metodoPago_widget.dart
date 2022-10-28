import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistroMetodoPago extends StatefulWidget {
  RegistroMetodoPago(
      {Key? key, required this.colorPrimary, required this.id_tmp})
      : super(key: key);
  Color colorPrimary;
  String id_tmp;

  @override
  State<RegistroMetodoPago> createState() => _RegistroMetodoPagoState();
}

class _RegistroMetodoPagoState extends State<RegistroMetodoPago> {
  String initialSerie = '1';
  String initialBanco = '0';
  late TextEditingController _controlPago;
  late TextEditingController _controlReferencia;

  @override
  void initState() {
    // TODO: implement initState
    _controlPago = TextEditingController();
    _controlReferencia = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Metodo = Provider.of<Facturacion>(context);

    _controlPago.text=Metodo.total_fac;

    List<DropdownMenuItem<String>> menuItems = [];
    List<DropdownMenuItem<String>> bancosItems = [];
    if (Metodo.loadMetodo)
      // ignore: curly_braces_in_flow_control_structures
      return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          padding: const EdgeInsets.all(0),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.cyan,
            ),
          ));

    for (var i = 0; i < Metodo.list_metodoPago.length; i++) {
      menuItems.add(DropdownMenuItem(
          value: Metodo.list_metodoPago[i].idMetodo,
          child: Text(
            Metodo.list_metodoPago[i].nombre,
            textAlign: TextAlign.start,
          )));
    }

    bancosItems.clear();
    bancosItems.add(const DropdownMenuItem(
        value: '0',
        child: Text(
          'Selecciona una Cuenta',
          textAlign: TextAlign.start,
        )));
    for (var i = 0; i < Metodo.list_Bancos.length; i++) {
      bancosItems.add(DropdownMenuItem(
          value: Metodo.list_Bancos[i].idBank,
          child: Text(
            Metodo.list_Bancos[i].cuenta,
            textAlign: TextAlign.start,
          )));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey, style: BorderStyle.solid, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton(
                itemHeight: null,
                value: initialSerie,
                isExpanded: true,
                dropdownColor: Color.fromARGB(255, 241, 238, 241),
                onChanged: (String? newValue) async {
                  if (newValue != '1' && newValue != '6' && newValue != '15') {
                    Metodo.bancos();
                  }
                  setState(() {
                    initialSerie = newValue!;
                    initialBanco = '0';
                    _controlPago.text = '';
                    _controlReferencia.text = '';
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
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: TextField(
              controller: _controlPago,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                print(_controlPago.text);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Pago',
              ),
            )),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: ElevatedButton.icon(
                  label: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                      child: Text("Aplicar Pago")),
                  onPressed: () async {
                    if (_controlPago.text == '') {
                      SnackBar snackBar = const SnackBar(
                        padding: EdgeInsets.all(20),
                        content: Text(
                          'Inserta cantidad a pagar',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Color.fromARGB(255, 224, 96, 113),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      var insert = await Metodo.accionesMetodoPAgo(
                          'add',
                          widget.id_tmp,
                          _controlPago.text,
                          initialSerie,
                          initialBanco,
                          _controlReferencia.text);
                      if (insert == '1') {
                        _controlPago.text = '';
                        _controlReferencia.text = '';
                        initialSerie = '1';
                        initialBanco = '0';
                        Metodo.transacciones(widget.id_tmp);
                        setState(() {});
                      } else {
                        SnackBar snackBar = SnackBar(
                          padding: const EdgeInsets.all(20),
                          content: Text(
                            '${insert}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 224, 96, 113),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }

                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: widget.colorPrimary),
                  icon: const Text("")),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        (initialSerie != '1' && initialSerie != '6' && initialSerie != '15')
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Cuenta: ',
                          style: TextStyle(fontSize: 15),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton(
                              itemHeight: null,
                              value: initialBanco,
                              isExpanded: true,
                              dropdownColor: Color.fromARGB(255, 241, 238, 241),
                              onChanged: (String? newValue) async {
                                /*if(newValue!='1' && newValue!='6' && newValue!='15'){
                            Metodo.bancos();
                          }*/
                                setState(() {
                                  initialBanco = newValue!;
                                });
                              },
                              items: bancosItems,
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
                          ),
                        ),
                      ]),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Referencia: ',
                        style: TextStyle(fontSize: 15),
                      ),
                      Expanded(
                          child: TextField(
                        controller: _controlReferencia,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          print(_controlPago.text);
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Insertar No. referencia'),
                      )),
                    ],
                  )
                ],
              )
            : const Text('')
      ],
    );
  }
}
