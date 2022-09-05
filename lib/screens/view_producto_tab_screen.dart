import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/widgets/articulo_horizontal_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh_plus/pull_to_refresh_plus.dart';

import '../models/producto_x_departamento_models.dart';

class ViewProductoTab extends StatefulWidget {
  String id_departamento;
  String id_tmp;
  ViewProductoTab(
      {Key? key, required this.id_departamento, required this.id_tmp})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _viewproductotab();
}

class _viewproductotab extends State<ViewProductoTab> {
  List<Producto> list_producto = [];

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  int i = 0;

  Future<bool> getCursosData({bool isRefresh = false}) async {
    // Read all values
    final empresa = Preferencias.data_empresa;
    i = i + 10;
    print(
        "https://app.gozeri.com/flutter_gozeri/productos_core.php?id_empresa=${empresa}&accion=2&id_categoria=${widget.id_departamento}&producto=${i}");
    final Uri uri = Uri.parse(
        "https://app.gozeri.com/flutter_gozeri/productos_core.php?id_empresa=${empresa}&accion=2&id_categoria=${widget.id_departamento}&producto=${i}");
    final response = await http.get(uri);

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
  Widget build(BuildContext context) {
    return initWidget();
  }

  initWidget() {
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
            header: const WaterDropMaterialHeader(
              color: Colors.white,
              backgroundColor: Colors.cyan,
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
            child: ListView.builder(
              itemCount: list_producto.length,
              itemBuilder: (context, index) {
                final producto = list_producto[index];

                return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ArticleHorizontal(
                        listProd: producto, id_tmp: widget.id_tmp));
              },
            ),
          )),
    );
  }
}
