import 'package:factura_gozeri/providers/seattings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<settingsProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: ()async{
        Navigator.pushReplacementNamed(context, 'checking');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: settings.colorPrimary,
          title: const Text('Ajustes'),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap:true,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: settings.colorPrimary,
                child: const Icon(Icons.filter_none,color: Colors.white,)
              ),
              title: Text('Serie Predeterminada: '),
              onTap: (() {
                
              }),
            ),
            const Divider(
              color:Colors.grey
            ),
            ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: settings.colorPrimary,
                child: const Icon(Icons.palette,color: Colors.white,)
              ),
              title: Text('Serie Predeterminada: '),
              children:[
                 ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap:true,
                  itemCount: settings.list_Color.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: settings.list_Color[index],
                      ),
                      onTap: (){
                        settings.colorChange(index);
                        setState(() {
                          
                        });
                      },
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

    
}