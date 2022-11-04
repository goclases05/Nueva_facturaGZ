import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/models/view_factura_print.dart';
import 'package:factura_gozeri/providers/print_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewTicket extends StatefulWidget {
  ViewTicket(
      {Key? key,
      required this.colorPrimary,
      required this.estado,
      required this.factura})
      : super(key: key);
  Color colorPrimary;
  String estado;
  String factura;

  @override
  State<ViewTicket> createState() => _ViewTicketState();
}

class _ViewTicketState extends State<ViewTicket> {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();

  @override
  void initState() {
    // TODO: implement initState
    _printerManager.startScan(const Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(246, 243, 244, 1),
        appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: widget.colorPrimary,
            elevation: 2,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Factura: ', style: TextStyle(color: widget.colorPrimary)),
                Chip(
                    padding: const EdgeInsets.all(1),
                    backgroundColor: (widget.estado == '2')
                        ? Color.fromARGB(255, 169, 189, 105)
                        : Color.fromARGB(255, 232, 116, 107),
                    label: Text(
                      (widget.estado == '2') ? 'Pagada' : 'Anulada',
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
                  color: widget.colorPrimary,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ]),
        bottomSheet: sheetButton(context),
        body: Consumer<PrintProvider>(
          builder: (context, printProvider, child) {
            if (printProvider.loading) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: widget.colorPrimary,
                  )));
            }

            List<Encabezado> encabezado = printProvider.list;
            List<Detalle> detalle = printProvider.list_detalle;

            List<Widget> frases = [];
            //frases del certificador
            for (int i = 0; i < encabezado[0].frases.length; i++) {
              frases.add(
                  SimpleText(encabezado[0].frases[i], 13, TextAlign.center));
            }

