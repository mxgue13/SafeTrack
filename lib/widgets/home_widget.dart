import 'package:flutter/material.dart';
import 'package:safetrack/pages/login_page.dart';
import 'package:safetrack/pages/register_page.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    LoginPage(),
    RegisterPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Safetrack",
          style: TextStyle(
            color: Color.fromARGB(255, 234, 255, 1),
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Centra el título
        backgroundColor: const Color.fromARGB(255, 126, 227, 252),
      ),
      body: Center(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.login, size: 30),
            label: 'Iniciar Sesión',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add, size: 30),
            label: 'Registrarse',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
