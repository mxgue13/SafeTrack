//import 'package:animated_text_kit/animated_text_kit.dart';
// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:safetrack/widgets/custom_alert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState(){
    super.initState();
    cerrarSesiones();
  }

  final supabase = Supabase.instance.client;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 126, 227, 252),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Bienvenido de vuelta",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  _textFieldUserName(),
                  SizedBox(
                    height: 30.0,
                  ),
                  _textFieldContrasena(),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FFButtonWidget(
                    onPressed: () => signIn(context),
                    text: 'Iniciar Sesion',
                    options: FFButtonOptions(
                      width: 230,
                      height: 52,
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: const Color(0xFF4B39EF),
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Plus Jakarta Sans',
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                              ),
                      elevation: 3,
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Widget _textFieldUserName() {
    return _TextFieldGeneral(
        labelText: "Usuario",
        icon: Icons.person_outline,
        hintText: "Digite su nombre",
        onChanged: (value) {},
        controller: userNameController,
        type: 'UserName');
  }

  Widget _textFieldContrasena() {
    return _TextFieldGeneral(
        labelText: "Contraseña",
        keyboardType: TextInputType.visiblePassword,
        icon: Icons.lock_outline_rounded,
        hintText: "Digite su Contraseña",
        obscureText: true,
        controller: passwordController,
        onChanged: (value) {},
        type: 'password');
  }

  void cerrarSesiones(){
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;
    if (session!=null) {
      supabase.auth.signOut();
    } 
  }

 Future<void> signIn(BuildContext context) async {
    try {
      if(userNameController.text == '' || passwordController.text == ''){
        showCustomErrorDialog(context, "¡Por favor llenar todos los campos del formulario!");
        return;
      }
      if(passwordController.text.length < 6){
        showCustomErrorDialog(context, "¡La contraseña debe tener minimo 6 caracteres!");
        return;
      }

      //Consulta para ver si el usuario esta registrado:
      final usuario = userNameController.text;
      final datos = await supabase
      .from('Usuario')
      .select('numero_doc')
      .eq('numero_doc', usuario);

      if(datos.length == 1){ 
        try {
          //Sign In por medio de auth - Supabase
          await supabase.auth.signInWithPassword(
            password: passwordController.text.trim(),
            email: datos[0]['correo}']
          );
        } catch (e) {
          showCustomErrorDialog(context, "¡Contraseña Incorrecta, Intentelo Nuevamente!");
        }
      }
      else {
        showCustomErrorDialog(context, "El usuario '$usuario' NO esta registrado en el sistema de Safetrack. \n\n¡Porfavor registrese!");
        return;
      }
    } on Exception catch (e) {
      final error = e.toString();
      showCustomErrorDialog(context, "Ha ocurrido un error Inesperado: \n\n$error");
    }
  }
}

// ignore: camel_case_types
class _TextFieldGeneral extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final Function(String) onChanged;
  final TextInputType? keyboardType;
  final IconData icon;
  final bool obscureText;
  final String type;
  final TextEditingController controller;

  const _TextFieldGeneral(
      {required this.labelText,
      this.hintText,
      required this.onChanged,
      this.keyboardType,
      required this.icon,
      this.obscureText = false,
      required this.type,
      required this.controller});

  @override
  _TextFieldGeneralState createState() => _TextFieldGeneralState();
}

class _TextFieldGeneralState extends State<_TextFieldGeneral> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 22.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: _obscureText,
        decoration: _buildInputDecoration(),
        onChanged: widget.onChanged,
      ),
    );
  }

//Permite Mostrar o Esconder la Contraseña
  InputDecoration _buildInputDecoration() {
    if (widget.type == 'password') {
      return InputDecoration(
        prefixIcon: Icon(widget.icon),
        labelText: widget.labelText,
        hintText: widget.hintText,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
      );
    } else {
      return InputDecoration(
        prefixIcon: Icon(widget.icon),
        labelText: widget.labelText,
        hintText: widget.hintText,
      );
    }
  }
}
