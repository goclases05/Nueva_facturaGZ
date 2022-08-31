import 'package:count_stepper/count_stepper.dart';
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
  const ArticleHorizontal(
      {Key? key, required this.listProd, required this.id_tmp})
      : super(key: key);
  final Producto listProd;
  final String id_tmp;

  @override
  State<ArticleHorizontal> createState() => _ArticleHorizontalState();
}

class _ArticleHorizontalState extends State<ArticleHorizontal> {
  late int _counterValue = 1;

  @override
  Widget build(BuildContext context) {
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
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Hero(
                          tag: 'List_${widget.listProd.idProd}',
                          child: Image.network(
                              widget.listProd.url + widget.listProd.foto,
                              width: MediaQuery.of(context).size.width * 0.3)),
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
                                  height: 1.5,
                                  fontSize: 18),
                            ),
                            Text(
                              widget.listProd.descBreve,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black45),
                            ),
                            Text(
                              widget.listProd.precio,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 4, 146, 165)),
                            ),
                            //const SizedBox(height: 10,),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            /*Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding:const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape:BoxShape.circle,
                  ),
                  child:const Icon(Icons.favorite,
                    color: Colors.red,
                  ),
                )
              )*/
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
                Container(
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
                ),
                Consumer<Cart>(builder: (context, cart, child) {
                  return GestureDetector(
                    onTap: () {
                      cart.add(
                          _counterValue, widget.listProd.idProd, widget.id_tmp);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(10),
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
