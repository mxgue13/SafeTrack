import 'package:flutter/material.dart';
import 'package:safetrack/pages/location_page.dart';
import 'package:safetrack/pages/notifications_page.dart'; // Página de inicio de sesión/registro
import 'package:safetrack/pages/user_profile.dart';
import 'package:safetrack/widgets/home_pages.dart'; // Página principal después de iniciar sesión
import 'package:safetrack/widgets/home_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://cflnkyzcmvghoaoswuim.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNmbG5reXpjbXZnaG9hb3N3dWltIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM4MTM2OTEsImV4cCI6MjAyOTM4OTY5MX0.cMYhXBC1F_-lJpwr2b6hNLRyAwmupAH_ST8OhuEVbgs';
final supabase = SupabaseClient(supabaseUrl, supabaseKey);

Future<void> main() async {
  // Inicializar Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safetrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthGate(),
      routes: <String, WidgetBuilder>{
        '/location': (context) => const LocationPage(),
        '/profile': (context) => const UserProfilePage(),
        '/notifications': (context) => const NotificationsPage(),
      },
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  _AuthGateState createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeWidget()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    if (user != null) {
      return const HomePage(); // Página principal después de iniciar sesión
    } else {
      return const HomeWidget(); // Página de inicio de sesión/registro
    }
  }
}