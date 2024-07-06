import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:safetrack/widgets/custom_alert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


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
  final TextEditingController documentController = TextEditingController();

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
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Padding(
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
                  const SizedBox(
                    height: 15.0,
                  ),
                  _textFieldDocument(),
                  const SizedBox(
                    height: 30.0,
                  ),
                  _textFieldContrasena(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  FFButtonWidget(
                    onPressed: () => iniciarSesion(context),
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
                  const SizedBox(
                    height: 3.0,
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Widget _textFieldDocument() {
    return _TextFieldGeneral(
      labelText: "Email",
      icon: Icons.insert_drive_file,
      hintText: "Digite su email",
      onChanged: (value) {},
      controller: documentController,
      type: 'number', // Cambiado a tipo numérico si el documento es un número
    );
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

  Future<void> iniciarSesion(context) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase.auth.signInWithPassword(
        email: documentController.text,
        password: passwordController.text,
      );

      if (response.user != null) {
        // Inicio de sesión exitoso, redirige al usuario a la página principal o muestra un mensaje de éxito
        Navigator.pushReplacementNamed(context, '/location');
      } else {
        showCustomErrorDialog(context, "Correo o contraseña incorrectos");
      }
    } catch (e) {
      showCustomErrorDialog(context, "Error inesperado durante el inicio de sesión");
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
      margin: const EdgeInsets.symmetric(
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