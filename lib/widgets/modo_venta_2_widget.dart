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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: const Text(
                  'Precio:',
                  style: TextStyle(),
                )),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: const TextField(
                  decoration: InputDecoration(border: OutlineInputBorder())),
            ),
          ],
        ),
        Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: const Text(
                  'Cantidad:',
                  style: TextStyle(),
                )),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: const TextField(
                  decoration: InputDecoration(border: OutlineInputBorder())),
            ),
          ],
        ),
        Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: const Text(
                  'Monto:',
                  style: TextStyle(),
                )),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: const TextField(
                  decoration: InputDecoration(border: OutlineInputBorder())),
            ),
          ],
        ),
      ],
    );
  }
}
