import 'package:factura_gozeri/providers/seattings_provider.dart';
import 'package:factura_gozeri/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MembresiaScreen extends StatelessWidget {
  const MembresiaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width*1,
          height: MediaQuery.of(context).size.height*1,
          color: Colors.white,
        ),
        Positioned(
          left: -50,
          top: 20,
          child: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 174, 192, 195).withOpacity(0.2),
            radius: 60,
        
          ),
        ),
        Positioned(
          right: -70,
          top: -5,
          child: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 174, 192, 195).withOpacity(0.2),
            radius: 150,
        
          ),
        ),
        Positioned(
          left: -70,
          bottom: -70,
          child: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 174, 192, 195).withOpacity(0.2),
            radius: 150,
        
          ),
        ),
        /*Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children:const [
              Text('Mempresía Expirada',style: TextStyle(color: Colors.cyanAccent),),
              Text('Tu panel de Control ha sido bloqueado temporalmente')
            ],
          )
        )*/
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Image.asset('assets/gozeri_blanco2.png',color: Colors.cyan.withOpacity(0.8), width: MediaQuery.of(context).size.width*0.3,),
            actions: [
              const SizedBox(
                width: 10,
              ),
              CircleAvatar(
                  backgroundColor: const Color.fromRGBO(242, 242, 247, 1),
                  child: PopupMenuButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.cyan,
                    ),
                    // Callback that sets the selected popup menu item.
                    onSelected: (value) {
                      if (value == 'exit') {
                        authService.logout();
                        Navigator.pushReplacementNamed(context, 'checking');
                      } 
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                          const PopupMenuItem(
                            value: "exit",
                            child: ListTile(
                              title: Text("Cerrar Sesión"),
                              trailing: Icon(
                                Icons.logout,
                              ),
                            ),
                          )
                        ])),
            ],
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Image.asset('assets/gozeri_blanco2.png',color: Colors.cyan.withOpacity(0.3), width: MediaQuery.of(context).size.width*0.3,),
                 Card(
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(Icons.badge_outlined,color: Colors.cyan, size: 120,)
                    )
                ),
                const SizedBox(height: 10,),
                const Text('Membresía Expirada',style: TextStyle(color: Colors.cyan, fontSize: 25),textAlign: TextAlign.center),
                const Text('Tu panel de Control ha sido bloqueado temporalmente',textAlign: TextAlign.center),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.15,
                )
              ],
            ),
          ),
          bottomSheet: Row(
            children:[ 
              SizedBox(
                width: MediaQuery.of(context).size.width*0.1,
              ),
              Expanded(
                child: Container(
                  margin:const EdgeInsets.only(bottom: 10),
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'checking');
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.cyan,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.1,
              ),
            ]
          ),
        )
      ],
    );
  }
}
