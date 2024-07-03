import 'package:count_stepper/count_stepper.dart';
import 'package:custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:edge_alerts/edge_alerts.dart';
import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/models/producto_x_departamento_models.dart';
import 'package:factura_gozeri/providers/carshop_provider.dart';
import 'package:factura_gozeri/providers/preferencias_art_provider.dart';
import 'package:factura_gozeri/widgets/articulo_sheet_widget.dart';
import 'package:factura_gozeri/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class VistaArticulos extends StatefulWidget {
  VistaArticulos({
    Key? key,
  }) : super(key: key);

  @override
  State<VistaArticulos> createState() => _VistaArticulosState();
}

class _VistaArticulosState extends State<VistaArticulos> {
  int _selectedIndex = 0;
  String _categoriaAct = '0';
  late final Future? myFuture;
  List<Producto> list_producto = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center();
  }
}

class ArticleHorizontal extends StatefulWidget {
  ArticleHorizontal(
      {Key? key,
      required this.listProd,
      required this.id_tmp,
      required this.colorPrimary})
      : super(key: key);
  final Producto listProd;
  final String id_tmp;
  Color colorPrimary;

  @override
  State<ArticleHorizontal> createState() => _ArticleHorizontalState();
}

class _ArticleHorizontalState extends State<ArticleHorizontal> {
  List<String> precios_list = [];
  late int _counterValue = 1;
  String _counterString = '';
  String edit_precio = '0';

  String? _dropdownValue = '';
  int position = 0;

