import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:factura_gozeri/models/producto_x_departamento_models.dart';
import 'package:factura_gozeri/providers/items_provider.dart';
import 'package:factura_gozeri/providers/seattings_provider.dart';
import 'package:factura_gozeri/widgets/articulo_horizontal_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemsSearch extends SearchDelegate {
  static String _id_tmp = '';

  static set id_tmp(String id_tmp) {
    _id_tmp = id_tmp;
  }

  static String get id_tmp {
    return _id_tmp;
  }

  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => 'Buscar Item';

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return buildSuggestions(context);
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
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final settings = Provider.of<settingsProvider>(context, listen: false);
    if (query.isEmpty) {
      return Container(
        child: Center(
          child: Icon(
            Icons.widgets_outlined,
            color: Color.fromARGB(255, 216, 216, 216),
            size: 130,
          ),
        ),
      );
    }

    //final itm=Provider.of<ItemsSearch>(context);
    final itm = Provider.of<ItemProvider>(context);
    itm.getSuggestionsByQuery(query);
    /*return FutureBuilder(
      future: itm.searchItem(query),
      builder: (_, AsyncSnapshot<List<Producto>> snapshot) {
        if(!snapshot.hasData)
          return Container(
            child: const Center(
              child: Icon(Icons.search,color: Colors.cyan,size: 130,),
            ),
          );
        
        final list_items=snapshot.data!;
        return ListView.builder(
            itemCount: list_items.length,
            itemBuilder: (context, index) {
              final producto = list_items[index];
              return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ArticleHorizontal(
                      listProd: producto, id_tmp: _id_tmp));
            },
          );
        
      }
    );*/
    Color colorPrimary = settings.colorPrimary;
    return StreamBuilder(
        stream: itm.suggestionsStrem,
        builder: (_, AsyncSnapshot<List<Producto>> snapshot) {
          if (!snapshot.hasData)
            return Container(
              child: Center(
                child: Icon(
                  Icons.widgets_outlined,
                  color: Color.fromARGB(255, 216, 216, 216),
                  size: 130,
                ),
              ),
            );

          final list_items = snapshot.data!;
          return ListView.builder(
            itemCount: list_items.length,
            itemBuilder: (context, index) {
              final producto = list_items[index];
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: getScreenSize(context, 0.01, 0.1, 'w')),
                  child: ArticleHorizontal(
                    listProd: producto,
                    id_tmp: _id_tmp,
                    colorPrimary: colorPrimary,
                  ));
            },
          );
        });
  }
}
