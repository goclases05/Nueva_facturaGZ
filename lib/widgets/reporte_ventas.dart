import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:factura_gozeri/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class Reporte_Ventas extends StatefulWidget {
  Reporte_Ventas({super.key, required this.colo, required this.context});
  Color colo;
  BuildContext context;
  bool isMount = true;

  @override
  State<Reporte_Ventas> createState() => _Reporte_VentasState();
}

class _Reporte_VentasState extends State<Reporte_Ventas> {
  //String selectedValue1 = "${Preferencias.sucursal}";

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    List<DropdownMenuItem<String>> menuItems = [];
    for (var i = 0; i < authService.list_sucu.length; i++) {
      menuItems.add(DropdownMenuItem(
          child: Text(
            authService.list_sucu[i].nombre,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
          value: authService.list_sucu[i].idSucursal));
      ;
    }
    return Material(
        color: widget.colo.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Consumer<AuthService>(
                    builder: (context, authservice, child) {
                  //empieza sheet

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  color: widget.colo.withOpacity(0.1),
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Reporte de Ventas ',
                                    style: TextStyle(color: widget.colo),
                                  )),
                              //******************************************************************** */
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 8, right: 8, bottom: 8),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  direction: Axis.horizontal,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: widget.colo),
                                        //borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                        //color: Color.fromARGB(255, 219, 219, 219),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      child: DropdownButton(
                                        //key: keysucursal,
                                        isExpanded: true,
                                        itemHeight: null,
                                        value: authservice.id_sucu_reportes,
                                        dropdownColor: Colors.white,
                                        onChanged: (String? newValue) {
                                          // check whether the state object is in tree
                                          authservice.id_suc_reporte(newValue!);

                                          //Preferencias.sucursal = selectedValue;*/
                                        },
                                        items: menuItems,
                                        elevation: 0,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        //icon: Icon(Icons.arrow_drop_down),
                                        underline: SizedBox(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              //******************************************************************** */
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                  //termina sheet
                });
              },
            );
          },
          radius: 100,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Icon(
                    Icons.bar_chart,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    'Reporte de Ventas',
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
