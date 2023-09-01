import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_app/services/ievents_service.dart';
import 'package:social_app/utilities/service_locator/locator.dart';

import '../services/events/get_new_requested_location_info_for_payment_response.dart';

class PaymentVerificationCodeViewModel extends ChangeNotifier {
  TextEditingController verificationCodeController = TextEditingController();
  bool _processing = false;
  bool _found = false;
  String _ownerEmail = "";
  String _sportCategory = "";
  String _city = "";
  String _locationName = "";
  int _approvedLocationId = 0;
  double cameraStandardZoom = 16.616104125976562;
  LatLng? selectedLocationCoordinates;
  BitmapDescriptor locationPinIcon = BitmapDescriptor.defaultMarker;

  String get verificationCode => verificationCodeController.text;
  bool get processing => _processing;
  bool get found => _found;
  String get sportCategory => _sportCategory;
  String get city => _city;
  String get locationName => _locationName;
  String get ownerEmail => _ownerEmail;
  int get approvedLocationId => _approvedLocationId;
  Map<String, Marker> mapMarkers = {};

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
        position: selectedLocationCoordinates!,
        icon: locationPinIcon,
        zIndex: 1);

    mapMarkers[pickMarker.markerId.value] = pickMarker;

    notifyListeners();
  }

  setOwnerEmail(String ownerEmail) {
    _ownerEmail = ownerEmail;
    notifyListeners();
  }

  setSportCategory(String sportCategory) {
    _sportCategory = sportCategory;
    notifyListeners();
  }

  setCity(String city) {
    _city = city;
    notifyListeners();
  }

  setLocationName(String locationName) {
    _locationName = locationName;
    notifyListeners();
  }

  setApprovedLocationId(int approvedLocationId) {
    _approvedLocationId = approvedLocationId;
    notifyListeners();
  }

  setProcessing(bool processing) {
    _processing = processing;
    notifyListeners();
  }

  setFound(bool found) {
    _found = found;
    notifyListeners();
  }

  Future<GetNewRequestedLocationInfoForPaymentResponse?>
      submitVerificationCode() async {
    var response = await provider
        .get<IEventsService>()
        .getNewRequestedLocationInfoForPayment(verificationCode);

    if (response!.found) {
      setCity(response.city);
      setLocationName(response.locationName);
      setSportCategory(response.sportCategory!.name);
      setLocationName(response.locationName);
      setOwnerEmail(response.ownerEmail);
      setApprovedLocationId(response.approvedLocationId!);
      selectedLocationCoordinates = LatLng(
          response.coordinates!.latitude, response.coordinates!.longitude);

      await addCustomIconToLocationPicker();
      initializePinPointMarker();

      setFound(true);
    }

    return response;
  }
}
