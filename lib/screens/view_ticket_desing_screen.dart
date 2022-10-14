import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/models/view_factura_print.dart';
import 'package:factura_gozeri/providers/print_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewTicket extends StatelessWidget {
  ViewTicket({Key? key, required this.colorPrimary, required this.estado, required this.factura})
      : super(key: key);
  Color colorPrimary;
  String estado;
  String factura;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(246, 243, 244, 1),
        appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: colorPrimary,
            elevation: 2,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Factura: ', style: TextStyle(color: colorPrimary)),
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
                backgroundColor: const Color.fromRGBO(242, 242, 247, 1),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.print),
                  color: colorPrimary,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ]),
        bottomSheet: sheetButton(context),
        body: Consumer<PrintProvider>(
          builder: (context, printProvider, child){

            

            if(printProvider.loading) 
              return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: CircularProgressIndicator(
                  color: colorPrimary,
                )
              ));
            
            List<Encabezado> encabezado=printProvider.list;
            
            int sede=0;
            //0= empresa
            //1= sucursal
            if((encabezado[0].fel=='0' && encabezado[0].felSucu=='1') || (encabezado[0].fel=='1' && encabezado[0].felSucu=='1')){
              sede=1;
            }else if(encabezado[0].fel=='1' && encabezado[0].felSucu=='0'){
              sede=0;
            }


            return SingleChildScrollView(
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
                      (sede==1)?
                      //sucursal
                      FadeInImage(
                          width: MediaQuery.of(context).size.width * 0.25,
                          placeholder: AssetImage('assets/productos_gz.jpg'),
                          image: NetworkImage(encabezado[0].rutaSucu+encabezado[0].foto)):
                      //empresa
                      FadeInImage(
                          width: MediaQuery.of(context).size.width * 0.25,
                          placeholder: AssetImage('assets/productos_gz.jpg'),
                          image: NetworkImage(encabezado[0].rutaSucu+encabezado[0].foto)),
                      
                      const SizedBox(
                        height: 10,
                      ),

                      //Nombre de empresa
                      (sede==1)?
                      TitleText(
                          encabezado[0].nombreEmpresaSucu, 18, TextAlign.center):
                      TitleText(
                          encabezado[0].nombreEmpresa, 18, TextAlign.center),


                      //Direccion de empresa
                      (sede==1)?
                      SimpleText(encabezado[0].direccionSucu, 15, TextAlign.center):
                      SimpleText(encabezado[0].direccion, 15, TextAlign.center),


                      const SizedBox(
                        height: 10,
                      ),

                      //NIT de la empresa
                      //TODO: NIT DE LA SUCURSAL
                      (sede==1)?
                        (encabezado[0].nit!='')?
                          claveValor('NIT: ', encabezado[0].nit, MainAxisAlignment.center):
                          Container()

                      :(encabezado[0].nit!='')?
                        claveValor(
                          'NIT: ', encabezado[0].nit, MainAxisAlignment.center):
                          Container(),


                      //Telefono de la empresa
                      (sede==1)?
                        (encabezado[0].teleSucu!='')?
                          claveValor('Teléfono: ', encabezado[0].teleSucu, MainAxisAlignment.center):
                          Container()

                      :(encabezado[0].telefono!='')?
                        claveValor(
                          'Teléfono: ', encabezado[0].telefono, MainAxisAlignment.center):
                          Container(),


                      const SizedBox(
                        height: 10,
                      ),


                      //nombre comercial
                      //TODO:NOMBRE COMERCIAL
                      SimpleText(encabezado[0].organizacion, 15,
                          TextAlign.center),
                      const SizedBox(
                        height: 10,
                      ),


                      //facturada
                      if(encabezado[0].dte!='')
                      TitleText(
                          'Factura Electrónica Documento Tributario Electrónico',
                          18,
                          TextAlign.center),


                      //fecha
                      const SizedBox(
                        height: 15,
                      ),
                      //TODO: FECHA EN LETRAS
                      claveValor(
                          '', encabezado[0].fecha, MainAxisAlignment.end),



                      const SizedBox(
                        height: 20,
                      ),
                      //n autorizacion
                      (encabezado[0].dte!='')?
                        Container(
                          child:Column(
                            children: [
                              TitleText('Número de Autorización:', 13, TextAlign.center),
                              SimpleText(encabezado[0].dte, 13,
                                  TextAlign.center),
                              claveValor('Serie: ', encabezado[0].serieDte, MainAxisAlignment.center),
                              claveValor('Número de DTE: ', encabezado[0].noDte,
                                  MainAxisAlignment.center),
                            ],
                          )
                        ):
                        Container(),

                      
                      const SizedBox(
                        height: 20,
                      ),
                      //serie y no
                      Row(
                        children: [
                          Expanded(
                              child: claveValor(
                                  'Serie: ', encabezado[0].serie, MainAxisAlignment.start)),
                          Expanded(
                              child: claveValor(
                                  'No:  ', encabezado[0].no, MainAxisAlignment.end))
                        ],
                      ),
                      //vendedor
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Vendedor: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          Expanded(
                            child: Text(
                              '${encabezado[0].nombreV} ${encabezado[0].apellidosV}',
                              style: TextStyle(fontSize: 15),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                      //cliente
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Cliente: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          Expanded(
                            child: Text(
                              '${encabezado[0].nombre} ${encabezado[0].apellidos}',
                              style: const TextStyle(fontSize: 15),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                      //TODO: NIT DEL CLIENTE
                      claveValor('NIT: ', encabezado[0].nit, MainAxisAlignment.start),
                      //direccion
                      if(encabezado[0].direccionCli!='')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          const Text('Dirección: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          Expanded(
                            child: Text(
                              encabezado[0].direccionCli,
                              style: const TextStyle(fontSize: 15),
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
          );
          },
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
