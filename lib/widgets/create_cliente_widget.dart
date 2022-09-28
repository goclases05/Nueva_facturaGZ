import 'package:flutter/material.dart';

class CreateClienteWidget extends StatefulWidget {
  CreateClienteWidget({Key? key, required this.colorPrimary}) : super(key: key);
  Color colorPrimary;

  @override
  State<CreateClienteWidget> createState() => _CreateClienteWidgetState();
}

class _CreateClienteWidgetState extends State<CreateClienteWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Registrar Cliente',
            style: TextStyle(
                color: Colors.black45,
                fontSize: 25,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
