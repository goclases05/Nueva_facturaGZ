import 'package:flutter/material.dart';

class ModoVenta2 extends StatefulWidget {
  const ModoVenta2({Key? key}) : super(key: key);

  @override
  State<ModoVenta2> createState() => _ModoVenta2State();
}

class _ModoVenta2State extends State<ModoVenta2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('Costo'),
        TextField(decoration: InputDecoration(border: OutlineInputBorder())),
        Text('Cantidad'),
        TextField(decoration: InputDecoration(border: OutlineInputBorder())),
        Text('Monto'),
        TextField(decoration: InputDecoration(border: OutlineInputBorder())),
        TextField(decoration: InputDecoration(border: OutlineInputBorder())),
        TextField(decoration: InputDecoration(border: OutlineInputBorder())),
        TextField(decoration: InputDecoration(border: OutlineInputBorder())),
        TextField(decoration: InputDecoration(border: OutlineInputBorder())),
        TextField(decoration: InputDecoration(border: OutlineInputBorder())),
        TextField(decoration: InputDecoration(border: OutlineInputBorder())),
        TextField(decoration: InputDecoration(border: OutlineInputBorder())),
      ],
    );
  }
}
