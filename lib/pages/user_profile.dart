import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final supabase = Supabase.instance.client;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController documentNumberController = TextEditingController();
  final TextEditingController documentTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final user = supabase.auth.currentUser;
    final idUser = user?.id;

    if (idUser != null) {
      final response = await supabase
          .from('Usuario')
          .select('nombre_com, numero_doc, tipo_doc')
          .eq('id_user', idUser)
          .single();

      final data = response['data'];
      final dicTipoDocumento = {
        1: "C.C",
        2: "C.E",
        3: "R.C",
        4: "T.I"
      };

      setState(() {
        nameController.text = data['nombre_com'] ?? "N/A";
        documentNumberController.text = data['numero_doc'] ?? "N/A";
        documentTypeController.text =
            dicTipoDocumento[data['tipo_doc']] ?? "N/A";
      });
    }
  }

  Future<void> actualizarTexto(String parametro) async {
    final TextEditingController newDataController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Actualizar $parametro"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newDataController,
                decoration: const InputDecoration(labelText: 'Nuevo Valor'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el modal
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para actualizar el valor con el nuevo valor en newDataController.text
                // Por ejemplo:
                // updateValue(parametro, newDataController.text);
                Navigator.of(context).pop(); // Cierra el modal después de actualizar
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextFieldWithButton({
    required String labelText,
    required TextEditingController controller,
    required void Function(String) onPressed,
    required String parametro,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            readOnly: true,
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        const SizedBox(width: 10), // Añade un espacio entre el TextField y el botón
        ElevatedButton(
          onPressed: () => onPressed(parametro),
          child: const Icon(Icons.update), // Puedes cambiar el icono o el texto según prefieras
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Perfil del Usuario'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 18.0),
              _buildTextFieldWithButton(
                labelText: "Nombre Completo",
                controller: nameController,
                parametro: "Nombre",
                onPressed: actualizarTexto,
              ),
              const SizedBox(height: 18.0),
              _buildTextFieldWithButton(
                labelText: "Tipo de documento",
                controller: documentTypeController,
                parametro: "Tipo de Documento",
                onPressed: actualizarTexto,
              ),
              const SizedBox(height: 18.0),
              _buildTextFieldWithButton(
                labelText: "Numero de documento",
                controller: documentNumberController,
                parametro: "Numero de documento",
                onPressed: actualizarTexto,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
