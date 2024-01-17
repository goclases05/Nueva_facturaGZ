import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
