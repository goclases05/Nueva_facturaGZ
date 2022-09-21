import 'package:factura_gozeri/models/producto_x_departamento_models.dart';
import 'package:factura_gozeri/providers/carshop_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModoVenta2 extends StatefulWidget {
  ModoVenta2(
      {Key? key,
      required this.colorPrimary,
      required this.listProd,
      required this.id_tmp})
      : super(key: key);
  Color colorPrimary;
  final Producto listProd;
  final String id_tmp;

  @override
  State<ModoVenta2> createState() => _ModoVenta2State();
}

class _ModoVenta2State extends State<ModoVenta2> {
  final precio_controller_field = TextEditingController();
  final cantidad_controller_field = TextEditingController();
  final monto_controller_field = TextEditingController();
  late String? _precio_field = widget.listProd.precio;
  late String _cantidad_field = '0';
  late String _monto_field = '0';

  @override
  void initState() {
    super.initState();

    //myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el widget se elimine del árbol de widgets
    // Esto también elimina el listener _printLatestValue
    precio_controller_field.dispose();
    cantidad_controller_field.dispose();
    monto_controller_field.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    precio_controller_field.text = _precio_field.toString();
    precio_controller_field.selection = TextSelection.fromPosition(
        TextPosition(offset: precio_controller_field.text.length));

    //cantidad controller
    cantidad_controller_field.text = _cantidad_field.toString();
    cantidad_controller_field.selection = TextSelection.fromPosition(
        TextPosition(offset: cantidad_controller_field.text.length));

    //monto controller
    //cantidad controller
    monto_controller_field.text = _monto_field.toString();
    monto_controller_field.selection = TextSelection.fromPosition(
        TextPosition(offset: monto_controller_field.text.length));

    //select de precios
    List<String> _do = []; //= ['One', 'Two', 'Free', 'Four'];

    if (_do.contains(widget.listProd.precio) == false) {
      _do.add("${widget.listProd.precio}");
    }
    if (_do.contains(widget.listProd.precio_2) == false) {
      _do.add("${widget.listProd.precio_2}");
    }
    if (_do.contains(widget.listProd.precio_3) == false) {
      _do.add("${widget.listProd.precio_3}");
    }
    if (_do.contains(widget.listProd.precio_4) == false) {
      _do.add("${widget.listProd.precio_4}");
    }

    return Column(
      /*mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,*/
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.paid,
                      color: widget.colorPrimary,
                      size: 23,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Precio',
                      style: TextStyle(
                          color: Color.fromARGB(255, 162, 174, 194),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  // ignore: prefer_const_constructors
                  child: (1 == 2)
                      ? TextField(
                          controller: precio_controller_field,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _precio_field = value;

                              if (_precio_field == '') {
                              } else {
                                if (_monto_field == '' &&
                                    _cantidad_field != '') {
                                  double total_mont =
                                      double.parse(_precio_field!) *
                                          double.parse(_cantidad_field);
                                  _monto_field = total_mont.toString();
                                } else if (_monto_field != '' &&
                                        _cantidad_field == '' ||
                                    (_monto_field != '' &&
                                        _cantidad_field != '')) {
                                  double total_cant =
                                      double.parse(_monto_field) /
                                          double.parse(_precio_field!);
                                  _cantidad_field = total_cant.toString();
                                }
                              }
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '0.00',
                            //icon: Text(Preferencias.moneda,style:const TextStyle(fontSize: 20,color: Colors.blueGrey))
                          ))
                      : Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black45,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: DropdownButton<String>(
                              dropdownColor: Colors.blueGrey[50],
                              isExpanded: true,
                              hint: const Text("0.00"),
                              items: _do.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value: (_precio_field == '')
                                  ? _do[0]
                                  : _precio_field,
                              onChanged: ((value) => setState(() {
                                    _precio_field = value;
                                    if (_monto_field == '' &&
                                        _cantidad_field != '') {
                                      double total_mont =
                                          double.parse(_precio_field!) *
                                              double.parse(_cantidad_field);
                                      _monto_field = total_mont.toString();
                                    } else if (_monto_field != '' &&
                                            _cantidad_field == '' ||
                                        (_monto_field != '' &&
                                            _cantidad_field != '')) {
                                      double total_cant =
                                          double.parse(_monto_field) /
                                              double.parse(_precio_field!);
                                      _cantidad_field = total_cant.toString();
                                    }
                                  }))),
                        ),
                ),
              ],
            )),
            Expanded(
                child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.list_alt_rounded,
                      color: widget.colorPrimary,
                      size: 23,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Cantidad',
                      style: TextStyle(
                          color: Color.fromARGB(255, 162, 174, 194),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  // ignore: prefer_const_constructors
                  child: TextField(
                      controller: cantidad_controller_field,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _cantidad_field = value;
                          double total_monto = 0;
                          if ((_precio_field == '' && _cantidad_field == '') ||
                              _precio_field == '' ||
                              _cantidad_field == '') {
                          } else {
                            total_monto = double.parse(_precio_field!) *
                                double.parse(_cantidad_field);
                          }
                          _monto_field = total_monto.toString();
                          monto_controller_field.text = _monto_field.toString();
                          cantidad_controller_field.text =
                              _cantidad_field.toString();
                        });
                        if (_cantidad_field == '') {
                          print('sin cantidad');
                        } else {
                          print(_cantidad_field);
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '0.00',
                        //icon: Text(Preferencias.moneda,style:const TextStyle(fontSize: 20,color: Colors.blueGrey))
                      )),
                ),
              ],
            )),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Icon(
              Icons.payments,
              color: widget.colorPrimary,
              size: 23,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              'Monto',
              style: TextStyle(
                  color: Color.fromARGB(255, 162, 174, 194),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        Container(
          child: TextField(
              controller: monto_controller_field,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _monto_field = value;

                  double total_cantidad = 0;
                  if ((_precio_field == '' && _monto_field == '') ||
                      _precio_field == '' ||
                      _monto_field == '') {
                  } else {
                    total_cantidad = double.parse(_monto_field) /
                        double.parse(_precio_field!);
                  }
                  _cantidad_field = total_cantidad.toString();
                  monto_controller_field.text = _monto_field.toString();
                  cantidad_controller_field.text = _cantidad_field.toString();
                });
                if (_cantidad_field == '') {
                  print('sin cantidad');
                } else {
                  print(_cantidad_field);
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '0.00',
              )),
        ),
        const SizedBox(height: 10),

        ///agregar al carrito de compras
        Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Consumer<Cart>(
              builder: (context, cart, child) {
                return TextButton.icon(
                  onPressed: () {
                    if (widget.listProd.facturar == '1') {
                      const snackBar = SnackBar(
                        padding: EdgeInsets.all(20),
                        content: Text(
                          'Item agregado al carrito!',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                      );
                      cart.add(
                          1,
                          widget.listProd.idProd,
                          widget.id_tmp,
                          _cantidad_field.toString(),
                          (_precio_field.toString() == '')
                              ? _do[0]
                              : _precio_field.toString());
                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      Navigator.pop(context);
                    } else {
                      if (double.parse(_cantidad_field) >
                          double.parse(widget.listProd.stock)) {
                        const snackBar = SnackBar(
                          padding: EdgeInsets.all(20),
                          content: Text(
                            'Articulo sin Stock!',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        );

                        // Find the ScaffoldMessenger in the widget tree
                        // and use it to show a SnackBar.
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        const snackBar = SnackBar(
                          padding: EdgeInsets.all(20),
                          content: Text(
                            'Item agregado al carrito!',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                        );

                        // Find the ScaffoldMessenger in the widget tree
                        // and use it to show a SnackBar.
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        cart.add(
                            int.parse(_cantidad_field),
                            widget.listProd.idProd,
                            widget.id_tmp,
                            _cantidad_field.toString(),
                            _precio_field.toString());
                        Navigator.pop(context);
                      }
                    }
                  },
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text('Agregar a la Lista'),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: widget.colorPrimary,
                  ),
                );
              },
            ))

        ///agregar al carrito de compras
      ],
    );
  }
}
