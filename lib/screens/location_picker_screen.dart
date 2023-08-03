import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/user_report.dart';

import '../widgets/forms/latitude_entry_field.dart';
import '../widgets/forms/longitude_entry_field.dart';

class LocationPickerScreen extends StatefulWidget {
  static const String routeName = 'LocationPickerScreen';

  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  CustomPoint<double>? _position = const CustomPoint(10, 10);

  late final MapController _mapController;
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    final UserReport userReport =
        ModalRoute.of(context)?.settings.arguments as UserReport;

    updatePositionTarget() {
      setState(() {
        _position = _mapController.latLngToScreenPoint(LatLng(
            userReport.geopoint!.latitude, userReport.geopoint!.longitude));
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Where was this observed?')),
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(45.3, -125),
            zoom: 6,
            maxZoom: 11,
            minZoom: 5,
            maxBounds:
                LatLngBounds(LatLng(35.65, -140.10), LatLng(50.80, -120.50)),
            interactiveFlags: InteractiveFlag.doubleTapZoom |
                InteractiveFlag.drag |
                InteractiveFlag.pinchMove |
                InteractiveFlag.pinchZoom |
                InteractiveFlag.flingAnimation,
            onMapReady: () {
              if (userReport.geopoint == null) {
                final centerLatLng = _mapController.center;
                userReport.geopoint =
                    GeoPoint(centerLatLng.latitude, centerLatLng.longitude);
              }
              _latController.text = '${userReport.geopoint!.latitude}';
              _longController.text = '${userReport.geopoint!.longitude}';

              updatePositionTarget();
            },
            onTap: (tapPos, latLng) {
              debugPrint('x: ${_position?.x} y: ${_position?.y}');

              userReport.geopoint = GeoPoint(latLng.latitude, latLng.longitude);
              _latController.text = '${userReport.geopoint!.latitude}';
              _longController.text = '${userReport.geopoint!.longitude}';

              debugPrint(
                  'x: ${userReport.geopoint!.latitude}, y: ${userReport.geopoint!.longitude}');

              updatePositionTarget();
            },
            onPositionChanged: (mapPosition, someBool) {
              updatePositionTarget();
              imageCache.clear();
              // imageCache.clearLiveImages();
            },
          ),
          children: [
            TileLayer(
              tileProvider: AssetTileProvider(),
              urlTemplate: 'assets/map/{z}/{x}/{y}.png',
              tms: false,
            )
          ],
        ),
        LatLongTarget(position: _position),
        LatLongBox(
            latController: _latController,
            userReport: userReport,
            longController: _longController,
            updatePositionTarget: updatePositionTarget)
      ]),
    );
  }
}

class LatLongBox extends StatelessWidget {
  const LatLongBox({
    super.key,
    required TextEditingController latController,
    required this.userReport,
    required TextEditingController longController,
    required this.updatePositionTarget,
  })  : _latController = latController,
        _longController = longController;

  final TextEditingController _latController;
  final UserReport userReport;
  final TextEditingController _longController;
  final Function updatePositionTarget;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 1 / 24,
      left: MediaQuery.of(context).size.width * 1 / 8,
      width: MediaQuery.of(context).size.width * 3 / 4,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1,
              )),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                LatitudeEntryField(
                    latController: _latController,
                    userReport: userReport,
                    updatePositionTarget: updatePositionTarget),
                LongitudeEntryField(
                    longController: _longController,
                    userReport: userReport,
                    updatePositionTarget: updatePositionTarget),
              ],
            ),
          )),
    );
  }
}

class LatLongTarget extends StatelessWidget {
  const LatLongTarget({
    super.key,
    required CustomPoint<double>? position,
  }) : _position = position;

  final CustomPoint<double>? _position;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: _position!.x - 10,
        top: _position!.y - 10,
        height: 20,
        width: 20,
        child: const Icon(Icons.location_searching));
  }
}