            int sede = 0;
            //0= empresa
            //1= sucursal
            if ((encabezado[0].fel == '0' && encabezado[0].felSucu == '1') ||
                (encabezado[0].fel == '1' && encabezado[0].felSucu == '1')) {
              sede = 1;
            } else if (encabezado[0].fel == '1' &&
                encabezado[0].felSucu == '0') {
              sede = 0;
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
                        (sede == 1)
                            ?
                            //sucursal
                            FadeInImage(
                                width: MediaQuery.of(context).size.width * 0.25,
                                placeholder:
                                    AssetImage('assets/productos_gz.jpg'),
                                image: NetworkImage(encabezado[0].rutaSucu +
                                    encabezado[0].foto))
                            :
                            //empresa
                            FadeInImage(
                                width: MediaQuery.of(context).size.width * 0.25,
                                placeholder:
                                    AssetImage('assets/productos_gz.jpg'),
                                image: NetworkImage(encabezado[0].logoUrl +
                                    encabezado[0].logoNom)),

                        const SizedBox(
                          height: 10,
                        ),

                        //Nombre de empresa
                        (sede == 1)
                            ? TitleText(encabezado[0].nombreEmpresaSucu, 18,
                                TextAlign.center)
                            : TitleText(encabezado[0].nombreEmpresa, 18,
                                TextAlign.center),

                        //Direccion de empresa
                        (sede == 1)
                            ? SimpleText(encabezado[0].direccionSucu, 15,
                                TextAlign.center)
                            : SimpleText(
                                encabezado[0].direccion, 15, TextAlign.center),

                        const SizedBox(
                          height: 10,
                        ),

                        //NIT de la empresa
                        (encabezado[0].nit_emisor != '')
                            ? claveValor('NIT: ', encabezado[0].nit_emisor,
                                MainAxisAlignment.center)
                            : Container(),

                        //Telefono de la empresa
                        (sede == 1)
                            ? (encabezado[0].teleSucu != '')
                                ? claveValor(
                                    'Teléfono: ',
                                    encabezado[0].teleSucu,
                                    MainAxisAlignment.center)
                                : Container()
                            : (encabezado[0].telefono != '')
                                ? claveValor(
                                    'Teléfono: ',
                                    encabezado[0].telefono,
                                    MainAxisAlignment.center)
                                : Container(),

                        const SizedBox(
                          height: 10,
                        ),

                        //nombre comercial
                        (sede == 1)
                            ? (encabezado[0].nombre_comercial_sucu != '')
                                ? SimpleText(
                                    encabezado[0].nombre_comercial_sucu,
                                    15,
                                    TextAlign.center)
                                : Container()
                            : (encabezado[0].nombre_comercial_emp != '')
                                ? SimpleText(encabezado[0].nombre_comercial_emp,
                                    15, TextAlign.center)
                                : Container(),

                        const SizedBox(
                          height: 10,
                        ),
                        //facturada
                        (encabezado[0].dte != '')
                            ? TitleText(
                                'Factura Electrónica Documento Tributario Electrónico',
                                18,
                                TextAlign.center)
                            : Container(),

                        //fecha
                        const SizedBox(
                          height: 15,
                        ),

                        Text(
                          encabezado[0].fecha_letras,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 11,
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        //n autorizacion
                        (encabezado[0].dte != '')
                            ? Container(
                                padding: const EdgeInsets.all(0),
                                child: Column(
                                  children: [
                                    TitleText('Número de Autorización:', 13,
                                        TextAlign.center),
                                    SimpleText(encabezado[0].dte, 13,
                                        TextAlign.center),
                                    claveValor(
                                        'Serie: ',
                                        encabezado[0].serieDte,
                                        MainAxisAlignment.center),
                                    claveValor(
                                        'Número de DTE: ',
                                        encabezado[0].noDte,
                                        MainAxisAlignment.center),
                                  ],
                                ))
                            : Container(
                                padding: const EdgeInsets.all(0),
                              ),

                        const SizedBox(
                          height: 20,
                        ),
                        //serie y no
                        Row(
                          children: [
                            Expanded(
                                child: claveValor(
                                    'Serie: ',
                                    encabezado[0].serie,
                                    MainAxisAlignment.start)),
                            Expanded(
                                child: claveValor('No:  ', encabezado[0].no,
                                    MainAxisAlignment.end))
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
                        claveValor('NIT: ', encabezado[0].nit,
                            MainAxisAlignment.start),
                        //direccion
                        if (encabezado[0].direccionCli != '')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Dirección: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
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
                            encabezado[0].forma, '', MainAxisAlignment.center),

                        const SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          title: TitleText('Descripción', 16, TextAlign.start),
                          trailing: TitleText('Subtotal', 16, TextAlign.end),
                        ),
                        Listdata(encabezado[0].contenido, detalle),
                        //descuento
                        Container(
                            margin: EdgeInsets.only(right: 20),
                            child: claveValor(
                                'Descuentos (-) :  ',
                                encabezado[0].contenido +
                                    encabezado[0].descuento,
                                MainAxisAlignment.end)),
                        //total
                        Container(
                            margin: EdgeInsets.only(right: 20),
                            child: claveValor(
                                'Total :  ',
                                encabezado[0].contenido + encabezado[0].total,
                                MainAxisAlignment.end)),
                        const SizedBox(
                          height: 15,
                        ),
                        //total letra
                        claveValor(encabezado[0].totalLetas, '',
                            MainAxisAlignment.start),
                        //isr
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: frases,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        (encabezado[0].dte != '')
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  claveValor(
                                      'Certificador: ',
                                      encabezado[0].certificador,
                                      MainAxisAlignment.start),
                                  claveValor('NIT: ', encabezado[0].nitCert,
                                      MainAxisAlignment.start),
                                  claveValor('Fecha: ', encabezado[0].fechaCert,
                                      MainAxisAlignment.start),
                                ],
                              )
                            : Container(),

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
        onPressed: () {
            //codigo de impresion
             _printerManager.scanResults.listen((devices) async {
                print(devices);
                                            
                if (Preferencias.mac == '') {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        if (devices.length == 0) {
                          return const AlertDialog(
                            backgroundColor:
                                Color.fromARGB(255,
                                    236, 133, 115),
                            content: Text(
                              'No se encontraron impresoras disponibles.',
                              style: TextStyle(
                                  color:
                                      Colors.white),
                            ),
                          );
                        }

                        return AlertDialog(
                          title: const Text(
                              'Impresoras Disponibles'),
                          content: Container(
                            height:
                                300.0, // Change as per your requirement
                            width:
                                300.0, // Change as per your requirement
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  devices.length,
                              itemBuilder:
                                  (BuildContext
                                          context,
                                      int i) {
                                return ListTile(
                                  title: Text(
                                      "${devices[i].name}"),
                                  subtitle: Text(
                                      "${devices[i].address}"),
                                  trailing: Row(
                                    mainAxisSize:
                                        MainAxisSize
                                            .min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          
                                          _printerManager
                                              .stopScan();
                                          _startPrint( devices[i], widget.factura);
                                        },
                                        child:
                                            Container(
                                          margin:
                                              const EdgeInsets.all(
                                                  5),
                                          padding:
                                              const EdgeInsets.all(
                                                  10),
                                          decoration: BoxDecoration(
                                              //color: Theme.of(context).primaryColor,
                                              color: widget.colorPrimary,
                                              borderRadius: BorderRadius.circular(15)),
                                          child:
                                              const Icon(
                                            Icons
                                                .print,
                                            color: Colors
                                                .white,
                                            size:
                                                25,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  onTap: () {},
                                );
                              },
                            ),
                          ),
                        );
                      }));
                } else {
                  //impresion en predeterminada

                  devices.forEach((printer) async {
                    print(printer);
                    //get saved printer
                    if (printer.address ==
                        Preferencias.mac) {
                      //store the element.
                      await _startPrint(printer, widget.factura);
                    }
                  });
                }                    
                                            
              });
            
            //codigo de impresion
        },
        style: TextButton.styleFrom(
          backgroundColor: widget.colorPrimary,
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

  ListView Listdata(String moneda, List<Detalle> detalle) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: detalle.length,
      itemBuilder: (context, index) {
        double tota = double.parse(detalle[index].cantidad) *
            double.parse(detalle[index].precio);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SimpleText(detalle[index].producto, 16, TextAlign.start),
                  SimpleText(
                      '${detalle[index].cantidad} * ${moneda}${detalle[index].precio}',
                      12,
                      TextAlign.start),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(right: 20),
                child: SimpleText('${moneda}${tota}', 16, TextAlign.end))
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
  
  Future<void> _startPrint(PrinterBluetooth printer, String id_factura) async {
    _printerManager.selectPrinter(printer);
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        backgroundColor: Color.fromARGB(255, 115, 160, 236),
        content: Text(
          'Imprimiendo...',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    final result = await _printerManager.printTicket(
        await testTicket(id_factura));
    Navigator.of(context, rootNavigator: true).pop(result);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: (result.msg == 'Success')
            ? const Color.fromARGB(255, 109, 224, 186)
            : const Color.fromARGB(255, 201, 124, 124),
        content: Text(
          (result.msg == 'Success') ? 'Listo..' : result.msg,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<List<int>> testTicket(String id_factura) async {

    final print_data = Provider.of<PrintProvider>(context, listen: false);
    List<Encabezado> encabezado = print_data.list;
    List<Detalle> detalle = print_data.list_detalle;

    int sede = 0;
    //0= empresa
    //1= sucursal
    if ((encabezado[0].fel == '0' && encabezado[0].felSucu == '1') ||
        (encabezado[0].fel == '1' && encabezado[0].felSucu == '1')) {
      sede = 1;
    } else if (encabezado[0].fel == '1' &&
        encabezado[0].felSucu == '0') {
      sede = 0;
    }


    // Using default profile
    final profile = await CapabilityProfile.load();
    final generatorr = Generator(PaperSize.mm58, profile);
    
    List<int> bytess = [];
    bytess+=generatorr.setGlobalCodeTable('CP1252');

    //nombre de la empresa
    (sede == 1)?
    bytess += generatorr.text(encabezado[0].nombreEmpresaSucu,
        styles: const PosStyles(
            codeTable: 'CP1252',
            align: PosAlign.center,
            bold: true,
            width: PosTextSize.size2))
    :
    bytess += generatorr.text(encabezado[0].nombreEmpresa,
        styles: const PosStyles(
            codeTable: 'CP1252',
            align: PosAlign.center,
            bold: true,
            width: PosTextSize.size2));

    //DIreccion empresa
    (sede == 1)?
    bytess += generatorr.text(encabezado[0].direccionSucu,
        styles: const PosStyles(
                width: PosTextSize.size1, bold: true, codeTable: 'CP1252')
            .copyWith(align: PosAlign.center))
    :
    bytess += generatorr.text(encabezado[0].direccion,
        styles: const PosStyles(
                width: PosTextSize.size1, bold: true, codeTable: 'CP1252')
            .copyWith(align: PosAlign.center));

    //NIT EMPRESA
    if(encabezado[0].nit_emisor != ''){
        bytess += generatorr.text('NIT: ${encabezado[0].nit_emisor}',
        styles: const PosStyles(
                width: PosTextSize.size1, bold: true, codeTable: 'CP1252')
            .copyWith(align: PosAlign.center));
    }

    //TELEFONO EMPRESA
    if(sede == 1){
      
      if(encabezado[0].teleSucu != ''){
        bytess += generatorr.text('Teléfono: ${encabezado[0].teleSucu}',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));
      }
    }else if(encabezado[0].telefono != ''){

      bytess += generatorr.text('Teléfono: ${encabezado[0].telefono}',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    }

    //espacio
    bytess += generatorr.feed(1);

    //NOMBRE COMERCIAL
    if(sede == 1){
      if(encabezado[0].nombre_comercial_sucu != ''){
        bytess += generatorr.text(encabezado[0].nombre_comercial_sucu,
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));
      }
    }else if(encabezado[0].nombre_comercial_emp != ''){
      bytess += generatorr.text(encabezado[0].nombre_comercial_emp,
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));
    }

    //espacio
    bytess += generatorr.feed(1);

    //FEL
    if(encabezado[0].dte != ''){
      bytess += generatorr.text('Factura Electrónica Documento Tributario',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));
    }
    

    //espacio
    bytess += generatorr.feed(1);

    //FECHA EMITIDA
    bytess += generatorr.text(encabezado[0].fecha_letras,
        styles: const PosStyles(
            align: PosAlign.right,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //AUTORIZACION
    if(encabezado[0].dte != ''){

        bytess += generatorr.text('Número de Autorización:',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

        bytess += generatorr.text(encabezado[0].dte,
            styles: const PosStyles(
                align: PosAlign.center,
                width: PosTextSize.size1,
                bold: true,
                codeTable: 'CP1252'));

        bytess += generatorr.text('Serie: ${encabezado[0].serieDte}',
            styles: const PosStyles(
                align: PosAlign.center,
                width: PosTextSize.size1,
                bold: true,
                codeTable: 'CP1252'));

        bytess += generatorr.text('Número de DTE: ${encabezado[0].noDte}',
            styles: const PosStyles(
                align: PosAlign.center,
                width: PosTextSize.size1,
                bold: true,
                codeTable: 'CP1252'));

    }
    

    //espacio
    bytess += generatorr.feed(1);

    //No
    bytess += generatorr.text('No: ${ encabezado[0].no}',
        styles: const PosStyles(
            align: PosAlign.right,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //SERIE
    bytess += generatorr.text('Serie: ${encabezado[0].serie}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //VENDEDOR
    bytess += generatorr.text('Vendedor : ${encabezado[0].nombreV} ${encabezado[0].apellidosV}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //CLIENTE
    bytess += generatorr.text('Cliente: ${encabezado[0].nombre} ${encabezado[0].apellidos}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //NIT CLIENTE
    bytess += generatorr.text('NIT: ${encabezado[0].nit}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //DIRECCION CLIENTE
    if(encabezado[0].direccionCli != ''){
      bytess += generatorr.text('Dirección: ${encabezado[0].direccionCli}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));
    }
    

    //espacio
    bytess += generatorr.feed(1);

    //CONDICIONES DE PAGO
    bytess += generatorr.text('Condiciónes de pago:',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    bytess += generatorr.text('${encabezado[0].forma}',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //TABLA PRODUCTOS
    bytess += generatorr.row([
      PosColumn(
        text: 'Descripción',
        width: 9,
        styles: const PosStyles(align: PosAlign.left, underline: true),
      ),
      PosColumn(
        text: 'Subtotal',
        width: 3,
        styles: const PosStyles(align: PosAlign.right, underline: true),
      ),
    ]);




    //Detalle productos
    for(int al=0;al<detalle.length;al++){

      double tota = double.parse(detalle[al].cantidad) *
            double.parse(detalle[al].precio);
      bytess += generatorr.row([
        PosColumn(
          text: '${detalle[al].producto}',
          width: 9,
          styles: const PosStyles(align: PosAlign.left, underline: true),
        ),
        PosColumn(
          text: '',
          width: 3,
          styles: const PosStyles(align: PosAlign.right, underline: true),
        ),
      ]);
      bytess += generatorr.row([
        PosColumn(
          text: '${detalle[al].cantidad} * ${detalle[al].contenido}${detalle[al].precio}',
          width: 9,
          styles: const PosStyles(align: PosAlign.left, underline: true),
        ),
        PosColumn(
          text: '${detalle[al].contenido}${tota}',
          width: 3,
          styles: const PosStyles(align: PosAlign.right, underline: true),
        ),
      ]);


    }

    //DESCUENTOS
    bytess += generatorr.row([
      PosColumn(
        text: 'Descuento(-):',
        width: 9,
        styles: const PosStyles(align: PosAlign.right, underline: true),
      ),
      PosColumn(
        text: encabezado[0].contenido + encabezado[0].descuento,
        width: 3,
        styles: const PosStyles(align: PosAlign.right, underline: true),
      ),
    ]);
    

    //TOTAL PRODUCTOS
    bytess += generatorr.row([
      PosColumn(
        text: 'Total:',
        width: 9,
        styles: const PosStyles(align: PosAlign.right, underline: true),
      ),
      PosColumn(
        text: encabezado[0].contenido + encabezado[0].total,
        width: 3,
        styles: const PosStyles(align: PosAlign.right, underline: true),
      ),
    ]);

    //espacio
    bytess += generatorr.feed(1);

    //TOTAL LETRAS
    bytess += generatorr.text('${encabezado[0].totalLetas}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            bold: true,
            codeTable: 'CP1252'));

    //espacio
    bytess += generatorr.feed(1);

    //Frases
    for(int rl=0;rl<encabezado[0].frases.length;rl++){
      bytess += generatorr.text(encabezado[0].frases[rl],
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));
    }

    //espacio
    bytess += generatorr.feed(1);

    //DATOS DE CERTIFICADOR
    if(encabezado[0].dte != ''){

      bytess += generatorr.text('Certificador: ${encabezado[0].certificador}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

      bytess += generatorr.text('NIT: ${encabezado[0].nitCert}',
          styles: const PosStyles(
              align: PosAlign.left,
              width: PosTextSize.size1,
              codeTable: 'CP1252'));

      bytess += generatorr.text('Fecha: ${encabezado[0].fechaCert}',
          styles: const PosStyles(
              align: PosAlign.left,
              width: PosTextSize.size1,
              codeTable: 'CP1252'));

    }
    

    //espacio
    bytess += generatorr.feed(1);

    //datos del sistema
    bytess += generatorr.text('Factura realizada en www.gozeri.com',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));
            
    bytess += generatorr.cut();
    return bytess;
  }

}


