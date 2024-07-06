import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(0, 0);
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _startLocationUpdates();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _loading = false;
    });
  }

  void _startLocationUpdates() {
    Geolocator.getPositionStream(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high))
        .listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 16));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 16));
  }

  void _sendSOS() async {
    final message = '¡Alerta SOS! Ubicación: https://maps.google.com/?q=${_currentPosition.latitude},${_currentPosition.longitude}';
    try {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mensaje de SOS enviado')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al enviar mensaje de SOS')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación Actual'),
      ),
      body: Stack(
        children: [
          _loading
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition,
                    zoom: 16,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton.extended(
              onPressed: _sendSOS,
              label: const Text('SOS'),
              icon: const Icon(Icons.warning),
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

