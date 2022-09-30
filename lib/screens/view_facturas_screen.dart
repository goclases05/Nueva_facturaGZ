import 'package:factura_gozeri/global/globals.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_plus/pull_to_refresh_plus.dart';

class ViewFacturas extends StatefulWidget {
  ViewFacturas({Key? key, required this.colorPrimary}) : super(key: key);
  Color colorPrimary;

  @override
  State<ViewFacturas> createState() => _ViewFacturasState();
}

class _ViewFacturasState extends State<ViewFacturas> {
  List<String> list_producto = [];

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  int i = 0;

  Future<bool> getCursosData({bool isRefresh = false}) async {
    // Read all values
    final empresa = Preferencias.data_empresa;
    list_producto=[
      'María Magadalena Zepeda Rivera de Castro',
      'JOSE ALEJANDRO ROSAL GARCIA',
      'ALBERTO EMANUEL JIMÉNEZ FERNÁNDEZ',
      'Antonio Valenzuela',
      'Byron De jesús Maldonado',
      'Byron De jesús Maldonado',
      'Ivan Enrique Culajay Reyes',
      'ARAUKO SOLUTIONS SOCIEDAD ANONIMA'
    ];
    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child:Scaffold(
        body: SmartRefresher(
            physics: const BouncingScrollPhysics(),
            header: WaterDropMaterialHeader(
              distance:30,
              color: Colors.white,
              backgroundColor: widget.colorPrimary,
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
            child: (list_producto.length>0)?
            ListView.builder(
              scrollDirection : Axis.vertical,
              shrinkWrap:true,
              itemCount: list_producto.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(list_producto[index]),
                );
              }
            ):const Center(child:Text('Sin data'))
        ),
      )
    );
  }
}