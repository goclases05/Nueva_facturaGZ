import 'package:date_time_picker/date_time_picker.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemCondicionesPago extends StatefulWidget {
  ItemCondicionesPago(
      {required this.colorPrimary, required this.tmp, required this.id});
  Color colorPrimary;
  String tmp;
  String id;

  @override
  State<ItemCondicionesPago> createState() => _ItemCondicionesPago();
}

class _ItemCondicionesPago extends State<ItemCondicionesPago> {
  String condicionSeleccionada = '';
  bool valores_listos = false;

  TextEditingController _controlFecha = TextEditingController();
  TextEditingController _controlFechaV = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _controlFechaV = TextEditingController(text: DateTime.now().toString());
    _controlFecha = TextEditingController(text: DateTime.now().toString());

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    /*final cpago = Provider.of<Facturacion>(context, listen: false);
    cpago.load_condicionespagos = true;
    cpago.loadCondicionesTMP = true;
    cpago.list_condicionPago.clear();
    cpago.condiciones_registradas.clear();*/

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cpago = Provider.of<Facturacion>(context, listen: false);
    cpago.condicionesPagos(widget.id);

    List<DropdownMenuItem<String>> menuItems = [];

    return Consumer<Facturacion>(builder: (context, condiciones, child) {
      if (condiciones.load_condicionespagos == true) {
        return CircularProgressIndicator();
      }

      //relleno datos con predeterminados
      List<DropdownMenuItem<String>> menuItems = [];
      menuItems.clear();

      for (var i = 0; i < condiciones.list_condicionPago.length; i++) {
        print(condiciones.list_condicionPago[i].nombre);

        menuItems.add(DropdownMenuItem(
            value: condiciones.list_condicionPago[i].idMetodo,
            child: Text(
              condiciones.list_condicionPago[i].nombre,
              textAlign: TextAlign.start,
            )));
      }
      //relleno datos con predeterminados
      _controlFecha.text =
          condiciones.condiciones_registradas["FECHA"].toString();
      _controlFechaV.text =
          condiciones.condiciones_registradas["FECHA_V"].toString();
      condicionSeleccionada =
          condiciones.condiciones_registradas['TERMINOS'].toString();

      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              style: BorderStyle.solid,
                              width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton(
                          value: condicionSeleccionada,
                          isExpanded: true,
                          dropdownColor: Color.fromARGB(255, 241, 238, 241),
                          items: menuItems,
                          onChanged: (String? value) {
                            condicionSeleccionada = value.toString();
                            condiciones.queryCondicionesPagoTM(
                                '1', 'TERMINOS', value.toString(), widget.id);
                          },
                        )),
                  ),
                ]),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: DateTimePicker(
                enabled: true,
                type: DateTimePickerType.date,
                dateMask: 'd/MM/yyyy',
                firstDate: DateTime(2024),
                lastDate: DateTime(2030),
                controller: _controlFecha,
                icon: Icon(Icons.event),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'día/mes/año',
                    label: Text('Fecha')),
                dateLabelText: 'Fecha',
                selectableDayPredicate: (date) {
                  /*if (date.day < DateTime.now().add(Duration(days: -5)).day) {
                          return false;
                        }*/
                  return true;
                },
                onChanged: (val) async {
                  _controlFecha.text = val;
                  _controlFechaV.text = val;

                  condiciones.condiciones_registradas['FECHA_V'] = val;
                  condiciones.condiciones_registradas['FECHA'] = val;

                  await condiciones.queryCondicionesPagoTM(
                      "1", "FECHA", val, widget.id);
                  await condiciones.queryCondicionesPagoTM(
                      "1", "FECHA_V", val, widget.id);
                },
                onSaved: (val) => print(val),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: DateTimePicker(
                enabled: (condiciones.condiciones_registradas['TERMINOS'] ==
                            '0' ||
                        condiciones.condiciones_registradas['TERMINOS'] == '14')
                    ? false
                    : true,
                type: DateTimePickerType.date,
                dateMask: 'd/MM/yyyy',
                controller: _controlFechaV,
                firstDate: DateTime(2023),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'día/mes/año',
                    label: Text('Fecha Vencimiento')),
                dateLabelText: 'Fecha Vencimiento',
                selectableDayPredicate: (date) {
                  if (date.year >= DateTime.parse(_controlFecha.text).year) {
                    if (date.month >=
                            DateTime.parse(_controlFecha.text).month ||
                        date.year > DateTime.parse(_controlFecha.text).year) {
                      if (date.day >= DateTime.parse(_controlFecha.text).day ||
                          date.month >
                              DateTime.parse(_controlFecha.text).month ||
                          date.year > DateTime.parse(_controlFecha.text).year) {
                        return true;
                      }
                    }
                  }

                  return false;
                },
                onChanged: (val) async {
                  _controlFechaV.text = val;

                  await condiciones.queryCondicionesPagoTM(
                      "1", "FECHA_V", val, widget.id);
                  condiciones.condiciones_registradas['FECHA_V'] = val;
                },
                onSaved: (val) => print(val),
              ),
            )
          ]);
    });
  }
}

