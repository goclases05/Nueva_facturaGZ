import 'package:factura_gozeri/models/producto_x_departamento_models.dart';
import 'package:factura_gozeri/providers/carshop_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModoVenta1 extends StatefulWidget {
  const ModoVenta1(
      {Key? key,
      required this.colorPrimary,
      required this.listProd,
      required this.id_tmp})
      : super(key: key);
  final Producto listProd;
  final Color colorPrimary;
  final String id_tmp;

  @override
  State<ModoVenta1> createState() => _ModoVenta1State();
}

class _ModoVenta1State extends State<ModoVenta1> {
  final precio_controller_field = TextEditingController();
  final myController = TextEditingController();
  late String? _precio_field = widget.listProd.precio;
  late int _counterValue = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el widget se elimine del árbol de widgets
    // Esto también elimina el listener _printLatestValue
    precio_controller_field.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    precio_controller_field.text = _precio_field.toString();
    precio_controller_field.selection = TextSelection.fromPosition(
        TextPosition(offset: precio_controller_field.text.length));

    myController.text = _counterValue.toString();
    myController.selection = TextSelection.fromPosition(
        TextPosition(offset: myController.text.length));

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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '0.00',
                            //icon: Text(Preferencias.moneda,style:const TextStyle(fontSize: 20,color: Colors.blueGrey))
                          ))
                      : Container(
                          padding: const EdgeInsets.all(3),
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
                      Icons.list,
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
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black45,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (widget.listProd.facturar == '1') {
                                _counterValue--;
                                print(_counterValue);
                                myController.text = _counterValue.toString();
                              } else {
                                if (_counterValue <= 0) {
                                  _counterValue++;
                                  print(_counterValue);
                                  myController.text = _counterValue.toString();
                                } else if (_counterValue > 1) {
                                  _counterValue--;
                                  print(_counterValue);
                                  myController.text = _counterValue.toString();
                                }
                              }

                              myController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: myController.text.length));
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                //color: Theme.of(context).primaryColor,
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15))),
                            child: Icon(
                              Icons.remove,
                              color: widget.colorPrimary,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(vertical: 2),
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: TextField(
                          controller: myController,
                          //initialValue: myController.text,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value == '') {
                              myController.text = value;
                              setState(() {
                                _counterValue = 0;
                              });
                            } else {
                              setState(() {
                                if (widget.listProd.facturar == 1) {
                                  _counterValue = int.parse(value);
                                } else {
                                  final stock_p =
                                      double.parse(widget.listProd.stock)
                                          .round();
                                  if (int.parse(value) <= 1) {
                                    _counterValue = 1;
                                  } else if (double.parse(value) >=
                                      double.parse(widget.listProd.stock)) {
                                    _counterValue = stock_p;
                                  } else {
                                    _counterValue = int.parse(value);
                                  }
                                }

                                /* myController.text = value.toString();
                        // this changes cursor position
                        myController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: myController.text.length));*/
                              });
                            }
                          },
                          /*validator: (value) {
                    /*if (value != null && value.length >= 1) {
                      return null;
                    } else {
                      return 'Inserte un Usuario| Correo ';
                    }*/
                    },*/
                          cursorColor: widget.colorPrimary,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            hintText: "0.00",
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (widget.listProd.facturar == '1') {
                                _counterValue++;
                              } else {
                                print(_counterValue);
                                if (_counterValue >=
                                    int.parse(widget.listProd.stock)) {
                                  _counterValue =
                                      int.parse(widget.listProd.stock);
                                  print(_counterValue);
                                } else {
                                  _counterValue++;
                                  print(_counterValue);
                                }
                              }

                              myController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: myController.text.length));
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                //color: Theme.of(context).primaryColor,
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15))),
                            child: Icon(
                              Icons.add,
                              color: widget.colorPrimary,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ])),
              ],
            )),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
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
                          _counterValue.toString(),
                          (_precio_field.toString() == '')
                              ? _do[0]
                              : _precio_field.toString());
                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      Navigator.pop(context);
                    } else {
                      if (_counterValue > double.parse(widget.listProd.stock)) {
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
                        cart.add(1, widget.listProd.idProd, widget.id_tmp,
                            _counterValue.toString(), _precio_field.toString());
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
      ],
    );
  }
}
