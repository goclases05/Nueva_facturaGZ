import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class ItemObservacion extends StatefulWidget {
  ItemObservacion(
      {super.key,
      required this.colorPrimary,
      required this.tmp,
      required this.id});
  Color colorPrimary;
  String tmp;
  String id;

  @override
  State<ItemObservacion> createState() => _ItemObservacionState();
}

class _ItemObservacionState extends State<ItemObservacion> {
  final _controller = TextEditingController();
  String ob = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final facturaService = Provider.of<Facturacion>(context, listen: false);
    ob = facturaService.ob;
    print(ob);
    _controller.addListener(() {
      facturaService.addOB(_controller.text, widget.id);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = ob.toString();
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));

    return TextField(
      textAlign: TextAlign.left,
      maxLines: 3,
      keyboardType: TextInputType.text,
      cursorColor: widget.colorPrimary,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Detalles especificos y observaciones',
      ),
      controller: _controller,
      onChanged: (value) {},
    );
  }
}
