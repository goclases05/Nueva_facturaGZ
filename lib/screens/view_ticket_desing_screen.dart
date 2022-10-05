import 'package:factura_gozeri/global/globals.dart';
import 'package:flutter/material.dart';

class ViewTicket extends StatelessWidget {
  ViewTicket({Key? key, required this.colorPrimary, required this.estado})
      : super(key: key);
  Color colorPrimary;
  String estado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(246, 243, 244, 1),
        appBar: AppBar(
            backgroundColor: colorPrimary,
            foregroundColor: Colors.white,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Factura: ', style: TextStyle(color: Colors.white)),
                Chip(
                    padding: const EdgeInsets.all(1),
                    backgroundColor: (estado == '2')
                        ? Color.fromARGB(255, 169, 189, 105)
                        : Color.fromARGB(255, 232, 116, 107),
                    label: Text(
                      (estado == '2') ? 'Pagada' : 'Anulada',
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    )),
              ],
            ),
            actions: [
              CircleAvatar(
                backgroundColor: Colors.white38,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.print),
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ]),
        bottomSheet: sheetButton(context),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Card(
              margin: EdgeInsets.all(15),
              elevation: 8,
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  children: [
                    FadeInImage(
                        width: MediaQuery.of(context).size.width * 0.25,
                        placeholder: AssetImage('assets/productos_gz.jpg'),
                        image: NetworkImage(Preferencias.foto_empresa)),
                    const SizedBox(
                      height: 10,
                    ),
                    //Nombre de empresa
                    TitleText(
                        'Lubricantes y repuestos amaya', 18, TextAlign.center),
                    //Direccion de empresa
                    SimpleText('Palin Escuintla', 15, TextAlign.center),
                    const SizedBox(
                      height: 10,
                    ),
                    //NIT de la empresa
                    claveValor('NIT: ', '11755776', MainAxisAlignment.center),
                    //Telefono de la empresa
                    claveValor(
                        'Teléfono', '+502 6352-8596', MainAxisAlignment.center),
                    const SizedBox(
                      height: 10,
                    ),
                    //nombre de persona
                    SimpleText('AMAYA HEYDI JUDITH SEGURA HERNÁNDEZ', 15,
                        TextAlign.center),
                    const SizedBox(
                      height: 10,
                    ),
                    //facturada
                    TitleText(
                        'Factura Electrónica Documento Tributario Electrónico',
                        18,
                        TextAlign.center),
                    //fecha
                    const SizedBox(
                      height: 15,
                    ),
                    claveValor(
                        '', '04 de Octubre de 2022', MainAxisAlignment.end),
                    const SizedBox(
                      height: 20,
                    ),
                    //n autorizacion
                    TitleText('Número de Autorización:', 13, TextAlign.center),
                    SimpleText('AF089737-62DB-4348-B2D0-CF2C3EED9A75', 13,
                        TextAlign.center),
                    claveValor('Serie: ', 'AF089737', MainAxisAlignment.center),
                    claveValor('Número de DTE: ', '1658536776',
                        MainAxisAlignment.center),
                    const SizedBox(
                      height: 20,
                    ),
                    //serie y no
                    Row(
                      children: [
                        Expanded(
                            child: claveValor(
                                'Serie:', '"Ticket"', MainAxisAlignment.start)),
                        Expanded(
                            child: claveValor(
                                'No:', '7235', MainAxisAlignment.end))
                      ],
                    ),
                    //cliente
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Vendedor: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Expanded(
                          child: Text(
                            'Juan Perez lopez ortiz',
                            style: TextStyle(fontSize: 15),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Cliente: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Expanded(
                          child: Text(
                            'PROMEVI SOCIEDAD ANÓNIMA',
                            style: TextStyle(fontSize: 15),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                    claveValor('NIT: ', '70520488', MainAxisAlignment.start),
                    //direccion
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Dirección: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Expanded(
                          child: Text(
                            'CALZADA AGUILAR BATRES 16-29 1 REFORMITA GUATEMALA ',
                            style: TextStyle(fontSize: 15),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //condicion de pago
                    TitleText('Condiciones de pago:', 15, TextAlign.center),
                    claveValor(
                        'Efectivo: ', 'Q200.00', MainAxisAlignment.center),
                    const SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: TitleText('Descripción', 16, TextAlign.start),
                      trailing: TitleText('Subtotal', 16, TextAlign.end),
                    ),
                    Listdata('Q'),
                    //descuento
                    Container(
                        margin: EdgeInsets.only(right: 20),
                        child: claveValor('Descuentos (-) :  ', 'Q2.00',
                            MainAxisAlignment.end)),
                    //total
                    Container(
                        margin: EdgeInsets.only(right: 20),
                        child: claveValor(
                            'Total :  ', 'Q200.00', MainAxisAlignment.end)),
                    const SizedBox(
                      height: 15,
                    ),
                    //total letra
                    claveValor(
                        'noventa con 00/100', '', MainAxisAlignment.start),
                    //isr
                    const SizedBox(
                      height: 15,
                    ),
                    SimpleText('Sujeto a pagos trimestrales ISR', 15,
                        TextAlign.center),
                    const SizedBox(
                      height: 15,
                    ),
                    claveValor('Certificador: ', 'Megaprint, S.A.',
                        MainAxisAlignment.start),
                    claveValor('NIT: ', '50510231', MainAxisAlignment.start),
                    claveValor('Fecha: ', '2022-10-04T11:30:32.465-06:00',
                        MainAxisAlignment.start),
                    //creditos xd
                    const SizedBox(
                      height: 15,
                    ),
                    SimpleText('Factura realizada en www.gozeri.com', 15,
                        TextAlign.center)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
          ]),
        ));
  }

  Container sheetButton(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(246, 243, 244, 1),
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 1,
      child: TextButton.icon(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: colorPrimary,
        ),
        label: const Text(
          'Imprimir Factura',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.print,
          color: Colors.white,
        ),
      ),
    );
  }

  ListView Listdata(String moneda) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 4,
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SimpleText('COJINETE 6206', 12, TextAlign.start),
                  SimpleText('1 * ${moneda}50.00', 10, TextAlign.start),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(right: 20),
                child: SimpleText('${moneda}50.00', 12, TextAlign.end))
          ],
        );
      },
    );
  }

  Text SimpleText(String text, double size, TextAlign align) {
    return Text(
      text,
      style: TextStyle(fontSize: size, wordSpacing: 0),
      textAlign: align,
    );
  }

  Text TitleText(String text, double size, TextAlign align) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: size, wordSpacing: 0),
      textAlign: align,
    );
  }

  Row claveValor(String clave, String valor, MainAxisAlignment align) {
    return Row(
      mainAxisAlignment: align,
      children: [
        Text(clave,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, wordSpacing: 0)),
        Text(
          valor,
          style: const TextStyle(fontSize: 15, wordSpacing: 0),
          maxLines: 3,
        ),
      ],
    );
  }
}
