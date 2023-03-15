import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:factura_gozeri/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    color: Color.fromRGBO(0, 0, 0, 0.001),
                    child: GestureDetector(
                      onTap: () {},
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.8,
                        minChildSize: 0.2,
                        maxChildSize: 1,
                        builder: (_, controller) {
                          return Consumer<AuthService>(
                            builder: (context, authservice, child) {
                          //empieza sheet

                          return Container(
                            color: Colors.white,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  color: widget.colo.withOpacity(0.1),
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    'Reporte de Ventas ',
                                    style: TextStyle(color: widget.colo,fontWeight: FontWeight.bold,fontSize: 18),
                                  )),
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        
                                        //******************************************************************** */
                                        Container(
                                          padding: const EdgeInsets.only(
                                              top: 8, right: 8, bottom: 8),
                                          child: Wrap(
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            direction: Axis.horizontal,
                                            children: [
                                              Text('Seleccióna una Sucursal:',style: TextStyle(fontSize: 14),),
                                              Divider(),
                                              SizedBox(height: 5,),
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
                                                      fontSize: 16),
                                                  //icon: Icon(Icons.arrow_drop_down),
                                                  underline: SizedBox(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text('Seleccióna un rango de fecha:',style: TextStyle(fontSize: 14),textAlign: TextAlign.left,),
                                        Divider(),
                                        SizedBox(height: 5,),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SfDateRangePicker(
                                          selectionMode: DateRangePickerSelectionMode.range,
                                          initialSelectedDate:DateTime.now(),
                                          onViewChanged:(dateRangePickerViewChangedArgs) {
                                            print('cambio date');
                                            print(dateRangePickerViewChangedArgs.visibleDateRange);
                                          },
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStatePropertyAll<Color>(Color.fromARGB(255, 159, 22, 13))
                                                  ,iconColor: MaterialStatePropertyAll<Color>(Colors.white),
                                                  textStyle: MaterialStatePropertyAll<TextStyle>(TextStyle(
                                                    color: Colors.white
                                                  ))
                                                ),
                                                onPressed: (){
                                            
                                                }, 
                                                icon: Text('Generar PDF',style: TextStyle(color: Colors.white),), 
                                                label: Icon(Icons.picture_as_pdf)),
                                            ),
                                            SizedBox(width: 10,),
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStatePropertyAll<Color>(Color.fromARGB(255, 16, 157, 56))
                                                  ,iconColor: MaterialStatePropertyAll<Color>(Colors.white),
                                                  textStyle: MaterialStatePropertyAll<TextStyle>(TextStyle(
                                                    color: Colors.white
                                                  ))
                                                ),
                                                onPressed: (){
                                            
                                                }, 
                                                icon: Text('Generar Excel',style: TextStyle(color: Colors.white),), 
                                                label: Icon(Icons.grid_on)),
                                            ),
                                          ],
                                        ),
                                        
                                        
                                        Container(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStatePropertyAll<Color>(Color.fromARGB(255, 40, 111, 193))
                                              ,iconColor: MaterialStatePropertyAll<Color>(Colors.white),
                                              textStyle: MaterialStatePropertyAll<TextStyle>(TextStyle(
                                                color: Colors.white
                                              ))
                                            ),
                                            onPressed: (){
                                        
                                            }, 
                                            icon: Text('Ver Reporte',style: TextStyle(color: Colors.white),), 
                                            label: Icon(Icons.visibility)),
                                        )
                                        //******************************************************************** */
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                          //termina sheet
                        });
                        },
                      ),
                    ),
                  ),
                );
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
