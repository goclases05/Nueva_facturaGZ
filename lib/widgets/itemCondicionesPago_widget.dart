import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
  String initialSerie = '14';

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
                value: initialSerie,
                isExpanded: true,
                dropdownColor: Color.fromARGB(255, 241, 238, 241),
                onChanged: (String? newValue) async {
                  /*if (newValue != '1' && newValue != '6' && newValue != '15') {
                    Metodo.bancos();
                  }*/
                  setState(() {
                    initialSerie = newValue!;
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
      ],
    );
  }
}
