import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatelessWidget {
  final _supabase = Supabase.instance.client;

  Future<void> _logout() async {
    await _supabase.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная'),
        actions: [
          IconButton(
            onPressed: () {
              _logout();
             Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SimpleMap(),
     
    );
  }
}

class SimpleMap extends StatelessWidget {
  const SimpleMap({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: const LatLng(59.9341, 30.3061),
        initialZoom: 13,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.map',
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 40,
              height: 40,
              point: const LatLng(59.9341, 30.3061),
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
        CircleLayer(
          circles: [
            CircleMarker(
              point: const LatLng(59.9341, 30.3061),
              color: Colors.blue.withOpacity(0.3),
              borderColor: Colors.blue,
              borderStrokeWidth: 2,
              radius: 100,
            ),
          ],
        ),
      ],
    );
  }
}