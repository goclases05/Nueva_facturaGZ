import 'package:count_stepper/count_stepper.dart';
import 'package:custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/models/producto_x_departamento_models.dart';
import 'package:factura_gozeri/providers/carshop_provider.dart';
import 'package:flutter/material.dart';
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
  ArticleHorizontal({Key? key, required this.listProd, required this.id_tmp})
      : super(key: key);
  final Producto listProd;
  final String id_tmp;

  @override
  State<ArticleHorizontal> createState() => _ArticleHorizontalState();
}


class _ArticleHorizontalState extends State<ArticleHorizontal> {
  List<String> precios_list = [];
  late int _counterValue = 1;

  String? _dropdownValue = '';
  int position = 0;

  void customBottomSheet(BuildContext context) {
    SlideDialog.showSlideDialog(
      context: context,
      backgroundColor: Colors.white,
      pillColor: Colors.yellow,
      transitionDuration: Duration(milliseconds: 200),
      child: Text('Your code'),
    );
  }
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el widget se elimine del árbol de widgets
    // Esto también elimina el listener _printLatestValue
    myController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    return 2020;
  }


  @override
  Widget build(BuildContext context) {
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

    /*_do.add("${widget.listProd.precio}");
    _do.add("${widget.listProd.precio_2}");
    _do.add("${widget.listProd.precio_3}");
    _do.add("${widget.listProd.precio_4}");*/
    /*_do = [
      "${widget.listProd.precio}",
      "${widget.listProd.precio_2}",
      "${widget.listProd.precio_3}",
      "${widget.listProd.precio_4}"
    ];*/
    /*_dropdownValue =
        (widget.listProd.precio.isEmpty) ? "0.00" : widget.listProd.precio;*/
    //_itemselect = precios_list[0];
    myController.text=_counterValue.toString();
    myController.selection = TextSelection.fromPosition(
      TextPosition(offset: myController.text.length)
    ); 
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
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
                  children: [
                    const SizedBox(height: 15,),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          
                          child: Hero(
                              tag: 'List_${widget.listProd.idProd}',
                              child: /*Image.network(
                                  widget.listProd.url + widget.listProd.foto,
                                  width: MediaQuery.of(context).size.width * 0.3))*/
                                  FadeInImage(
                                    placeholder:const AssetImage('assets/productos_gz.jpg'), 
                                    image: NetworkImage(widget.listProd.url + widget.listProd.foto),
                                    width: MediaQuery.of(context).size.width * 0.3
                                  ),
                          )     
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
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
                                  widget.listProd.descBreve,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black45),
                                ),*/
                                Row(
                                  children: [
                                    Text(
                                      "${Preferencias.moneda}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 4, 146, 165)),
                                    ),
                                    Expanded(
                                      child: DropdownButton<String>(
                                          isExpanded: true,
                                          hint: Text("0.00"),
                                          items: _do.map<DropdownMenuItem<String>>(
                                              (String value) {
                                            /*(position == 0) ? position : position++;
                                            setState(() {});*/
                                            return DropdownMenuItem<String>(
                                              value: value, //position.toString(),
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          value: (_dropdownValue == '')
                                              ? _do[0]
                                              : _dropdownValue,
                                          onChanged: ((value) => setState(() {
                                                _dropdownValue = value;
                                              }))),
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
                  backgroundColor: Color.fromARGB(243, 200, 230, 201),
                  label: Text(
                    'Stock: ${widget.listProd.stock}',
                    style: TextStyle(color: Colors.white),
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 10,
                ),
               /* Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15)),
                  child: CountStepper(
                    iconDecrement: Icon(
                      Icons.remove,
                      color: Colors.red[100],
                    ),
                    iconIncrement: Icon(
                      Icons.add,
                      color: Colors.cyan[700],
                    ),
                    iconColor: Colors.cyan[700],
                    defaultValue: _counterValue,
                    max: 10,
                    min: 1,
                    iconDecrementColor: Colors.cyan[700],
                    splashRadius: 25,
                    onPressed: (value) {
                      setState(() {
                        _counterValue = value;
                      });
                    },
                  ),
                ),*/
                Container(
                  padding: EdgeInsets.only(left: 4,right: 4),
                  decoration: BoxDecoration(
                      //color: Theme.of(context).primaryColor,
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            print(_counterValue);
                            if(_counterValue<=0){
                              _counterValue++;
                              print(_counterValue);
                              myController.text=_counterValue.toString();
                            }else if(_counterValue>1){
                              _counterValue--;
                              print(_counterValue);
                              myController.text=_counterValue.toString();
                            }
                            myController.selection = TextSelection.fromPosition(
                              TextPosition(offset: myController.text.length)
                            ); 
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              //color: Theme.of(context).primaryColor,
                              color: Colors.red[400],
                              borderRadius:const BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15))
                          ),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),

                      Container(
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(vertical: 2),
                        width: MediaQuery.of(context).size.width*0.2,
                        child: TextField(
                          controller: myController,
                          //initialValue: myController.text,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.phone,
                          onChanged:(value){
                            print(value);
                            setState(() {
                              myController.text = value; 
                              // this changes cursor position 
                              myController.selection = TextSelection.fromPosition(
                                TextPosition(offset: myController.text.length)
                              ); 
                              setState(() {});

                            });
                            
                          },
                          /*validator: (value) {
                            /*if (value != null && value.length >= 1) {
                              return null;
                            } else {
                              return 'Inserte un Usuario| Correo ';
                            }*/
                          },*/
                          cursorColor: Colors.cyan,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            hintText: "0.00",
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            print(_counterValue);
                            if(_counterValue>=int.parse(widget.listProd.stock)){
                              _counterValue=int.parse(widget.listProd.stock);
                              print(_counterValue);
                            }else{
                              _counterValue++;
                              print(_counterValue);
                            }
                            myController.selection = TextSelection.fromPosition(
                              TextPosition(offset: myController.text.length)
                            ); 
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              //color: Theme.of(context).primaryColor,
                              color: Colors.green[400],
                              borderRadius:const BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15))
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer<Cart>(builder: (context, cart, child) {
                  return GestureDetector(
                    onTap: () {
                      cart.add(
                          _counterValue, widget.listProd.idProd, widget.id_tmp);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          //color: Theme.of(context).primaryColor,
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(15)),
                      child: const Icon(
                        Icons.add_shopping_cart,
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
