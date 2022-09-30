import 'package:factura_gozeri/screens/screens.dart';
import 'package:flutter/material.dart';
class TabsFacturacion extends StatelessWidget {
  TabsFacturacion({Key? key, required this.colorPrimary}) : super(key: key);
  Color colorPrimary;

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;

    List<Tab> _tabs = [];
    List<Widget> _views = [];

    _tabs=[
      Tab(
        text: 'Emitidas',
      ),
      Tab(
        text: 'Pendientes',
      )
    ];

    _views=[
      ViewFacturas(colorPrimary: colorPrimary,),
      ViewFacturas(colorPrimary: colorPrimary,)
    ];

    return Stack(
      children:[
        DefaultTabController(
          length: _tabs.length,
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.white,
              title: Text('Historial de Facturas'),
                backgroundColor: this.colorPrimary,
                elevation: 0,
                actions: [
                  /*CircleAvatar(
                    backgroundColor: Colors.white38,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.print),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),*/
                  CircleAvatar(
                      backgroundColor: Colors.white38,
                      child: PopupMenuButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          // Callback that sets the selected popup menu item.
                          onSelected: (value) {
                            
                          },
                          itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry>[
                              const PopupMenuItem(
                                value: "Escritorio",
                                child: ListTile(
                                  title: Text("Menu Principal"),
                                  trailing: Icon(
                                    Icons.home,
                                  ),
                                ),
                              ),
                              const PopupMenuItem(
                                value: "settings",
                                child: ListTile(
                                  title: Text("Ajustes"),
                                  trailing: Icon(
                                    Icons.settings,
                                  ),
                                ),
                              )
                            ])),
                  const SizedBox(
                    width: 20,
                  ),
                ],
                bottom: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Color.fromARGB(255, 219, 219, 219),
                  isScrollable: false,
                  tabs: _tabs,
                ),
              ),
              body:TabBarView(
                children: _views,
              )
          ),
        ),
        Positioned(
          bottom: 30,
          right: 30,
          child: FloatingActionButton(
            onPressed: (){},
            elevation: 50.0,
            backgroundColor: this.colorPrimary,
            child: const Icon(Icons.add,color: Colors.white,),
          ),
        )
      ]
    );
  }
}

