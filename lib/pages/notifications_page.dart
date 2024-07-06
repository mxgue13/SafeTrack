import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final user = supabase.auth.currentUser;
    final idUser = user?.id;

    if (idUser != null) {
      final response = await supabase
          .from('Notificaciones')
          .select()
          .eq('id_user', idUser)
          .order('created_at', ascending: false);

      setState(() {
        _notifications = List<Map<String, dynamic>>.from(response);
      });
    }
  }

  Widget _buildNotificationList() {
    if (_notifications.isEmpty) {
      return const Center(child: Text('No tienes notificaciones.'));
    }

    return ListView.builder(
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return ListTile(
          title: Text(notification['mensaje']),
          subtitle: Text(notification['created_at']),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notificaciones'),
      ),
      body: _buildNotificationList(),
    );
  }
}