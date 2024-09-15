import 'dart:developer';

import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/app/ui/dashboard_screen/dashboard_screen.dart';
import 'package:ebasket_customer/app/ui/delivery_address_screen/delivery_address_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/services/helper.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/theme/light_theme.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset("assets/images/location_screen.png"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 32, right: 16, bottom: 8),
            child: Text(
              "Find product near you",
              textAlign: TextAlign.center,
              style: TextStyle(color: appColor, fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "By allowing location access, you can search for product near you and receive more accurate delivery.",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appColor,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                    color: appColor,
                  ),
                ),
              ),
              child: Text(
                "Use current location",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              onPressed: () {
                checkPermission(
                  () async {
                    await ShowToastDialog.showLoader("Please Wait");

                    AddressModel addressModel = AddressModel();
                    try {
                      await Geolocator.requestPermission();
                      Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

                      await placemarkFromCoordinates(23.0454913, 72.5315662).then((valuePlaceMaker) {
                        Placemark placeMark = valuePlaceMaker[0];
                        addressModel.id = Uuid().v4();
                        addressModel.location = UserLocation(latitude: 23.0454913, longitude: 72.5315662);
                        String currentLocation =
                            "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";
                        addressModel.locality = currentLocation;
                      });

                      Constant.selectedPosition = addressModel;
                      await ShowToastDialog.closeLoader();
                      Get.offAll(const DashBoardScreen());
                    } catch (e) {
                      await placemarkFromCoordinates(19.228825, 72.854118).then((valuePlaceMaker) {
                        Placemark placeMark = valuePlaceMaker[0];
                        addressModel.id = Uuid().v4();
                        addressModel.location = UserLocation(latitude: 19.228825, longitude: 72.854118);
                        String currentLocation =
                            "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";
                        addressModel.locality = currentLocation;
                      });

                      Constant.selectedPosition = addressModel;
                      await ShowToastDialog.closeLoader();
                      Get.offAll(const DashBoardScreen());
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appColor,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                    color: appColor,
                  ),
                ),
              ),
              child: Text(
                "Set from map",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              onPressed: () async {
                checkPermission(
                  () async {
                    await ShowToastDialog.showLoader("Please Wait");
                    AddressModel addressModel = AddressModel();
                    try {
                      await Geolocator.requestPermission();
                      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                      await ShowToastDialog.closeLoader();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlacePicker(
                            apiKey: Constant.mapKey,
                            onPlacePicked: (result) async {
                              addressModel.id = Uuid().v4();
                              addressModel.locality = result.formattedAddress!.toString();
                              addressModel.location = UserLocation(latitude: result.geometry!.location.lat, longitude: result.geometry!.location.lng);
                              log(result.toString());
                              Constant.selectedPosition = addressModel;
                              Get.offAll(const DashBoardScreen());
                            },
                            initialPosition: LatLng(-33.8567844, 151.213108),
                            useCurrentLocation: true,
                            selectInitialPosition: true,
                            usePinPointingSearch: true,
                            usePlaceDetailSearch: true,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            resizeToAvoidBottomInset: false, // only works in page mode, less flickery, remove if wrong offsets
                          ),
                        ),
                      );
                    } catch (e) {
                      await placemarkFromCoordinates(19.228825, 72.854118).then((valuePlaceMaker) {
                        Placemark placeMark = valuePlaceMaker[0];
                        addressModel.id = Uuid().v4();
                        addressModel.location = UserLocation(latitude: 19.228825, longitude: 72.854118);
                        String currentLocation =
                            "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";
                        addressModel.locality = currentLocation;
                      });

                      Constant.selectedPosition = addressModel;
                      await ShowToastDialog.closeLoader();
                      Get.offAll(const DashBoardScreen());
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
