import 'package:factura_gozeri/global/preferencias_global.dart';
import 'package:factura_gozeri/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderDrawer extends StatefulWidget {
  HeaderDrawer({Key? key, required this.colorPrimary, required this.cont})
      : super(key: key);
  Color colorPrimary;
  BuildContext cont;

  @override
  State<HeaderDrawer> createState() => _HeaderDrawerState();
}

class _HeaderDrawerState extends State<HeaderDrawer> {
  String name = Preferencias.name;
  String apellido = Preferencias.apellido;
  String data_usuario = Preferencias.data_usuario;
  String grupo = Preferencias.grupo;
  String foto_usuario = Preferencias.foto_usuario;
  String foto_empresa = Preferencias.foto_empresa;
  String data_id = Preferencias.data_id;
  String data_empresa = Preferencias.data_empresa;
  String nombre_empresa = Preferencias.nombre_empresa;

  String selectedValue = "${Preferencias.sucursal}";
  Color colorSecundario = const Color.fromRGBO(242, 242, 247, 1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    List<DropdownMenuItem<String>> menuItems = [];
    for (var i = 0; i < authService.list_sucu.length; i++) {
      menuItems.add(DropdownMenuItem(
          child: Expanded(
            child: Text(
              authService.list_sucu[i].nombre,
              textAlign: TextAlign.center,
              style: TextStyle(
                  //color: Colors.black38
                  ),
            ),
          ),
          value: authService.list_sucu[i].idSucursal));
      ;
    }
    /*menuItems.add(DropdownMenuItem(
          child: Expanded(
            child: Text(
              'asdfasdf fas df asd fasd fnsdmnf,msd ',
              textAlign: TextAlign.center,
            ),
          ),
          value: '0'));
      ;*/

    return Container(
      color: colorSecundario,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40.0, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
              height: MediaQuery.of(context).size.width * 0.25,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: widget.colorPrimary.withOpacity(0.3), width: 2)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: (foto_usuario == '' ||
                          foto_usuario ==
                              'https://imagenes.gozeri.com/ImagenesGozeri/siluetas_perfil.gif')
                      ? const FadeInImage(
                          placeholder: AssetImage('assets/cilUser.jpg'),
                          image: AssetImage('assets/cilUser.jpg'),
                        )
                      : FadeInImage(
                          placeholder: AssetImage('assets/cilUser.jpg'),
                          image: NetworkImage(foto_usuario),
                        ))),

          //******************************************************************* */
          const SizedBox(
            height: 8.0,
          ),
          Text(
            "${name} ${apellido}",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: Colors.black),
          ),
          Text(
            "${grupo} | ${data_usuario}",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
                color: Colors.black38),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 2,
          ),

          //******************************************************************** */

          //******************************************************************** */
          Container(
            padding: const EdgeInsets.only(top: 8, right: 8, bottom: 8),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              children: [
                Container(
                  decoration: BoxDecoration(
                    /*border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white*/
                    color: widget.colorPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: DropdownButton(
                    //key: keysucursal,
                    isExpanded: true,
                    itemHeight: null,
                    value: selectedValue,
                    dropdownColor: widget.colorPrimary,
                    onChanged: (String? newValue) async {
                      selectedValue = newValue!;
                      Preferencias.sucursal = selectedValue;
                      setState(() {});
                    },
                    items: menuItems,
                    elevation: 0,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    //icon: Icon(Icons.arrow_drop_down),
                    iconDisabledColor: Colors.red,
                    iconEnabledColor: Colors.white,
                    underline: SizedBox(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          //******************************************************************** */
        ],
      ),
    );
  }
}
