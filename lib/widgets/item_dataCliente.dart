import 'package:flutter/material.dart';

class ItemCliente extends StatefulWidget {
  const ItemCliente({Key? key}) : super(key: key);

  @override
  State<ItemCliente> createState() => _ItemCliente();
}

class _ItemCliente extends State<ItemCliente> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children:  [
        const Divider(
          height: 20,
        ),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.6,
              child:const  TextField(
                decoration: InputDecoration(
                  label: Text('NIT, usuario, nombre, correo'),
                  icon: Icon(Icons.person, color: Color.fromARGB(255, 15, 96, 106),),
                  border: OutlineInputBorder(),
                  focusColor: Colors.red,
                  fillColor: Colors.red,
                )
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(37, 0, 0, 0),
                    width: 2,
                  ),
                  color: const Color.fromARGB(255, 65, 185, 214)
                ),
                padding: const EdgeInsets.symmetric(vertical: 3.6),
                //color: Color.fromARGB(255, 65, 185, 214),
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: (){}, 
                  icon:const  Icon(Icons.search,color: Colors.white,size: 25,)),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                  border: Border.all(
                    color: Color.fromARGB(37, 0, 0, 0),
                    width: 2,
                  ),
                  color: const Color.fromARGB(255, 12, 236, 236)
                ),
                padding: const EdgeInsets.symmetric(vertical: 3.6),
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: (){}, 
                  icon: Icon(Icons.add,color: Colors.white,size: 25,)),
              ),
            )
          ],
        ),
        const SizedBox(
          height:15
        ),
        Container(
          width: MediaQuery.of(context).size.width*0.9,
          child:const  TextField(
            decoration: InputDecoration(
              label: Text('Descuento'),
              icon: Icon(Icons.percent, color: Color.fromARGB(255, 15, 96, 106),),
              border: OutlineInputBorder(),
              focusColor: Colors.red,
              fillColor: Colors.red,
            )
          ),
        ),
        const Divider(
          height: 20,
        ),
      ],
    );
  }
}