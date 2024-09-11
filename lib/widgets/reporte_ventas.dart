import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:al_downloader/al_downloader.dart';
import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:factura_gozeri/providers/reportes_provider.dart';
import 'package:factura_gozeri/services/auth_services.dart';
import 'package:factura_gozeri/widgets/screen_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_pdf/share_pdf.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:url_launcher/url_launcher.dart';

class Reporte_Ventas extends StatefulWidget {
  Reporte_Ventas({super.key, required this.colo, required this.context});
  Color colo;
  BuildContext context;
  bool isMount = true;

  @override
  State<Reporte_Ventas> createState() => _Reporte_VentasState();
}

class _Reporte_VentasState extends State<Reporte_Ventas> {
  //String selectedValue1 = "${Preferencias.sucursal}";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ALDownloader.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(DropdownMenuItem(
        child: Text(
          'Todas las sucursales',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
        value: 'all'));
    ;
    for (var i = 0; i < authService.list_sucu.length; i++) {
      menuItems.add(DropdownMenuItem(
          child: Text(
            authService.list_sucu[i].nombre,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
          value: authService.list_sucu[i].idSucursal));
      ;
    }
    return Material(
        color: widget.colo.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    color: Color.fromRGBO(0, 0, 0, 0.001),
                    child: GestureDetector(
                      onTap: () {},
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.8,
                        minChildSize: 0.2,
                        maxChildSize: 1,
                        builder: (_, controller) {
                          return Consumer<ReporteProvider>(
                              builder: (context, reporteservices, child) {
                            //empieza sheet

                            return Container(
                              color: Colors.white,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        color: widget.colo.withOpacity(0.1),
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                          'Reporte de Ventas ',
                                          style: TextStyle(
                                              color: widget.colo,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )),
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          //******************************************************************** */
                                          Container(
                                            padding: const EdgeInsets.only(
                                                top: 8, right: 8, bottom: 8),
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              direction: Axis.horizontal,
                                              children: [
                                                Text(
                                                  'Seleccióna una Sucursal:',
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                Divider(),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: widget.colo),
                                                    //borderRadius: BorderRadius.circular(30),
                                                    color: Colors.white,
                                                    //color: Color.fromARGB(255, 219, 219, 219),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 0,
                                                      horizontal: 10),
                                                  child: DropdownButton(
                                                    //key: keysucursal,
                                                    isExpanded: true,
                                                    itemHeight: null,
                                                    value: reporteservices
                                                        .id_sucu_reportes,
                                                    dropdownColor: Colors.white,
                                                    onChanged:
                                                        (String? newValue) {
                                                      // check whether the state object is in tree
                                                      reporteservices
                                                          .id_suc_reporte(
                                                              newValue!);

                                                      //Preferencias.sucursal = selectedValue;*/
                                                    },
                                                    items: menuItems,
                                                    elevation: 0,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    //icon: Icon(Icons.arrow_drop_down),
                                                    underline: SizedBox(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'Seleccióna un rango de fecha:',
                                            style: TextStyle(fontSize: 14),
                                            textAlign: TextAlign.left,
                                          ),
                                          Divider(),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SfDateRangePicker(
                                            selectionMode:
                                                DateRangePickerSelectionMode
                                                    .range,
                                            initialSelectedDate: DateTime.now(),
                                            onSelectionChanged: (date) {
                                              print('se selecciono');
                                              if (date.value
                                                  is PickerDateRange) {
                                                //print(date.value);
                                                reporteservices.fecha_inicio =
                                                    '${DateFormat('yyyy-MM-dd').format(date.value.startDate)}';
                                                reporteservices.fecha_fin =
                                                    '${DateFormat('yyyy-MM-dd').format(date.value.endDate ?? date.value.startDate)}';
                                              } else if (date.value
                                                  is DateTime) {
                                                reporteservices.fecha_inicio =
                                                    '${DateFormat('yyyy-MM-dd').format(date.value.startDate)}';
                                                reporteservices.fecha_fin =
                                                    '${DateFormat('yyyy-MM-dd').format(date.value.startDate)}';
                                              } else {
                                                print('no es rango');
                                              }

                                              /*print(date.value.startDate);
                                              reporteservices.fecha_inicio =
                                                  '${DateFormat('yyyy-MM-dd').format(date.value.startDate)}';
                                              if (date.value.endDate != null) {
                                                reporteservices.fecha_fin =
                                                    '${DateFormat('yyyy-MM-dd').format(date.value.startDate)}';
                                              } else {
                                                reporteservices.fecha_fin =
                                                    '${DateFormat('yyyy-MM-dd').format(date.value.endDate ?? date.value.startDate)}';
                                              }*/
                                            },
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll<Color>(
                                                                Color.fromARGB(
                                                                    255,
                                                                    159,
                                                                    22,
                                                                    13)),
                                                        iconColor:
                                                            MaterialStatePropertyAll<Color>(
                                                                Colors.white),
                                                        textStyle:
                                                            MaterialStatePropertyAll<TextStyle>(
                                                                TextStyle(
                                                                    color: Colors
                                                                        .white))),
                                                    onPressed: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            const AlertDialog(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  115,
                                                                  160,
                                                                  236),
                                                          content: ListTile(
                                                            leading:
                                                                CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white),
                                                            title: Text(
                                                              'Generando reporte...',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                      print('entro');
                                                      var data =
                                                          await reporteservices
                                                              .ventas_excel(
                                                                  'pdf');
                                                      print('fuera');
                                                      print('fuera' +
                                                          data.toString());
                                                      if (data['message'] ==
                                                          'Ok') {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                        showDialog(
                                                          context: context,
                                                          builder: (_) =>
                                                              AlertDialog(
                                                            backgroundColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    109,
                                                                    224,
                                                                    186),
                                                            content: Text(
                                                              'Listo para exportar!',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        );
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();

                                                        ///descarga de archivos
                                                        /*final status =
                                                            await Permission
                                                                .storage
                                                                .request();*/
                                                        
                                                        String url=data['link'];
                                                        SharePDF sharePDF = SharePDF(
                                                          url: url,
                                                          subject: "Reporte",
                                                        );
                                                        await sharePDF.downloadAndShare();
                                                        /*if (status.isGranted) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (_) =>
                                                                const AlertDialog(
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          225,
                                                                          130,
                                                                          28),
                                                              content: ListTile(
                                                                leading: CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white),
                                                                title: Text(
                                                                  'descargando...',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                          final basestorage =
                                                              await getApplicationDocumentsDirectory();
                                                          String url =
                                                              data['link'];
                                                          ALDownloader.configurePrint(true, frequentEnabled: false);
                                                          ALDownloader.download(
                                                              url,
                                                              directoryPath:
                                                                  basestorage!
                                                                      .path,
                                                              fileName:
                                                                  data['name'],
                                                              handlerInterface:
                                                              ALDownloaderHandlerInterface(progressHandler: (progress) {
                                                                debugPrint(
                                                                    'ALDownloader | download progress = $progress, url = $url\n');
                                                              }, succeededHandler:
                                                                          () async {
                                                                debugPrint(
                                                                    'ALDownloader | download succeeded, url = $url\n');
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop();
                                                                //print('la ruta: '+basestorage.path+'/nuevo.pdf');
                                                                final String
                                                                    filePath =
                                                                    basestorage
                                                                            .path +
                                                                        '/' +
                                                                        data[
                                                                            'name'];

                                                                OpenFile.open(
                                                                    filePath);
                                                                /*Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => Screenfile(filePath: filePath),
                                                          ));*/
                                                                /*final Uri _url = Uri.parse(basestorage.path+'/nuevo.pdf');
                                                        if (!await launchUrl(_url)) {
                                                          throw 'Could not launch $_url';
                                                        }*/
                                                              }, failedHandler:
                                                                          () {
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop();
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (_) =>
                                                                      AlertDialog(
                                                                    backgroundColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            224,
                                                                            211,
                                                                            18),
                                                                    content:
                                                                        ListTile(
                                                                      leading:
                                                                          Icon(
                                                                        Icons
                                                                            .warning,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      title:
                                                                          Text(
                                                                        'Fallo la descarga por favor intentalo de nuevo',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }, pausedHandler:
                                                                          () {
                                                                debugPrint(
                                                                    'ALDownloader | download paused, url = $url\n');
                                                              }));
                                                        } else {
                                                          print('no permision');
                                                        }*/
                                                      }
                                                    },
                                                    icon: Text(
                                                      'Generar PDF',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    label: Icon(Icons.picture_as_pdf)),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll<Color>(
                                                                Color.fromARGB(
                                                                    255,
                                                                    16,
                                                                    157,
                                                                    56)),
                                                        iconColor:
                                                            MaterialStatePropertyAll<Color>(
                                                                Colors.white),
                                                        textStyle:
                                                            MaterialStatePropertyAll<TextStyle>(
                                                                TextStyle(
                                                                    color: Colors
                                                                        .white))),
                                                    onPressed: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            const AlertDialog(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  115,
                                                                  160,
                                                                  236),
                                                          content: ListTile(
                                                            leading:
                                                                CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white),
                                                            title: Text(
                                                              'Generando reporte...',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                      print('entro');
                                                      var data =
                                                          await reporteservices
                                                              .ventas_excel(
                                                                  'xls');
                                                      print('fuera');
                                                      print('fuera' +
                                                          data.toString());
                                                      if (data['message'] ==
                                                          'Ok') {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                        showDialog(
                                                          context: context,
                                                          builder: (_) =>
                                                              AlertDialog(
                                                            backgroundColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    109,
                                                                    224,
                                                                    186),
                                                            content: Text(
                                                              'Listo para exportar!',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        );
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();

                                                        ///descarga de archivos
                                                        String url=data['link'];
                                                        SharePDF sharePDF = SharePDF(
                                                          url: url,
                                                          subject: "Reporte",
                                                        );
                                                        await sharePDF.downloadAndShare();
                                                        /*final status =
                                                            await Permission
                                                                .storage
                                                                .request();
                                                        if (status.isGranted) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (_) =>
                                                                const AlertDialog(
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          225,
                                                                          130,
                                                                          28),
                                                              content: ListTile(
                                                                leading: CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white),
                                                                title: Text(
                                                                  'descargando...',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                          final basestorage =
                                                              await getApplicationDocumentsDirectory();
                                                          String url =
                                                              data['link'];
                                                          ALDownloader.configurePrint(true, frequentEnabled: false);
                                                          ALDownloader.download(
                                                              url,
                                                              directoryPath:
                                                                  basestorage.path,
                                                              fileName:
                                                                  data['name'],
                                                              handlerInterface:
                                                              ALDownloaderHandlerInterface(progressHandler: (progress) {
                                                                debugPrint(
                                                                    'ALDownloader | download progress = $progress, url = $url\n');
                                                              }, succeededHandler:
                                                                          () async {
                                                                debugPrint(
                                                                    'ALDownloader | download succeeded, url = $url\n');
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop();
                                                                print('la ruta: '+basestorage.path+'/'+data['name']);
                                                                /*final String
                                                                    filePath =
                                                                    basestorage
                                                                            .path +
                                                                        '/' +
                                                                        data[
                                                                            'name'];

                                                                    print('ruta $filePath');*/

                                                                OpenFile.open(
                                                                    basestorage.path+'/'+data['name']);
                                                                /*Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => Screenfile(filePath: filePath),
                                                          ));*/
                                                                /*final Uri _url = Uri.parse(basestorage.path+'/nuevo.pdf');
                                                        if (!await launchUrl(_url)) {
                                                          throw 'Could not launch $_url';
                                                        }*/
                                                              }, failedHandler:
                                                                          () {
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop();
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (_) =>
                                                                      AlertDialog(
                                                                    backgroundColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            224,
                                                                            211,
                                                                            18),
                                                                    content:
                                                                        ListTile(
                                                                      leading:
                                                                          Icon(
                                                                        Icons
                                                                            .warning,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      title:
                                                                          Text(
                                                                        'Fallo la descarga por favor intentalo de nuevo',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }, pausedHandler:
                                                                          () {
                                                                debugPrint(
                                                                    'ALDownloader | download paused, url = $url\n');
                                                              }));
                                                        } else {
                                                          print('no permision');
                                                        }*/
                                                      }
                                                    },
                                                    icon: Text(
                                                      'Generar Excel',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    label: Icon(Icons.grid_on)),
                                              ),
                                            ],
                                          ),

                                          /*Container(
                                            width: double.infinity,
                                            child: ElevatedButton.icon(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll<Color>(
                                                            Color.fromARGB(
                                                                255, 40, 111, 193)),
                                                    iconColor:
                                                        MaterialStatePropertyAll<
                                                                Color>(
                                                            Colors.white),
                                                    textStyle:
                                                        MaterialStatePropertyAll<
                                                                TextStyle>(
                                                            TextStyle(color: Colors.white))),
                                                onPressed: () {},
                                                icon: Text(
                                                  'Ver Reporte',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                label: Icon(Icons.visibility)),
                                          )*/
                                          //******************************************************************** */
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                            //termina sheet
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
          radius: 100,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Icon(
                    Icons.bar_chart,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    'Reporte de Ventas',
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
