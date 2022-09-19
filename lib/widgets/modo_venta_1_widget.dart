import 'package:flutter/material.dart';

class ModoVenta1 extends StatefulWidget {
  ModoVenta1({Key? key, required this.colorPrimary}) : super(key: key);
  Color colorPrimary;

  @override
  State<ModoVenta1> createState() => _ModoVenta1State();
}

class _ModoVenta1State extends State<ModoVenta1> {
  @override
  Widget build(BuildContext context) {
    return Column(
      /*mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,*/
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.paid,
                      color: widget.colorPrimary,
                      size: 23,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Precio',
                      style: TextStyle(
                          color: Color.fromARGB(255, 162, 174, 194),
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: const TextField(
                      decoration:
                          InputDecoration(border: OutlineInputBorder())),
                ),
              ],
            )),
            Expanded(
                child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.list_alt_rounded,
                      color: widget.colorPrimary,
                      size: 23,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Cantidad',
                      style: TextStyle(
                          color: Color.fromARGB(255, 162, 174, 194),
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            )),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Icon(
              Icons.payments,
              color: widget.colorPrimary,
              size: 23,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              'Monto',
              style: TextStyle(
                  color: Color.fromARGB(255, 162, 174, 194),
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        Container(
          child: const TextField(
              decoration: InputDecoration(border: OutlineInputBorder())),
        ),
      ],
    );
  }
}