/*
class ItemCondicionesPago extends StatefulWidget {
  ItemCondicionesPago(
      {super.key,
      required this.colorPrimary,
      required this.tmp,
      required this.id});
  Color colorPrimary;
  String tmp;
  String id;

  @override
  State<ItemCondicionesPago> createState() => _ItemCondicionesPago();
}

class _ItemCondicionesPago extends State<ItemCondicionesPago> {
  String initialCodicion = '14';
  DateTime? selectedDate;
  TextEditingController date = TextEditingController();
  late TextEditingController _controlFecha;
  late TextEditingController _controlFechaV;
  int vuelta = 0;

  @override
  void initState() {
    // TODO: implement initState

    _controlFechaV = TextEditingController(text: DateTime.now().toString());
    _controlFecha = TextEditingController(text: DateTime.now().toString());

    final cpago = Provider.of<Facturacion>(context, listen: false);
    //cpago.condicionPagoShowSave('0', '', '', widget.id);
    cpago.loadCondicionP = true;
    cpago.loadTerminos = true;
    cpago.condicionPago();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    final cpago = Provider.of<Facturacion>(context, listen: false);
    cpago.loadCondicionP = true;
    cpago.loadTerminos = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cpago = Provider.of<Facturacion>(context, listen: false);
    cpago.condicionPagoShowSave('0', '', '', widget.id);

    List<DropdownMenuItem<String>> menuItems = [];

    //print('la condicion ${}}');
    return Consumer<Facturacion>(builder: (context, condiciones, child) {
      print(
          'los datos de la peticionson :${condiciones.lista_datosFacturaTermino["TERMINOS"]}');

      if (condiciones.loadTerminos == true &&
          condiciones.loadCondicionP == true) {
        //verifica si aun esta cargando la lista de condiciones
        return Container(
          child: CircularProgressIndicator(),
        );
      }
      initialCodicion =
          condiciones.lista_datosFacturaTermino["TERMINOS"].toString();

      _controlFecha.text =
          condiciones.lista_datosFacturaTermino["FECHA"].toString();
      _controlFechaV.text =
          condiciones.lista_datosFacturaTermino["FECHA_V"].toString();

      menuItems.clear();

      for (var i = 0; i < condiciones.list_condicionPago.length; i++) {
        print(condiciones.list_condicionPago[i].nombre);
        print(initialCodicion);
        menuItems.add(DropdownMenuItem(
            value: condiciones.list_condicionPago[i].idMetodo,
            child: Text(
              condiciones.list_condicionPago[i].nombre,
              textAlign: TextAlign.start,
            )));
      }

      //relleno variables
      print('condicion ${initialCodicion}');
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 5,
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey, style: BorderStyle.solid, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton(
                  isExpanded: true,
                  dropdownColor: Color.fromARGB(255, 241, 238, 241),
                  onChanged: (String? newValue) async {
                    /*if (newValue != '1' && newValue != '6' && newValue != '15') {
                        Metodo.bancos();
                      }*/
                    await condiciones.condicionPagoShowSave(
                        "1", "TERMINOS", newValue!, widget.id);
                    await condiciones.condicionPagoShowSave(
                        "1", "FECHA_V", DateTime.now().toString(), widget.id);

                    setState(() {
                      print('se actualizo');
                      condiciones.lista_datosFacturaTermino['TERMINOS'] =
                          newValue.toString();
                      condiciones.lista_datosFacturaTermino['FECHA_V'] =
                          DateTime.now().toString();

                      initialCodicion = newValue;
                      _controlFechaV.text = DateTime.now().toString();
                    });
                  },
                  items: menuItems,
                  value: (initialCodicion.isNotEmpty) ? initialCodicion : '14',
                  elevation: 0,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  //icon: Icon(Icons.arrow_drop_down),
                  iconDisabledColor: Colors.red,
                  iconEnabledColor: widget.colorPrimary,
                  underline: SizedBox(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: DateTimePicker(
              enabled: true,
              type: DateTimePickerType.date,
              dateMask: 'd/MM/yyyy',
              firstDate: DateTime(2024),
              lastDate: DateTime(2030),
              controller: _controlFecha,
              icon: Icon(Icons.event),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'día/mes/año',
                  label: Text('Fecha')),
              dateLabelText: 'Fecha',
              selectableDayPredicate: (date) {
                /*if (date.day < DateTime.now().add(Duration(days: -5)).day) {
                    return false;
                  }*/
                return true;
              },
              onChanged: (val) async {
                _controlFecha.text = val;
                _controlFechaV.text = val;

                await condiciones.condicionPagoShowSave(
                    "1", "FECHA", val, widget.id);
                await condiciones.condicionPagoShowSave(
                    "1", "FECHA_V", val, widget.id);

                condiciones.lista_datosFacturaTermino['FECHA_V'] = val;
                condiciones.lista_datosFacturaTermino['FECHA'] = val;
                setState(() {});
              },
              onSaved: (val) => print(val),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: DateTimePicker(
              enabled: (initialCodicion == '0' || initialCodicion == '14')
                  ? false
                  : true,
              type: DateTimePickerType.date,
              dateMask: 'd/MM/yyyy',
              controller: _controlFechaV,
              firstDate: DateTime(2023),
              lastDate: DateTime(2100),
              icon: Icon(Icons.event),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'día/mes/año',
                  label: Text('Fecha Vencimiento')),
              dateLabelText: 'Fecha Vencimiento',
              selectableDayPredicate: (date) {
                if (date.year >= DateTime.parse(_controlFecha.text).year) {
                  if (date.month >= DateTime.parse(_controlFecha.text).month ||
                      date.year > DateTime.parse(_controlFecha.text).year) {
                    if (date.day >= DateTime.parse(_controlFecha.text).day ||
                        date.month > DateTime.parse(_controlFecha.text).month ||
                        date.year > DateTime.parse(_controlFecha.text).year) {
                      return true;
                    }
                  }
                }

                return false;
              },
              onChanged: (val) async {
                _controlFechaV.text = val;

                await condiciones.condicionPagoShowSave(
                    "1", "FECHA_V", val, widget.id);
                condiciones.lista_datosFacturaTermino['FECHA_V'] = val;
                setState(() {});
              },
              onSaved: (val) => print(val),
            ),
          )
        ],
      );
    });
  }
}*/
