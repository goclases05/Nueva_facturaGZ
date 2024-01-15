import 'dart:convert';

import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/providers/preferencias_art_provider.dart';
import 'package:factura_gozeri/widgets/articulo_horizontal_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_plus/pull_to_refresh_plus.dart';

import '../models/producto_x_departamento_models.dart';

class ViewProductoTab extends StatefulWidget {
  String id_departamento;
  String id_tmp;
  Color colPrimary;
  ViewProductoTab(
      {Key? key,
      required this.id_departamento,
      required this.id_tmp,
      required this.colPrimary})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _viewproductotab();
}

class _viewproductotab extends State<ViewProductoTab> {
  List<Producto> list_producto = [];
  String edit_precio = '0';

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  int i = 0;

  Future<bool> getCursosData({bool isRefresh = false}) async {
    // Read all values
    final empresa = Preferencias.data_empresa;
    final id_usuario = Preferencias.data_id;

    if (isRefresh) {
      i = 0;
    }

    print(
        "https://app.gozeri.com/versiones/v1.5.5/productos_core.php?id_empresa=${empresa}&accion=2&id_categoria=${widget.id_departamento}&producto=${i}&usuario=${id_usuario}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/versiones/v1.5.5/productos_core.php?id_empresa=${empresa}&accion=2&id_categoria=${widget.id_departamento}&producto=${i}&usuario=${id_usuario}");
    final response = await http.get(uri);
    i = i + 10;
    if (response.statusCode == 200) {
      final result = ProductosDepartamento.fromJson(response.body);
      //print(response.body);
      if (isRefresh) {
        list_producto = result.productos;
      } else {
        list_producto.addAll(result.productos);
      }

      final totalProductos = result.total;

      if (totalProductos == 0) {
        refreshController.loadNoData();
        return false;
      } else {
        setState(() {});
        return true;
      }
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(milliseconds: 0), () async {
      final preferencias_art =
          Provider.of<Preferencias_art>(context, listen: false);
      final js = await preferencias_art.preferencias_producto();
      print('dalor ');

      print(js['70']['CONTENIDO']);
      edit_precio = js['70']['CONTENIDO'];
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return initWidget(edit_precio);
  }

  initWidget(String edit_precio) {
    return Container(
      /*decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.cyan,
            Colors.cyan,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
          ],
        ),
      ),*/
      color: Colors.grey[100],
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SmartRefresher(
            physics: const BouncingScrollPhysics(),
            header: WaterDropMaterialHeader(
              distance: 30,
              color: Colors.white,
              backgroundColor: widget.colPrimary,
            ),
            controller: refreshController,
            enablePullUp: true,
            onRefresh: () async {
              final result = await getCursosData(isRefresh: true);
              if (result) {
                refreshController.refreshCompleted();
              } else {
                refreshController.refreshFailed();
              }
            },
            onLoading: () async {
              final result = await getCursosData();
              if (result) {
                refreshController.loadComplete();
              } else {
                refreshController.loadFailed();
              }
            },
            child: (list_producto.length == 0)
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/data_null.png'),
                          const Text("No se encontraron datos relacionados")
                        ]),
                  )
                : ListView.builder(
                    itemCount: list_producto.length,
                    itemBuilder: (context, index) {
                      final producto = list_producto[index];
                      final List<String> list = [
                        producto.precio,
                        producto.precio_2,
                        producto.precio_3,
                        producto.precio_4,
                      ];
                      return Padding(
                          padding: const EdgeInsets.all(5),
                          child: ArticleHorizontal(
                            listProd: producto,
                            id_tmp: widget.id_tmp,
                            colorPrimary: widget.colPrimary,
                          ));
                    },
                  ),
          )),
    );
  }
}
