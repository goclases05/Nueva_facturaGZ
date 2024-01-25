import 'package:date_time_picker/date_time_picker.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    _controlFechaV = TextEditingController(text: DateTime.now().toString());
    _controlFecha = TextEditingController(text: DateTime.now().toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cpago = Provider.of<Facturacion>(context);
    List<DropdownMenuItem<String>> menuItems = [];

    if (cpago.loadMetodo)
      // ignore: curly_braces_in_flow_control_structures
      return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          padding: const EdgeInsets.all(0),
          child: Center(
            child: CircularProgressIndicator(
              color: widget.colorPrimary,
            ),
          ));

    menuItems.clear();
    for (var i = 0; i < cpago.list_condicionPago.length; i++) {
      menuItems.add(DropdownMenuItem(
          value: cpago.list_condicionPago[i].idMetodo,
          child: Text(
            cpago.list_condicionPago[i].nombre,
            textAlign: TextAlign.start,
          )));
    }

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
                itemHeight: null,
                value: (initialCodicion == '0') ? '14' : initialCodicion,
                isExpanded: true,
                dropdownColor: Color.fromARGB(255, 241, 238, 241),
                onChanged: (String? newValue) async {
                  /*if (newValue != '1' && newValue != '6' && newValue != '15') {
                    Metodo.bancos();
                  }*/
                  setState(() {
                    if (newValue == '0' || newValue == '14') {
                      initialCodicion = newValue.toString();
                      _controlFechaV.text = DateTime.now().toString();
                    } else {
                      initialCodicion = newValue.toString();
                    }
                  });
                },
                items: menuItems,
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
            onChanged: (val) {
              _controlFecha.text = val;
              _controlFechaV.text = val;
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
            onChanged: (val) {
              _controlFechaV.text = val;
              setState(() {});
            },
            onSaved: (val) => print(val),
          ),
        )
      ],
    );
  }
}
