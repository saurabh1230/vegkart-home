// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import '../../controller/add_address_controller.dart';
// import '../../model/address_model.dart';
//
//
// class LocationPickerScreen extends StatelessWidget {
//   final bool isAddress;
//
//   LocationPickerScreen({super.key, this.isAddress = false});
//   final AddAddressController locationController = Get.put(AddAddressController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select Your Location'),
//         centerTitle: true,
//       ),
//       body: GetBuilder<AddAddressController>(
//         builder: (controller) {
//           if (controller.latitude == null || controller.longitude == null) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           LatLng center = LatLng(
//             controller.latitude ?? 0.0,
//             controller.longitude ?? 0.0,
//           );
//
//           return Stack(
//             children: [
//               GoogleMap(
//                 mapToolbarEnabled: false,
//                 onMapCreated: controller.onMapCreated,
//                 initialCameraPosition: CameraPosition(
//                   target: center,
//                   zoom: 14.0,
//                 ),
//                 markers: {
//                   Marker(
//                     markerId: const MarkerId('currentLocation'),
//                     position: center,
//                   ),
//                 },
//                 onCameraMove: (CameraPosition position) {
//                   controller.latitude = position.target.latitude;
//                   controller.longitude = position.target.longitude;
//                   controller.update();  // Notify UI
//                 },
//               ),
//               Positioned(
//                 top: 16,
//                 left: 16,
//                 right: 16,
//                 child: TypeAheadField(
//                   textFieldConfiguration: TextFieldConfiguration(
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Theme.of(context).cardColor,
//                       hintText: 'Search Location',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   suggestionsCallback: (pattern) async {
//                     await controller.fetchSuggestions(pattern);
//                     return controller.suggestions;
//                   },
//                   itemBuilder: (context, suggestion) {
//                     return ListTile(
//                       title: Text(suggestion['description'] ?? ''),
//                     );
//                   },
//                   onSuggestionSelected: (suggestion) async {
//                     String placeId = suggestion['place_id'] ?? '';
//                     await controller.fetchLocationDetails(placeId);
//                   },
//                 ),
//               ),
//               Positioned(
//                 bottom: 20,
//                 left: 20,
//                 right: 20,
//                 child: CustomButtonWidget(
//                   buttonText: 'Continue',
//                   onPressed: () {
//                     // After address selection, update controller and go back
//                     controller.locality.value.text = controller.locality.value.text;
//                     controller.userLocation.value = UserLocation(
//                       latitude: controller.latitude ?? 0.0,
//                       longitude: controller.longitude ?? 0.0,
//                     );
//
//                     Get.back();  // Navigate back after address selection
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
