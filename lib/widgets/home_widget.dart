import 'package:flutter/material.dart';
import 'package:safetrack/pages/login_page.dart';
import 'package:safetrack/pages/register_page.dart';

class Home extends StatefulWidget{
  
  const Home({super.key});
  @override
  State<StatefulWidget> createState(){
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
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
        backgroundColor:const Color.fromARGB(255, 126, 227, 252),
      ),
      body: Center(
        child: _selectedIndex == 0
            ? const LoginPage()
            : const RegisterPage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.login, size:30),
            label: 'Iniciar Sesión',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add, size:30),
            label: 'Registrarse',
          ),
        ],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedFontSize: 20,
        unselectedFontSize: 20,
      ),
    );
  }
}