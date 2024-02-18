import 'package:cafe_now_app/models/place.dart';
import 'package:cafe_now_app/services/cafe_service.dart';
import 'package:cafe_now_app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

const mapUrl = 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png';
const defaultZoom = 15.0;

class CafeSearchScreen extends StatefulWidget {
  const CafeSearchScreen({super.key});
  static const String route = '/';

  @override
  State<CafeSearchScreen> createState() => _CafeSearchScreenState();
}

class _CafeSearchScreenState extends State<CafeSearchScreen> {
  late MapController _mapController;
  late LocationService _locationService;
  late CafeService _cafeService;

  late final cafeMarkers = <Marker>[];

  Marker buildCafePin(LatLng point, Place cafe) => Marker(
        point: point,
        width: 60,
        height: 60,
        child: GestureDetector(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(cafe.name),
              duration: const Duration(seconds: 1),
              showCloseIcon: true,
            ),
          ),
          child: Image.asset(
            "assets/images/CuteCoffeeMugNoBackground.png",
            width: 60,
            height: 60,
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _locationService = LocationService();
    _cafeService = CafeService();
  }

  Future<void> getLocation() async {
    final location = await _locationService.getLocation();

    _mapController.move(
        LatLng(location.latitude, location.longitude), defaultZoom);

    final cafes = await _cafeService.fetchCafes();

    for (var cafe in cafes) {
      final lat = cafe.geometry.location.lat;
      final lng = cafe.geometry.location.lng;
      cafeMarkers.add(buildCafePin(LatLng(lat, lng), cafe));
    }
    setState(() {
      cafeMarkers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: CafeMap(
                  mapController: _mapController, cafeMarkers: cafeMarkers),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: ElevatedButton(
                    onPressed: getLocation,
                    child: const Text('Search'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CafeMap extends StatelessWidget {
  const CafeMap({
    super.key,
    required MapController mapController,
    required this.cafeMarkers,
  }) : _mapController = mapController;

  final MapController _mapController;
  final List<Marker> cafeMarkers;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(51.5, -0.09),
        initialZoom: defaultZoom,
      ),
      mapController: _mapController,
      children: [
        TileLayer(
          urlTemplate: mapUrl,
        ),
        MarkerLayer(
          markers: cafeMarkers,
          rotate: true,
        ),
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
      ],
    );
  }
}
