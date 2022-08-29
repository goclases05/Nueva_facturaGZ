import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:factura_gozeri/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:factura_gozeri/providers/loginform_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  initWidget() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.cyan,
            Colors.cyan,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
          ],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: const _LoginForm(),
                )),
          )),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Container(
              height: 260,
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90)),
                color: Colors.cyan,
                gradient: LinearGradient(
                  colors: [(Colors.cyan), Colors.cyan],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: Image.asset(
                      "assets/gozeri_factura2.png",
                      height: 230,
                      width: 230,
                    ),
                  )
                ],
              )),
            ),
            /*Container(
              margin: const EdgeInsets.only(top: 10, left: 15),
              alignment: Alignment.topLeft,
              child: const Text(
                "Facturación",
                style: TextStyle(
                  fontFamily: 'BreeSerif',
                  fontSize: 38,
                  color: Colors.grey,
                ),
              ),
            ),*/
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 25),
              padding: const EdgeInsets.only(left: 20, right: 20),
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: Color(0xffEEEEEE),
                  ),
                ],
              ),
              child: TextFormField(
                onChanged: (value) => loginForm.user_mail = value,
                validator: (value) {
                  if (value != null && value.length >= 1) {
                    return null;
                  } else {
                    return 'Inserte un Usuario| Correo ';
                  }
                },
                cursorColor: Colors.cyan,
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.email,
                    color: Colors.cyan,
                  ),
                  hintText: "Usuario | Correo",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              padding: const EdgeInsets.only(left: 20, right: 20),
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xffEEEEEE),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 20),
                    blurRadius: 100,
                    color: Color(0xffEEEEEE),
                  ),
                ],
              ),
              child: TextFormField(
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  if (value != null && value.length >= 1) {
                    return null;
                  } else {
                    return 'Inserte su contraseña';
                  }
                },
                obscureText: true,
                cursorColor: Colors.cyan,
                decoration: const InputDecoration(
                  focusColor: Color(0xffF5591F),
                  icon: Icon(
                    Icons.vpn_key,
                    color: Colors.cyan,
                  ),
                  hintText: "Contraseña",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  // Write Click Listener Code Here
                },
                child: const Text("¿contraseña olvidada?"),
              ),
            ),
            GestureDetector(
              onTap: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      if (!loginForm.isValidForm()) return;

                      loginForm.isLoading = true;
                      //await Future.delayed(Duration(seconds: 2));
                      loginForm.isLoading = false;

                      final dynamic errorMessage = await authService.login(
                          loginForm.user_mail, loginForm.password);
                      if (errorMessage == null) {
                        //puede ingresar a   la vista de inicio
                        var snackBar = SnackBar(
                          /// need to set following properties for best effect of awesome_snackbar_content
                          duration: const Duration(seconds: 1),
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Bienvenido!',
                            message: 'Inicio de sesión correcto.',

                            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                            contentType: ContentType.success,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.pushReplacementNamed(context, 'checking');
                        });
                      } else {
                        var snackBar = SnackBar(
                          /// need to set following properties for best effect of awesome_snackbar_content
                          duration: const Duration(seconds: 1),
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Error!',
                            message: errorMessage,

                            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                            contentType: ContentType.failure,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        loginForm.isLoading = false;
                      }
                    },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                padding: const EdgeInsets.only(left: 20, right: 20),
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [(Colors.cyan), Colors.cyan],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey[200],
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: Color(0xffEEEEEE)),
                  ],
                ),
                child: Text(
                  loginForm.isLoading ? 'Espere' : "Iniciar Sesión",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const Divider(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.warning,
                    color: Colors.cyan,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      "Si no cuentas con un usuario, comunicate con una empresa registrada.",
                      textAlign: TextAlign.start,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