  void customBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.7,
                minChildSize: 0.2,
                maxChildSize: 1,
                builder: (_, controller) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.remove,
                          color: Colors.grey[600],
                          size: 30,
                        ),
                        Expanded(
                            child: /*ListView.builder(
                            controller: controller,
                            itemCount: 1,
                            itemBuilder: (_, index) {
                              return ArticuloSheet(
                                  listProd: widget
                                      .listProd); /*Card(
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text("Element at index($index)"),
                                ),
                              );*/
                            },
                          ),*/
                                SingleChildScrollView(
                                    controller: controller,
                                    child: ArticuloSheet(
                                        listProd: widget.listProd,
                                        colorPrimary: widget.colorPrimary,
                                        id_tmp: widget.id_tmp,
                                        edit_precio: edit_precio))),
                      ],
                    ),
                  );
                  //return ArticuloSheet(listProd: widget.listProd);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  final myController = TextEditingController();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 0), () async {
      final preferencias_art =
          Provider.of<Preferencias_art>(context, listen: false);
      final js = await preferencias_art.preferencias_producto();
      print('dalor ');

      print(js['70']['CONTENIDO']);
      edit_precio = js['70']['CONTENIDO'];
      setState(() {});
    });
    _dropdownValue = "${widget.listProd.precio}";
    _controller.addListener(() {
      _dropdownValue = _controller.text;
    });

    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el widget se elimine del árbol de widgets
    // Esto también elimina el listener _printLatestValue
    myController.dispose();
    _controller.dispose();
    super.dispose();
  }

  _printLatestValue() {
    return 2020;
  }

  double getScreenSize(BuildContext context, double t1, double t2, String area) {
      // Obtenemos el tamaño de la pantalla utilizando MediaQuery
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;

    if(orientation == Orientation.portrait){
      //vertical
      if(area=='h'){
        return size.height * t1;
      }else{
        return size.width*t1;
      }
      
    }else{
      if(area=='h'){
        return size.height * t2;
      }else{
        return size.width*t2;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> _do = []; //= ['One', 'Two', 'Free', 'Four'];

    _controller.text = _dropdownValue!;

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
    myController.text = _counterValue.toString();
    myController.selection = TextSelection.fromPosition(
        TextPosition(offset: myController.text.length));

    _controller.text = _dropdownValue.toString();
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));

    

    return Card(
      elevation: 2,
      color: Colors.white,
      surfaceTintColor:Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisSize:MainAxisSize.min,
        children: [
          Stack(children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  customBottomSheet(context);
                  /*Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context,animation,__){
                        return FadeTransition(
                          opacity: animation,
                          child:DetailsArticle(
                            list_Prod:widget.list_Prod
                          )
                        );
                      }) 
                    );*/
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: FadeInImage(
                                placeholder:
                                    const AssetImage('assets/productos_gz.jpg'),
                                image: NetworkImage(
                                    widget.listProd.url + widget.listProd.foto),
                                //width:MediaQuery.of(context).size.width * 0.25)),
                                height:getScreenSize(context,0.1,0.18,'h'))),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.listProd.producto,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                      letterSpacing: 0,
                                      wordSpacing: 0,
                                      fontSize: 15),
                                ),
                                /*Text(
                                  widget.listProd.descBreve,0.00
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black45),
                                ),*/
                                Row(
                                  children: [
                                    Text(
                                      "${Preferencias.moneda}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: widget.colorPrimary),
                                    ),
                                    Expanded(
                                      child: (edit_precio == '0')
                                          ? DropdownButton<String>(
                                              isExpanded: true,
                                              hint: Text("0.00"),
                                              items: _do.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                /*(position == 0) ? position : position++;
                                            setState(() {});*/
                                                return DropdownMenuItem<String>(
                                                  value:
                                                      value, //position.toString(),
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              value: (_dropdownValue == '')
                                                  ? _do[0]
                                                  : _dropdownValue,
                                              onChanged: ((value) =>
                                                  setState(() {
                                                    _dropdownValue = value;
                                                  })))
                                          : TextField(
                                              textAlign: TextAlign.left,
                                              keyboardType:
                                                  TextInputType.number,
                                              cursorColor: widget.colorPrimary,
                                              decoration: const InputDecoration(
                                                fillColor: Colors.white,
                                                hintText: "0.00",
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                              ),
                                              controller: _controller,
                                              onChanged: (value) {},
                                            ),
                                    )
                                  ],
                                ),
                                //const SizedBox(height: 10,),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 0,
                left: 5,
                child: Chip(
                  backgroundColor: (widget.listProd.modo_venta == '2' ||
                          widget.listProd.stock.contains(RegExp('-'), 0) ||
                          widget.listProd.stock.contains(RegExp('.'), 0))
                      ? const Color.fromARGB(243, 200, 230, 201)
                      : (int.parse(widget.listProd.stock) <= 0)
                          ? const Color.fromARGB(243, 240, 144, 132)
                          : const Color.fromARGB(243, 200, 230, 201),
                  label: Text(
                    'Stock: ${widget.listProd.stock}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                )
                /*Container(
                  padding:const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 134, 185, 135).withOpacity(0.9),
                    shape:BoxShape.circle,
                  ),
                  child:const Icon(Icons.favorite,
                    color: Colors.red,
                  ),
                )*/
                )
          ]),
          Container(
            padding: const EdgeInsets.only(bottom: 10, right: 10),
            width: double.infinity,
            child: (widget.listProd.modo_venta == '2')
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                          icon: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            customBottomSheet(context);
                          },
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: widget.colorPrimary),
                          label: const Text("Agregar al carrito"))
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            //color: Theme.of(context).primaryColor,
                            color: Colors.blueGrey[100],
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          decoration: BoxDecoration(
                              //color: Theme.of(context).primaryColor,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (widget.listProd.facturar == '1') {
                                      _counterValue--;
                                      print(_counterValue);
                                      myController.text =
                                          _counterValue.toString();
                                    } else {
                                      if (_counterValue <= 0) {
                                        _counterValue++;
                                        print(_counterValue);
                                        myController.text =
                                            _counterValue.toString();
                                      } else if (_counterValue > 1) {
                                        _counterValue--;
                                        print(_counterValue);
                                        myController.text =
                                            _counterValue.toString();
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
                                        _counterString = value;
                                        _counterValue = 0;
                                      });
                                    } else {
                                      setState(() {
                                        _counterString = value;
                                        final stock_p =
                                            double.parse(widget.listProd.stock)
                                                .round();
                                        print(_counterString);
                                        if (widget.listProd.facturar == 1) {
                                          _counterValue = int.parse(value);
                                        } else {
                                          if (int.parse(value) <= 1) {
                                            _counterValue = 1;
                                          } else if (int.parse(value) >=
                                              int.parse(
                                                  widget.listProd.stock)) {
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
                              GestureDetector(
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
                            ],
                          ),
                        ),
                      ),
                      Consumer<Cart>(builder: (context, cart, child) {
                        if (cart.loading_cart) {
                          return TextButton(
                            onPressed: () => false,
                            child: Container(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(widget.colorPrimary),
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            if (widget.listProd.facturar == '1') {
                              /*final snackBar = SnackBar(
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                margin: EdgeInsets.only(
                                    bottom: 100, right: 20, left: 20),
                                padding: EdgeInsets.all(20),
                                content: const Text(
                                  'Item agregado al carrito!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                              );*/
                              cart.add(
                                  _counterValue,
                                  widget.listProd.idProd,
                                  widget.id_tmp,
                                  _counterValue.toString(),
                                  (_dropdownValue.toString() == '')
                                      ? _do[0]
                                      : _dropdownValue.toString());
                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              /*ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);*/
                              edgeAlert(context,
                                  description: 'Item agregado al carrito!',
                                  gravity: Gravity.top,
                                  backgroundColor:
                                      Color.fromARGB(255, 81, 131, 83));
                            } else {
                              if (_counterValue >
                                  int.parse(widget.listProd.stock)) {
                                /*final snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  margin: const EdgeInsets.only(
                                      bottom: 100, right: 20, left: 20),
                                  padding: const EdgeInsets.all(20),
                                  content: const Text(
                                    'Articulo sin Stock!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                );*/

                                // Find the ScaffoldMessenger in the widget tree
                                // and use it to show a SnackBar.
                                /*ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);*/
                                edgeAlert(context,
                                    title: 'Articulo sin Stock!',
                                    gravity: Gravity.top,
                                    backgroundColor: Colors.redAccent);
                              } else {
                                /*final snackBar = SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  margin: const EdgeInsets.only(
                                      bottom: 100, right: 20, left: 20),
                                  padding: const EdgeInsets.all(20),
                                  content: const Text(
                                    'Item agregado al carrito!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                );

                                // Find the ScaffoldMessenger in the widget tree
                                // and use it to show a SnackBar.
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);*/
                                edgeAlert(context,
                                    description: 'Item agregado al carrito!',
                                    gravity: Gravity.top,
                                    backgroundColor:
                                        Color.fromARGB(255, 81, 131, 83));
                                cart.add(
                                    _counterValue,
                                    widget.listProd.idProd,
                                    widget.id_tmp,
                                    _counterValue.toString(),
                                    _dropdownValue.toString());
                              }
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                //color: Theme.of(context).primaryColor,
                                color: widget.colorPrimary,
                                borderRadius: BorderRadius.circular(15)),
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
          ),
          /*const Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.only(right: 10,bottom: 10,top: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.cyan.shade700,
                    padding:const EdgeInsets.all(5),
                  ),
                  onPressed: () {
                      // Respond to button press
                  },
                  child:const Text('  Ver Detalles  ',style: TextStyle(
                    color: Colors.white
                  ),),
                ),
                const SizedBox(width: 5,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow.shade800,
                    padding:const EdgeInsets.all(5),
                  ),
                  onPressed: () {
                      // Respond to button press
                  },
                  child:const Text('Agregar al Carrito',style: TextStyle(
                    color: Colors.white
                  ),),
                )
              ],
            ),
          )*/
        ],
      ),
    );
  }
}
