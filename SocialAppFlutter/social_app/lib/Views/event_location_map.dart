import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_app/Models/directions.dart';
import 'package:social_app/services/directions_service.dart';

class EventLocationMapView extends StatefulWidget {
  const EventLocationMapView({super.key});

  @override
  State<EventLocationMapView> createState() => _EventLocationMapViewState();
}

class _EventLocationMapViewState extends State<EventLocationMapView> {
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(44.410701280868125, 26.08268238288809), zoom: 15.5);

  GoogleMapController? _googleMapController;
  Marker? _origin = Marker(
        markerId: const MarkerId("origin"),
        infoWindow: const InfoWindow(title: "Origin"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: const LatLng(45.4437930888083, 28.028624683371596));
  Marker? _destination = Marker(
        markerId: const MarkerId("destination"),
        infoWindow: const InfoWindow(title: "Destination"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: const LatLng(45.435045608379596, 28.01709732313935));
  Directions? _info;
  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              if (_origin != null) _origin!,
              if (_destination != null) _destination!
            },
            polylines: {
              if(_info != null)
              Polyline(polylineId: const PolylineId('overview_polyline'),
              color: Colors.red,
              width: 5,
              points: _info!.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList()
              )
            },
            // onLongPress: _addMarker,
          ),
          if(_info != null)
            Positioned(
              top: 30.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0
                    )
                  ]
                ),
                child: Text(
                  '${_info!.totalDistance}, ${_info!.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        mini: true,
        onPressed: () => _googleMapController?.animateCamera(
          _info != null 
            ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
            : CameraUpdate.newCameraPosition(_initialCameraPosition)),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      //origin is not set OR origin/destination are both set
      //set origin

      setState(() {
        _origin = Marker(
            markerId: const MarkerId("origin"),
            infoWindow: const InfoWindow(title: "Origin"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: pos);
        _destination = null; // reset destination
        _info = null;       // reset info
      });
    } else {
      //origin is already set
      //set destination
      setState(() {
        _destination = Marker(
            markerId: const MarkerId("destination"),
            infoWindow: const InfoWindow(title: "Destination"),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position: pos);
      });

      //get directions
      final directions = await DirectionsService()
          .getDirections(_origin!.position, _destination!.position);

      setState(() {
        _info = directions;
      });
    }
  }
}
