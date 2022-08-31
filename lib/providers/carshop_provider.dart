import 'package:factura_gozeri/models/producto_x_departamento_models.dart';
import 'package:flutter/material.dart';

class Cart with ChangeNotifier{
  List<Producto> _list_producto=[];
  int cantidad=0;
  double _price=0.0;

  void add(int cantidad_p, String item){
    //_list_producto.add(item);
    print(item);
    print(cantidad_p);
    cantidad=cantidad+cantidad_p;
    notifyListeners();

  }
  int get count{
    //return _list_producto.length;
    return cantidad;
  }


  
}