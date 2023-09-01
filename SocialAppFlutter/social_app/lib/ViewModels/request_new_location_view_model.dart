import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_app/services/events/generate_new_location_response.dart';
import 'package:social_app/services/ievents_service.dart';
import 'package:social_app/utilities/service_locator/locator.dart';

import '../Models/sport_category.dart';
import '../utilities/sport_category_interpreter.dart';

class RequestNewLocationViewModel extends ChangeNotifier {
  bool _submittingNewLocationRequest = false;
  TextEditingController cityController = TextEditingController();
  TextEditingController locationNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool _processing = false;
  bool _isValidEmail = true;

  int _lastSelectedCategoryIndex = 0;
  GoogleMapController? controller;
  BitmapDescriptor locationPinIcon = BitmapDescriptor.defaultMarker;
  Map<String, Marker> mapMarkers = {};
  SportCategory _category = SportCategoryInterpreter.createSportCategoryByIndex(
      0); // init category with first selected item in icon widget list

  CameraPosition initialCameraPosition = const CameraPosition(
      target: LatLng(45.77774230529796, 24.797969833016396),
      zoom: 5.788174629211426);
  int get lastSelectedCategoryIndex => _lastSelectedCategoryIndex;
  bool get processing => _processing;
  bool get submittingNewLocationRequest => _submittingNewLocationRequest;
  LatLng? get selectedCoordinates => mapMarkers['pickMarker']?.position;

  String get email => emailController.text;
  String get city => cityController.text;
  String get locationName => locationNameController.text;
  bool get isValidEmail => _isValidEmail;

  setIsValidEmail(bool value) {
    _isValidEmail = value;
    notifyListeners();
  }

  Future addCustomIconToLocationPicker() async {
    var iconValue = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(20, 20)),
        'assets/icons/pin-point.png');
    locationPinIcon = iconValue;
    notifyListeners();
  }

  initializePinPointMarker() {
    var pickMarker = Marker(
        markerId: const MarkerId('pickMarker'),
        position: const LatLng(45.77774230529796, 24.797969833016396),
        icon: locationPinIcon,
        zIndex: 1);

    mapMarkers[pickMarker.markerId.value] = pickMarker;

    notifyListeners();
  }

  setSelectedCategory(SportCategory selectedCategory) {
    _category = selectedCategory;
    notifyListeners();
  }

  setLastSelectedCategoryIndex(int lastSelectedCategoryIndex) {
    _lastSelectedCategoryIndex = lastSelectedCategoryIndex;
    notifyListeners();
  }

  setProcessing(bool processing) {
    _processing = processing;
    notifyListeners();
  }

  setSubmittingNewLocationRequest(bool value) {
    _submittingNewLocationRequest = value;
  }

  Future<void> initialize() async {
    setProcessing(true);

    await addCustomIconToLocationPicker();
    initializePinPointMarker();

    setProcessing(false);
  }

  Future<GenerateNewLocationResponse?> submitNewLocationRequest() async {
    var response = await provider
        .get<IEventsService>()
        .generateNewLocationRequest(
            city,
            locationName,
            selectedCoordinates!.latitude,
            selectedCoordinates!.longitude,
            email,
            _category.id);

    return response;
  }
}
