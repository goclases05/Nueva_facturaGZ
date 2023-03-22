import 'package:al_downloader/al_downloader.dart';
import 'package:edge_alerts/edge_alerts.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:factura_gozeri/global/globals.dart';
import 'package:factura_gozeri/models/view_factura_print.dart';
import 'package:factura_gozeri/providers/factura_provider.dart';
import 'package:factura_gozeri/providers/print_provider.dart';
import 'package:factura_gozeri/widgets/registro_metodoPago_listas_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

import 'escritorio_screen.dart';

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

  //SUNMIN
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  String estado = '';
  //SUNMIN

  @override
  void initState() {
    super.initState();
    estado = widget.estado;
    // TODO: implement initState
    if (Preferencias.sunmi_preferencia) {
      _bindingPrinter().then((bool? isBind) async {
        SunmiPrinter.paperSize().then((int size) {
          setState(() {
            paperSize = size;
          });
        });

        SunmiPrinter.printerVersion().then((String version) {
          setState(() {
            printerVersion = version;
          });
        });

        SunmiPrinter.serialNumber().then((String serial) {
          setState(() {
            serialNumber = serial;
          });
        });

        setState(() {
          printBinded = isBind!;
        });
      });
    } else {
      _printerManager.startScan(const Duration(seconds: 2));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (Preferencias.sunmi_preferencia == false) {
      _printerManager.stopScan();
    }
    super.dispose();
  }

  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final facturaService = Provider.of<Facturacion>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const EscritorioScreen(),
          ),
        ).then((value) => setState(() {}));
        return false;
      },
      child: Scaffold(
          backgroundColor: Color.fromRGBO(246, 243, 244, 1),
          appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: widget.colorPrimary,
              elevation: 2,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Factura: ',
                      style: TextStyle(color: widget.colorPrimary)),
                  Chip(
                      padding: const EdgeInsets.all(1),
                      backgroundColor: (estado == '2')
                          ? Color.fromARGB(255, 28, 192, 28)
                          : (estado == '1')
                              ? Color.fromARGB(255, 233, 195, 72)
                              : const Color.fromARGB(255, 232, 116, 107),
                      label: Text(
                        (estado == '2')
                            ? 'Pagada'
                            : (estado == '1')
                                ? 'Pendiente de Pago'
                                : 'Anulada',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      )),
                ],
              ),
              actions: [
                (estado != '0')
                    ? CircleAvatar(
                        backgroundColor: Colors.red,
                        child: IconButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  title: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.red),
                                        ),
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        child: Text(
                                          'Anular',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                              fontSize: 25),
                                        ),
                                      ),
                                      const Text('¿Estas Seguro?',
                                          style: TextStyle(
                                            fontSize: 15,
                                          )),
                                      const Text(
                                          'Estas a punto de anular esta factura',
                                          style: TextStyle(
                                            fontSize: 15,
                                          )),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text('No')),
                                    TextButton(
                                        onPressed: () async {
                                          var data = await facturaService
                                              .anular_factura(widget.factura);
                                          if (data == '1') {
                                            edgeAlert(context,
                                                title: 'Listo!',
                                                description: 'Factura anulada.',
                                                gravity: Gravity.top,
                                                backgroundColor: Color.fromARGB(
                                                    255, 81, 131, 83));
                                            setState(() {
                                              estado = '0';
                                            });
                                          } else {
                                            edgeAlert(context,
                                                title: 'Error',
                                                description: '${data}',
                                                gravity: Gravity.top,
                                                backgroundColor: Color.fromARGB(
                                                    255, 165, 65, 26));
                                          }
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text('Si'))
                                  ],
                                );
                              }),
                            );
                          },
                          icon: Icon(Icons.close),
                          color: Colors.white,
                        ),
                      )
                    : SizedBox(
                        width: 1,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  placeholder:
                                      AssetImage('assets/productos_gz.jpg'),
                                  image: NetworkImage(encabezado[0].rutaSucu +
                                      encabezado[0].foto))
                              :
                              //empresa
                              FadeInImage(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
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
                              : SimpleText(encabezado[0].direccion, 15,
                                  TextAlign.center),

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
                                  ? SimpleText(
                                      encabezado[0].nombre_comercial_emp,
                                      15,
                                      TextAlign.center)
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
                          (estado != '2' && estado != '1')
                              ? Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Text(
                                    'Anulada',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 25),
                                  ),
                                )
                              : Text(''),

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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
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
                          TitleText(
                              'Condiciones de pago:', 15, TextAlign.center),

                          claveValor(encabezado[0].forma, '',
                              MainAxisAlignment.center),

                          const SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            title:
                                TitleText('Descripción', 16, TextAlign.start),
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
                                    claveValor(
                                        'Fecha: ',
                                        encabezado[0].fechaCert,
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
          )),
    );
  }

  Container sheetButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              (widget.estado == '1')
                  ? Expanded(
                      flex: 2,
                      child: TextButton.icon(
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 65, 153, 94)),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                content: RegistroMetodoPagoListas(
                                    colorPrimary: widget.colorPrimary,
                                    id_f: widget.factura,
                                    estado: '1'),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.payment_rounded,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Efectuar Pago',
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  : Text(''),
              SizedBox(
                width: 2,
              ),
              Expanded(
                child: TextButton.icon(
                    style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 221, 115, 108)),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (_) => const AlertDialog(
                          backgroundColor: Color.fromARGB(255, 115, 160, 236),
                          content: ListTile(
                            leading:
                                CircularProgressIndicator(color: Colors.white),
                            title: Text(
                              'Generando archivo...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );

                      final print_data =
                          Provider.of<PrintProvider>(context, listen: false);
                      var data = await print_data.pdf_factura(widget.factura);
                      print('fuera');
                      print('fuera' + data.toString());
                      if (data['message'] == 'no') {
                        print('ya salio');
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          Navigator.of(context, rootNavigator: true).pop();
                        });
                        //
                      } else if (data['message'] == 'Ok') {
                        ///descarga de archivos
                        final status = await Permission.storage.request();
                        if (status.isGranted) {
                          showDialog(
                            context: context,
                            builder: (_) => const AlertDialog(
                              backgroundColor:
                                  Color.fromARGB(255, 225, 130, 28),
                              content: ListTile(
                                leading: CircularProgressIndicator(
                                    color: Colors.white),
                                title: Text(
                                  'descargando...',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                          final basestorage =
                              await getApplicationDocumentsDirectory();
                          String url = data['link'];
                          ALDownloader.configurePrint(
                              enabled: true, frequentEnabled: false);
                          ALDownloader.download(url,
                              directoryPath: basestorage!.path,
                              fileName: data['name'],
                              downloaderHandlerInterface:
                                  ALDownloaderHandlerInterface(
                                      progressHandler: (progress) {
                                debugPrint(
                                    'ALDownloader | download progress = $progress, url = $url\n');
                              }, succeededHandler: () async {
                                debugPrint(
                                    'ALDownloader | download succeeded, url = $url\n');
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                //print('la ruta: '+basestorage.path+'/nuevo.pdf');
                                final String filePath =
                                    basestorage.path + '/' + data['name'];
                                OpenFilex.open(filePath);
                              }, failedHandler: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor:
                                        Color.fromARGB(255, 224, 211, 18),
                                    content: ListTile(
                                      leading: Icon(
                                        Icons.warning,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        'Fallo la descarga por favor intentalo de nuevo',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              }, pausedHandler: () {
                                debugPrint(
                                    'ALDownloader | download paused, url = $url\n');
                              }));
                        } else {
                          print('no permision');
                        }
                      }
                    },
                    icon: Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Generar',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            color: const Color.fromRGBO(246, 243, 244, 1),
            width: MediaQuery.of(context).size.width * 1,
            child: TextButton.icon(
              onPressed: () {
                //codigo de impresion
                if (Preferencias.sunmi_preferencia) {
                  print_sunmi(context, widget.factura);
                } else {
                  _printerManager.scanResults.listen((devices) async {
                    print(devices);

                    if (Preferencias.mac == '') {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            if (devices.length == 0) {
                              return const AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(255, 236, 133, 115),
                                content: Text(
                                  'No se encontraron impresoras disponibles.',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }

                            return AlertDialog(
                              title: const Text('Impresoras Disponibles'),
                              content: Container(
                                height: 300.0, // Change as per your requirement
                                width: 300.0, // Change as per your requirement
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: devices.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return ListTile(
                                      title: Text("${devices[i].name}"),
                                      subtitle: Text("${devices[i].address}"),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _printerManager.stopScan();
                                              _startPrint(
                                                  devices[i], widget.factura);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(5),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  //color: Theme.of(context).primaryColor,
                                                  color: widget.colorPrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: const Icon(
                                                Icons.print,
                                                color: Colors.white,
                                                size: 25,
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
                        if (printer.address == Preferencias.mac) {
                          //store the element.
                          await _startPrint(printer, widget.factura);
                        }
                      });
                    }
                  });
                }
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
          ),
        ],
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
    final result =
        await _printerManager.printTicket(await testTicket(id_factura));
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
    } else if (encabezado[0].fel == '1' && encabezado[0].felSucu == '0') {
      sede = 0;
    }

    // Using default profile
    final profile = await CapabilityProfile.load();
    final generatorr = Generator(PaperSize.mm58, profile);

    List<int> bytess = [];
    bytess += generatorr.setGlobalCodeTable('CP1252');

    //nombre de la empresa
    (sede == 1)
        ? bytess += generatorr.text(encabezado[0].nombreEmpresaSucu,
            styles: const PosStyles(
                codeTable: 'CP1252',
                align: PosAlign.center,
                bold: true,
                width: PosTextSize.size1))
        : bytess += generatorr.text(encabezado[0].nombreEmpresa,
            styles: const PosStyles(
                codeTable: 'CP1252',
                align: PosAlign.center,
                bold: true,
                width: PosTextSize.size1));

    //DIreccion empresa
    (sede == 1)
        ? bytess += generatorr.text(encabezado[0].direccionSucu,
            styles: const PosStyles(
                    width: PosTextSize.size1, bold: true, codeTable: 'CP1252')
                .copyWith(align: PosAlign.center))
        : bytess += generatorr.text(encabezado[0].direccion,
            styles: const PosStyles(
                    width: PosTextSize.size1, bold: true, codeTable: 'CP1252')
                .copyWith(align: PosAlign.center));

    //NIT EMPRESA
    if (encabezado[0].nit_emisor != '') {
      bytess += generatorr.text('NIT: ${encabezado[0].nit_emisor}',
          styles: const PosStyles(
                  width: PosTextSize.size1, bold: true, codeTable: 'CP1252')
              .copyWith(align: PosAlign.center));
    }

    //TELEFONO EMPRESA
    if (sede == 1) {
      if (encabezado[0].teleSucu != '') {
        bytess += generatorr.text('Teléfono: ${encabezado[0].teleSucu}',
            styles: const PosStyles(
                align: PosAlign.center,
                width: PosTextSize.size1,
                bold: true,
                codeTable: 'CP1252'));
      }
    } else if (encabezado[0].telefono != '') {
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
    if (sede == 1) {
      if (encabezado[0].nombre_comercial_sucu != '') {
        bytess += generatorr.text(encabezado[0].nombre_comercial_sucu,
            styles: const PosStyles(
                align: PosAlign.center,
                width: PosTextSize.size1,
                bold: true,
                codeTable: 'CP1252'));
      }
    } else if (encabezado[0].nombre_comercial_emp != '') {
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
    if (encabezado[0].dte != '') {
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
    if (encabezado[0].dte != '') {
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
    bytess += generatorr.text('No: ${encabezado[0].no}',
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
    bytess += generatorr.text(
        'Vendedor : ${encabezado[0].nombreV} ${encabezado[0].apellidosV}',
        styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    //CLIENTE
    bytess += generatorr.text(
        'Cliente: ${encabezado[0].nombre} ${encabezado[0].apellidos}',
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
    if (encabezado[0].direccionCli != '') {
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
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: 'Subtotal',
        width: 3,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    //Detalle productos
    for (int al = 0; al < detalle.length; al++) {
      double tota =
          double.parse(detalle[al].cantidad) * double.parse(detalle[al].precio);
      bytess += generatorr.row([
        PosColumn(
          text: '${detalle[al].producto}',
          width: 9,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: '',
          width: 3,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      bytess += generatorr.row([
        PosColumn(
          text:
              '${detalle[al].cantidad} * ${detalle[al].contenido}${detalle[al].precio}',
          width: 9,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: '${detalle[al].contenido}${tota}',
          width: 3,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    //DESCUENTOS
    bytess += generatorr.row([
      PosColumn(
        text: 'Descuento(-):',
        width: 9,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
      PosColumn(
        text: encabezado[0].contenido + encabezado[0].descuento,
        width: 3,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    //TOTAL PRODUCTOS
    bytess += generatorr.row([
      PosColumn(
        text: 'Total:',
        width: 9,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
      PosColumn(
        text: encabezado[0].contenido + encabezado[0].total,
        width: 3,
        styles: const PosStyles(align: PosAlign.right, bold: true),
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
    for (int rl = 0; rl < encabezado[0].frases.length; rl++) {
      bytess += generatorr.text(encabezado[0].frases[rl],
          styles: const PosStyles(
              align: PosAlign.center,
              width: PosTextSize.size1,
              codeTable: 'CP1252'));
    }

    //espacio
    bytess += generatorr.feed(1);

    //DATOS DE CERTIFICADOR
    if (encabezado[0].dte != '') {
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
    bytess += generatorr.text('Realizado en www.gozeri.com',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size1,
            codeTable: 'CP1252'));

    bytess += generatorr.cut();
    return bytess;
  }
}

print_sunmi(BuildContext context, String id_factura) async {
  final print_data = Provider.of<PrintProvider>(context, listen: false);
  List<Encabezado> encabezado = print_data.list;
  List<Detalle> detalle = print_data.list_detalle;

  int sede = 0;
  //0= empresa
  //1= sucursal
  if ((encabezado[0].fel == '0' && encabezado[0].felSucu == '1') ||
      (encabezado[0].fel == '1' && encabezado[0].felSucu == '1')) {
    sede = 1;
  } else if (encabezado[0].fel == '1' && encabezado[0].felSucu == '0') {
    sede = 0;
  }
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

  await SunmiPrinter.initPrinter();
  await SunmiPrinter.startTransactionPrint(true);

  /*if (sede == 1) {
    if (encabezado[0].foto != '') {
      String url = encabezado[0].rutaSucu + encabezado[0].foto;
      // convert image to Uint8List format
      Uint8List byte = (await NetworkAssetBundle(Uri.parse(url)).load(url))
          .buffer
          .asUint8List();
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.startTransactionPrint(true);
      await SunmiPrinter.printImage(byte);
    }
  } else {
    if (encabezado[0].logoNom != '') {
      String url = encabezado[0].logoUrl + encabezado[0].logoNom;
      // convert image to Uint8List format
      Uint8List byte = (await NetworkAssetBundle(Uri.parse(url)).load(url))
          .buffer
          .asUint8List();
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.startTransactionPrint(true);
      await SunmiPrinter.printImage(byte);
    }
  }*/
  //await SunmiPrinter.lineWrap(2);

  //nombre de empresa
  await SunmiPrinter.printText(
      (sede == 1)
          ? '${encabezado[0].nombreEmpresaSucu}'
          : '${encabezado[0].nombreEmpresa}',
      style: SunmiStyle(
        bold: true,
        align: SunmiPrintAlign.CENTER,
      ));

  //Direccion de empresa
  await SunmiPrinter.printText(
      (sede == 1)
          ? '${encabezado[0].direccionSucu}'
          : '${encabezado[0].direccion}',
      style: SunmiStyle(
        bold: true,
        align: SunmiPrintAlign.CENTER,
      ));

  //nit emisor
  if (encabezado[0].nit_emisor != '') {
    await SunmiPrinter.printText('NIT: ${encabezado[0].nit_emisor}',
        style: SunmiStyle(
          bold: true,
          align: SunmiPrintAlign.CENTER,
        ));
  }

  //telefono emisor
  if (sede == 1) {
    if (encabezado[0].teleSucu != '') {
      await SunmiPrinter.printText('Tel: ${encabezado[0].teleSucu}',
          style: SunmiStyle(
            bold: true,
            align: SunmiPrintAlign.CENTER,
          ));
    }
  } else {
    if (encabezado[0].telefono != '') {
      await SunmiPrinter.printText('Tel: ${encabezado[0].telefono}',
          style: SunmiStyle(
            bold: true,
            align: SunmiPrintAlign.CENTER,
          ));
    }
  }

  //await SunmiPrinter.lineWrap(1);

  //nombre comercial
  if (sede == 1) {
    if (encabezado[0].nombre_comercial_sucu != '') {
      await SunmiPrinter.printText('${encabezado[0].nombre_comercial_sucu}',
          style: SunmiStyle(
            bold: true,
            align: SunmiPrintAlign.CENTER,
          ));
    }
  } else {
    if (encabezado[0].nombre_comercial_emp != '') {
      await SunmiPrinter.printText('${encabezado[0].nombre_comercial_emp}',
          style: SunmiStyle(
            bold: true,
            align: SunmiPrintAlign.CENTER,
          ));
    }
  }

  //await SunmiPrinter.lineWrap(1);
  //FEL
  if (encabezado[0].dte != '') {
    await SunmiPrinter.printText('Factura Electrónica Documento Tributario',
        style: SunmiStyle(
          bold: true,
          align: SunmiPrintAlign.CENTER,
        ));
  }

  //await SunmiPrinter.lineWrap(1);

  //FECHA EN LETRAS
  await SunmiPrinter.printText('${encabezado[0].fecha_letras}',
      style: SunmiStyle(
        bold: false,
        align: SunmiPrintAlign.RIGHT,
      ));

  //await SunmiPrinter.lineWrap(1);

  if (encabezado[0].dte != '') {
    await SunmiPrinter.printText('Número de Autorización:',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.CENTER,
        ));
    await SunmiPrinter.printText('${encabezado[0].dte}',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.CENTER,
        ));
    await SunmiPrinter.printText('Serie: ${encabezado[0].serieDte}',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.CENTER,
        ));
    await SunmiPrinter.printText('Número de DTE: ${encabezado[0].noDte}',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.CENTER,
        ));
  }

  //await SunmiPrinter.lineWrap(1);

  //No
  await SunmiPrinter.printText('No: ${encabezado[0].no}',
      style: SunmiStyle(
        bold: false,
        align: SunmiPrintAlign.RIGHT,
      ));

  //await SunmiPrinter.lineWrap(1);

  //serie
  await SunmiPrinter.printText('Serie: ${encabezado[0].serie}',
      style: SunmiStyle(
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ));

  //vendedor
  await SunmiPrinter.printText(
      'Vendedor : ${encabezado[0].nombreV} ${encabezado[0].apellidosV}',
      style: SunmiStyle(
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ));
  //cliente
  await SunmiPrinter.printText(
      'Cliente: ${encabezado[0].nombre} ${encabezado[0].apellidos}',
      style: SunmiStyle(
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ));
  //nit cliente
  await SunmiPrinter.printText('NIT: ${encabezado[0].nit}',
      style: SunmiStyle(
        bold: false,
        align: SunmiPrintAlign.LEFT,
      ));

  //direccion cliente
  if (encabezado[0].direccionCli != '') {
    await SunmiPrinter.printText('Dirección: ${encabezado[0].direccionCli}',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.LEFT,
        ));
  }

  await SunmiPrinter.lineWrap(1);

  //condiciones de pago
  await SunmiPrinter.printText('Condiciones de pago:',
      style: SunmiStyle(
        bold: true,
        align: SunmiPrintAlign.CENTER,
      ));
  //forma
  await SunmiPrinter.printText('${encabezado[0].forma}',
      style: SunmiStyle(
        bold: true,
        align: SunmiPrintAlign.CENTER,
      ));

  //await SunmiPrinter.lineWrap(1);

  await SunmiPrinter.line();
  await SunmiPrinter.printRow(cols: [
    ColumnMaker(text: 'Descripción', width: 20, align: SunmiPrintAlign.LEFT),
    ColumnMaker(text: 'Subtotal', width: 10, align: SunmiPrintAlign.CENTER),
  ]);
  await SunmiPrinter.line();

  //DETALLES
  for (int al = 0; al < detalle.length; al++) {
    double tota =
        double.parse(detalle[al].cantidad) * double.parse(detalle[al].precio);
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
          text: '${detalle[al].producto}',
          width: 24,
          align: SunmiPrintAlign.LEFT),
      ColumnMaker(text: '', width: 6, align: SunmiPrintAlign.CENTER),
    ]);

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
          text:
              '${detalle[al].cantidad} * ${detalle[al].contenido}${detalle[al].precio}',
          width: 20,
          align: SunmiPrintAlign.LEFT),
      ColumnMaker(
          text: '${detalle[al].contenido}${tota}',
          width: 10,
          align: SunmiPrintAlign.RIGHT),
    ]);
  }
  await SunmiPrinter.line();
  await SunmiPrinter.printRow(cols: [
    ColumnMaker(text: 'Descuento(-):', width: 20, align: SunmiPrintAlign.RIGHT),
    ColumnMaker(
        text: encabezado[0].contenido + encabezado[0].descuento,
        width: 10,
        align: SunmiPrintAlign.CENTER),
  ]);
  await SunmiPrinter.printRow(cols: [
    ColumnMaker(text: 'Total:', width: 20, align: SunmiPrintAlign.RIGHT),
    ColumnMaker(
        text: encabezado[0].contenido + encabezado[0].total,
        width: 10,
        align: SunmiPrintAlign.CENTER),
  ]);
  //await SunmiPrinter.lineWrap(1);

  //total en letras
  await SunmiPrinter.printText('${encabezado[0].totalLetas}',
      style: SunmiStyle(
        bold: true,
        align: SunmiPrintAlign.CENTER,
      ));

  //frases
  for (int rl = 0; rl < encabezado[0].frases.length; rl++) {
    await SunmiPrinter.printText('${encabezado[0].frases[rl]}',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.CENTER,
        ));
  }

  //datos certificador
  if (encabezado[0].dte != '') {
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('Certificador: ${encabezado[0].certificador}',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.LEFT,
        ));
    await SunmiPrinter.printText('NIT: ${encabezado[0].nitCert}',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.LEFT,
        ));
    await SunmiPrinter.printText('Fecha: ${encabezado[0].fechaCert}',
        style: SunmiStyle(
          bold: false,
          align: SunmiPrintAlign.LEFT,
        ));
  }

  //await SunmiPrinter.lineWrap(1);
  await SunmiPrinter.printText('Realizado en www.gozeri.com',
      style: SunmiStyle(
        bold: false,
        align: SunmiPrintAlign.CENTER,
      ));

  /*await SunmiPrinter.printQRCode('https://github.com/brasizza/sunmi_printer');
  await SunmiPrinter.printText('Normal font',
      style: SunmiStyle(fontSize: SunmiFontSize.MD));*/
  await SunmiPrinter.lineWrap(2);
  await SunmiPrinter.exitTransactionPrint(true);
}
