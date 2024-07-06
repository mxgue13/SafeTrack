import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:safetrack/widgets/custom_alert.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() =>_RegisterPageState();
}

List<String> listaTipoDocumento = ['C.C', 'C.E', 'R.C', 'T.I'];
String dropdownValueTD = listaTipoDocumento.first;

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();
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
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Crear una cuenta",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Por favor complete el formulario:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  _textFieldName(),
                  _tipoDocumentoField(),
                  const SizedBox(
                    height: 18.0,
                  ),
                  _documentoField(),
                  const SizedBox(
                    height: 18.0,
                  ),
                  _textFieldEmail(),
                  const SizedBox(
                    height: 18.0,
                  ),
                  _textFieldContrasena(),
                  const SizedBox(
                    height: 18.0,
                  ),
                  _textFieldRepitaContrasena(),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 22.0),
                    child: FFButtonWidget(
                      onPressed: () => registrarse(context),
                      text: 'Registrarse',
                      options: FFButtonOptions(
                        width: 230,
                        height: 42,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
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
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Widget _textFieldName() {
    return _TextFieldGeneral(
        labelText: "Nombre Completo",
        keyboardType: TextInputType.text,
        icon: Icons.abc,
        hintText: "Digite su nombre",
        onChanged: (value) {},
        controller: nameController,
        type: 'Email');
  }

  Widget _textFieldEmail() {
    return _TextFieldGeneral(
        labelText: "Correo Electronico",
        keyboardType: TextInputType.emailAddress,
        icon: Icons.email_outlined,
        hintText: "Digite su email",
        onChanged: (value) {},
        controller: emailController,
        type: 'Email');
  }

  Widget _documentoField() {
    return _TextFieldGeneral(
      labelText: "Documento",
      keyboardType: TextInputType.text,
      icon: Icons.credit_card,
      hintText: "Digite su número de Documento",
      onChanged: (value) {},
      controller: documentController,
      type: 'Text',
    );
  }

  Widget _tipoDocumentoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 22.0, top: 8.0),
          child: Text(
            'Tipo de Documento:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Container(
            width: double.infinity,
            height: 60,
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonFormField<String>(
              value: dropdownValueTD,
              onChanged: (String? value) {
                setState(() {
                  dropdownValueTD = value!;
                });
              },
              items: listaTipoDocumento.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(value,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        )),
                  ),
                );
              }).toList(),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textFieldContrasena() {
    return _TextFieldGeneral(
        labelText: "Contraseña",
        keyboardType: TextInputType.visiblePassword,
        icon: Icons.lock_outline_rounded,
        hintText: "Digite su Contraseña",
        obscureText: true,
        onChanged: (value) {},
        controller: passwordController,
        type: 'password');
  }

  Widget _textFieldRepitaContrasena() {
    return _TextFieldGeneral(
        labelText: "Repita la Contraseña",
        keyboardType: TextInputType.visiblePassword,
        icon: Icons.lock_outline_rounded,
        hintText: "Repita su Contraseña",
        obscureText: true,
        onChanged: (value) {},
        controller: repeatPasswordController,
        type: 'password');
  }

  bool validarEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  Future<void> registrarse(context) async {
  final supabase = Supabase.instance.client;

  Map<String, int> tipoDocumento = {
    'C.C': 1,
    'C.E': 2,
    'R.C': 3,
    'T.I': 4,
  };

  try {
    if (nameController.text.isEmpty ||
        documentController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        repeatPasswordController.text.isEmpty) {
      showCustomErrorDialog(context, "¡Por favor llenar todos los campos del formulario!");
      return;
    }
    if (!validarEmail(emailController.text)) {
      showCustomErrorDialog(context, "¡Digite un email valido!");
      return;
    }
    if (passwordController.text.length < 6 || repeatPasswordController.text.length < 6) {
      showCustomErrorDialog(context, "¡Las contraseñas deben tener mínimo 6 caracteres!");
      return;
    }
    if (passwordController.text != repeatPasswordController.text) {
      showCustomErrorDialog(context, "Las contraseñas no coinciden");
      return;
    }

    final verificacion2 = await supabase
        .from('Usuario')
        .select('numero_doc')
        .eq("numero_doc", documentController.text);

    if (verificacion2.isNotEmpty) {
      showCustomErrorDialog(context, '¡Existe un usuario registrado con ese número de documento!');
      return;
    }

    final response = await supabase.auth.signUp(
      email: emailController.text,
      password: passwordController.text,
    );

    if (response.user != null) {
      await supabase.from('Usuario').insert({
        'nombre_com': nameController.text,
        'tipo_doc': tipoDocumento[dropdownValueTD],
        'numero_doc': documentController.text,
        'email': emailController.text,
      });

      await supabase.auth.signOut();
      showCustomExitDialog(context, "¡Se creó el usuario exitosamente!");
      _limpiarCampos();
    }
  } catch (e) {
    showCustomErrorDialog(context, "Error inesperado durante el registro: $e");
  }
}

void _limpiarCampos() {
  nameController.clear();
  emailController.clear();
  passwordController.clear();
  repeatPasswordController.clear();
  documentController.clear();
}

}

class _TextFieldGeneral extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final IconData icon;
  final String hintText;
  final Function(String) onChanged;
  final TextEditingController controller;
  final bool obscureText;
  final String type;

  const _TextFieldGeneral({
    required this.labelText,
    required this.keyboardType,
    required this.icon,
    required this.hintText,
    required this.onChanged,
    required this.controller,
    this.obscureText = false,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labelText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                obscureText: obscureText,
                decoration: InputDecoration(
                  hintText: hintText,
                  prefixIcon: Icon(icon),
                  border: InputBorder.none,
                ),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
