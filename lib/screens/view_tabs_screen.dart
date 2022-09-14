import 'package:factura_gozeri/print/print_print.dart';
import 'package:factura_gozeri/search/items_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:factura_gozeri/providers/carshop_provider.dart';
import 'package:factura_gozeri/screens/screens.dart';
import 'package:factura_gozeri/services/services.dart';

class ViewTabsScreen extends StatefulWidget {
  const ViewTabsScreen({Key? key, required this.id_tmp, required this.clave})
      : super(key: key);
  final id_tmp;
  final clave;
  @override
  State<ViewTabsScreen> createState() => _ViewTabsScreen();
}

class _ViewTabsScreen extends State<ViewTabsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool facturar_check = false;
    final departamentoService = Provider.of<DepartamentoService>(context);
    List<String> data = [];
    List<String> data_id = [];
    int initPosition = 0;

    if (departamentoService.isLoading) return const LoadingScreen();

    List<Tab> _tabs = [];
    List<Widget> _views = [];

    for (int i = 0; i < departamentoService.depa.length; i++) {
      data.add(departamentoService.depa[i].departamento);
      data_id.add(departamentoService.depa[i].id);

      _tabs.add(
        Tab(
          text: departamentoService.depa[i].departamento,
        ),
      );

      _views.add(ViewProductoTab(
        id_departamento: departamentoService.depa[i].id,
        id_tmp: widget.id_tmp,
      ));
    }

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          elevation: 0,
          title: Image.asset(
            'assets/gozeri_blanco2.png',
            width: size.width * 0.25,
          ),
          actions: [
            const SizedBox(
              width: 15,
            ),
            CircleAvatar(
              backgroundColor: Colors.cyan[300],
              child: IconButton(
                onPressed: () {
                  ItemsSearch.id_tmp = widget.id_tmp;
                  showSearch(context: context, delegate: ItemsSearch());
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            CircleAvatar(
              backgroundColor: Colors.cyan[300],
              child: Consumer<Cart>(builder: (context, cart, child) {
                return Badge(
                  showBadge: (cart.count == 0) ? false : true,
                  badgeContent: Text(
                    '${cart.count}',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PrintScreen(
                                    id_tmp: widget.id_tmp,
                                  )));
                    },
                    icon: const Icon(
                      Icons.receipt_long,
                      color: Colors.white,
                    ),
                  ),
                );
                return Text(
                  '${cart.count}',
                  style: TextStyle(color: Colors.white),
                );
              }),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Color.fromARGB(255, 219, 219, 219),
            isScrollable: true,
            tabs: _tabs,
          ),
        ),
        body: TabBarView(
          children: _views,
        ),
      ),
    );

    /*return Scaffold(
        //appBar: appBarra(size, context, widget.id_tmp),
        appBar: AppBar(
          foregroundColor: Colors.white,
          elevation: 0,
          title: Image.asset(
            'assets/gozeri_blanco2.png',
            width: size.width * 0.25,
          ),
          actions: [
            const SizedBox(
              width: 15,
            ),
            CircleAvatar(
              backgroundColor: Colors.cyan[300],
              child: IconButton(
                onPressed: () {
                  ItemsSearch.id_tmp = widget.id_tmp;
                  showSearch(context: context, delegate: ItemsSearch());
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            CircleAvatar(
              backgroundColor: Colors.cyan[300],
              child: Consumer<Cart>(builder: (context, cart, child) {
                return Badge(
                  showBadge: (cart.count == 0) ? false : true,
                  badgeContent: Text(
                    '${cart.count}',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PrintScreen(
                                    id_tmp: widget.id_tmp,
                                  )));
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ),
                );
                return Text(
                  '${cart.count}',
                  style: TextStyle(color: Colors.white),
                );
              }),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        body: SafeArea(
          /*child: CustomTabView(
            initPosition: initPosition,
            itemCount: data.length,
            tabBuilder: (context, index) => Tab(text: data[index]),
            pageBuilder: (context, index) {
              return ViewProductoTab(
                id_departamento: data_id[index],
                id_tmp: widget.id_tmp,
              );
            },
            onPositionChange: (index) {
              print('current position: $index');
              initPosition = index;
            },
            onScroll: (position) => print('$position'),
            stub: Text(''),
          ),*/

        ));*/
  }
}

AppBar appBarra(size, context, id_tmp) {
  return AppBar(
    foregroundColor: Colors.white,
    elevation: 0,
    title: Image.asset(
      'assets/gozeri_blanco2.png',
      width: size.width * 0.25,
    ),
    actions: [
      const SizedBox(
        width: 15,
      ),
      CircleAvatar(
        backgroundColor: Colors.cyan[300],
        child: IconButton(
          onPressed: () {
            ItemsSearch.id_tmp = id_tmp;
            showSearch(context: context, delegate: ItemsSearch());
          },
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(
        width: 15,
      ),
      CircleAvatar(
        backgroundColor: Colors.cyan[300],
        child: Consumer<Cart>(builder: (context, cart, child) {
          return Badge(
            showBadge: (cart.count == 0) ? false : true,
            badgeContent: Text(
              '${cart.count}',
              style: TextStyle(color: Colors.white),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PrintScreen(
                              id_tmp: id_tmp,
                            )));
              },
              icon: const Icon(
                Icons.receipt_long,
                color: Colors.white,
              ),
            ),
          );
          return Text(
            '${cart.count}',
            style: TextStyle(color: Colors.white),
          );
        }),
      ),
      const SizedBox(
        width: 20,
      ),
    ],
  );
}

/*class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    required this.stub,
    required this.onPositionChange,
    required this.onScroll,
    required this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  late TabController controller;
  late int _currentCount;
  late int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation?.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation?.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation?.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation?.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          color: Colors.cyan,
          alignment: Alignment.center,
          child: TabBar(
            isScrollable: true,
            controller: controller,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[400],
            indicator: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
            tabs: List.generate(
              widget.itemCount,
              (index) => widget.tabBuilder(context, index),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
              (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation!.value);
    }
  }
}
*/