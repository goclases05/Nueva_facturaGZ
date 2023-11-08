import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:factura_gozeri/providers/items_provider.dart';
import 'package:factura_gozeri/providers/print_provider.dart';
import 'package:factura_gozeri/providers/seattings_provider.dart';
import 'package:factura_gozeri/screens/view_facturas_screen.dart';
import 'package:factura_gozeri/screens/view_ticket_desing_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/data_facturas_models.dart';

class FacturasSearch extends SearchDelegate {
  @override
  String get searchFieldLabel => "Buscar Facturas";
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final settings = Provider.of<settingsProvider>(context, listen: false);
    if (query.isEmpty) {
      return Container(
        child: Center(
          child: Icon(
            Icons.receipt_outlined,
            color: Color.fromARGB(255, 216, 216, 216),
            size: 130,
          ),
        ),
      );
    }

    final filtro = Provider.of<ItemProvider>(context);
    filtro.getSuggestionsByQueryfactura(query);

    Color colorPrimary = settings.colorPrimary;

    return StreamBuilder(
        stream: filtro.suggestionsStremfacturas,
        builder: (_, AsyncSnapshot<List<DataFacturas>> snapshot) {
          if (!snapshot.hasData)
            return Container(
              child: Center(
                child: Icon(
                  Icons.receipt_outlined,
                  color: Color.fromARGB(255, 216, 216, 216),
                  size: 130,
                ),
              ),
            );

          final list_emi = snapshot.data!;

          return ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: list_emi.length,
              separatorBuilder: ((_, __) {
                return const Divider(
                  height: 1,
                  color: Colors.blueGrey,
                );
              }),
              itemBuilder: (context, index) {
                return ListTile(
                  //tileColor: Color.fromARGB(255, 255, 226, 223),

                  title: Text(
                    'No ${list_emi[index].no}: ${list_emi[index].nombre} ${list_emi[index].apellidos}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(167, 0, 0, 0)),
                  ),
                  subtitle: Text(
                    '${list_emi[index].fecha}',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38),
                  ),
                  onTap: () {
                    final printProvider =
                        Provider.of<PrintProvider>(context, listen: false);
                    printProvider.dataFac(list_emi[index].idFactTmp);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ViewTicket(
                                  colorPrimary: colorPrimary,
                                  estado: list_emi[index].estado,
                                  factura: list_emi[index].idFactTmp,
                                )));
                  },
                  trailing: Chip(
                      padding: const EdgeInsets.all(1),
                      backgroundColor: (list_emi[index].estado == '2')
                          ? Color.fromARGB(255, 28, 192, 28)
                          : (list_emi[index].estado == '1')
                              ? Color.fromARGB(255, 233, 195, 72)
                              : const Color.fromARGB(255, 232, 116, 107),
                      label: Text(
                        (list_emi[index].estado == '2')
                            ? 'Pagada'
                            : (list_emi[index].estado == '1')
                                ? 'Pendiente de Pago'
                                : 'Anulada',
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      )),
                );
              });
        });
  }
}
