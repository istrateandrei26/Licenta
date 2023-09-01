import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_app/Models/place_autocomplete_suggestion.dart';
import 'package:social_app/Models/user_coordinates.dart';
import 'package:social_app/components/location_list_tile.dart';
import 'package:social_app/services/google_place_service.dart';
import 'package:social_app/utilities/constants.dart';

import '../services/location_service.dart';

class ChooseMapLocationView extends StatefulWidget {
  const ChooseMapLocationView({super.key});

  @override
  State<ChooseMapLocationView> createState() => _ChooseMapLocationViewState();
}

class _ChooseMapLocationViewState extends State<ChooseMapLocationView> {
  final _searchLocationFieldController = TextEditingController();
  GoogleMapController? _controller;
  List<PlaceAutocompleteSuggestion> placeSuggestions = [];
  final LatLng _center = const LatLng(46, 24);
  final StreamController<LatLng> _centerStreamController =
      StreamController<LatLng>.broadcast();

  BitmapDescriptor myIcon = BitmapDescriptor.defaultMarker;

  void placeAutocomplete(String query) async {
    var suggestions =
        await GooglePlaceService.fetchAutocompleteSuggestions(query);

    placeSuggestions = suggestions;
  }

  Future<UserCoordinates?> getLocation() async {
    var userCoordinates = await LocationService.getUserLocation();

    if (userCoordinates == null) {
      await getLocation();
    }

    return userCoordinates;
  }

  void _currentLocation() async {
    late UserCoordinates? userLocation;
    userLocation = await getLocation();

    if (userLocation == null)
      _controller?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(userLocation!.latitude, userLocation.longitude),
          zoom: 15.0,
        ),
      ));
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(20, 20)),
            'assets/icons/pin-point.png')
        .then((onValue) {
      setState(() {
        myIcon = onValue;
      });
    });
  }

  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }

  @override
  void dispose() {
    _centerStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Choose freely wherever you want",
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  elevation: 20,
                  color: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: StreamBuilder<LatLng>(
                        stream: _centerStreamController.stream,
                        initialData: _center,
                        builder: (context, snapshot) {
                          return Stack(children: [
                            GoogleMap(
                              markers: <Marker>{
                                Marker(
                                  markerId: const MarkerId('myMarker'),
                                  position: snapshot.data!,
                                  icon: myIcon,
                                  infoWindow:
                                      const InfoWindow(title: 'My Marker'),
                                ),
                              },
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: false,
                              zoomGesturesEnabled: placeSuggestions.isEmpty,
                              onMapCreated: (controller) {
                                _controller = controller;
                                _controller?.getVisibleRegion();
                              },
                              onCameraMove: (CameraPosition position) {
                                _centerStreamController.add(position.target);
                              },
                              myLocationEnabled: true,
                              initialCameraPosition:
                                  CameraPosition(target: snapshot.data!),
                            ),
                            Positioned(
                              bottom: 20,
                              right: 20,
                              child: FloatingActionButton(
                                backgroundColor: Colors.blue.shade100,
                                onPressed: _currentLocation,
                                child: const Icon(
                                  Icons.location_on,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              left: 20,
                              right: 20,
                              child: Column(
                                children: [
                                  Form(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        elevation: 10,
                                        color: Colors.transparent,
                                        child: TextFormField(
                                          controller:
                                              _searchLocationFieldController,
                                          onChanged: (value) {
                                            setState(() {
                                              placeAutocomplete(value);
                                            });

                                            if (value.isEmpty) {
                                              setState(() {
                                                placeSuggestions.clear();
                                              });
                                            }
                                          },
                                          textInputAction:
                                              TextInputAction.search,
                                          cursorColor: kPrimaryColor,
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.blue.shade100,
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    style: BorderStyle.none,
                                                    width: 0),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              hintText: "Search location",
                                              suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    setState(() {
                                                      placeSuggestions.clear();
                                                      _searchLocationFieldController
                                                          .clear();
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: kPrimaryColor,
                                                  )),
                                              prefixIcon: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12),
                                                child: Icon(
                                                  Icons.location_on_outlined,
                                                  color: kPrimaryColor,
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: placeSuggestions.isNotEmpty,
                                    child: Container(
                                      color: placeSuggestions.isEmpty
                                          ? Colors.transparent
                                          : Colors.white,
                                      height: 200,
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: placeSuggestions.length,
                                        itemBuilder: (context, index) =>
                                            InkWell(
                                          onTap: () async {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            var location =
                                                await GooglePlaceService
                                                    .fetchLocation(
                                                        placeSuggestions[index]
                                                            .placeId);
                                            setState(() {
                                              placeSuggestions.clear();
                                            });
                                            _controller?.animateCamera(
                                                CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                bearing: 0,
                                                target: LatLng(
                                                    location.lat, location.lng),
                                                zoom: 15.0,
                                              ),
                                            ));
                                          },
                                          child: LocationListTile(
                                              location: placeSuggestions[index]
                                                  .description),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
