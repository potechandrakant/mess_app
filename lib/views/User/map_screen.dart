// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
// //   hide LatLng;

// // const String kGoogleApiKey =
// //     "GOOGLE_MAP_API";

// // class MapScreen extends StatefulWidget {
// //   const MapScreen({super.key});

// //   @override
// //   State<MapScreen> createState() => _MapScreenState();
// // }

// // class _MapScreenState extends State<MapScreen> {
// //   final Completer<GoogleMapController> _controller = Completer();
// //   final TextEditingController _searchController = TextEditingController();
// //   final FlutterGooglePlacesSdk _places = FlutterGooglePlacesSdk(kGoogleApiKey);

// //   static const LatLng _defaultLocation = LatLng(19.0760, 72.8777);
// //   LatLng _selectedLocation = _defaultLocation;

// //   String? _selectedAddress;

// //   List<AutocompletePrediction> _predictions = [];

// //   void _moveCamera(LatLng target) async {
// //     final GoogleMapController controller = await _controller.future;
// //     controller.animateCamera(
// //       CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 15)),
// //     );
// //   }

// //   Future<void> _onSearchChanged(String input) async {
// //     if (input.isEmpty) {
// //       setState(() => _predictions = []);
// //       return;
// //     }

// //     final result = await _places.findAutocompletePredictions(
// //       input,
// //       countries: ['in'],
// //     );

// //     setState(() {
// //       _predictions = result.predictions;
// //     });
// //   }

// //   Future<void> _selectPrediction(AutocompletePrediction prediction) async {
// //     final details = await _places.fetchPlace(prediction.placeId, fields: []);
// //     final loc = details.place?.latLng;

// //     if (loc != null) {
// //       final pos = LatLng(loc.lat, loc.lng);
// //       setState(() {
// //         _selectedLocation = pos;
// //         _selectedAddress = prediction.fullText;
// //         _predictions = [];
// //         _searchController.text = prediction.fullText;
// //       });
// //       _moveCamera(pos);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Map View'),
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back_outlined),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //       ),
// //       body: Stack(
// //         children: [
// //           // Google Map
// //           GoogleMap(
// //             onMapCreated: (controller) => _controller.complete(controller),
// //             initialCameraPosition: const CameraPosition(
// //               target: _defaultLocation,
// //               zoom: 14.0,
// //             ),
// //             markers: {
// //               Marker(
// //                 markerId: const MarkerId("selectedLocation"),
// //                 position: _selectedLocation,
// //               ),
// //             },
// //           ),

// //           // Search Bar + Suggestions
// //           Positioned(
// //             top: 15,
// //             left: 15,
// //             right: 15,
// //             child: Column(
// //               children: [
// //                 Card(
// //                   elevation: 5,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                   child: TextField(
// //                     controller: _searchController,
// //                     onChanged: _onSearchChanged,
// //                     decoration: const InputDecoration(
// //                       prefixIcon: Icon(Icons.search),
// //                       hintText: "Search for a location...",
// //                       border: InputBorder.none,
// //                       contentPadding: EdgeInsets.all(15),
// //                     ),
// //                   ),
// //                 ),

// //                 if (_predictions.isNotEmpty)
// //                   Container(
// //                     margin: const EdgeInsets.only(top: 5),
// //                     decoration: BoxDecoration(
// //                       color: Colors.white,
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                     child: ListView.builder(
// //                       shrinkWrap: true,
// //                       itemCount: _predictions.length,
// //                       itemBuilder: (context, index) {
// //                         final p = _predictions[index];
// //                         return ListTile(
// //                           leading: const Icon(Icons.location_on_outlined),
// //                           title: Text(p.fullText),
// //                           onTap: () => _selectPrediction(p),
// //                         );
// //                       },
// //                     ),
// //                   ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
//     hide LatLng;

// const String kGoogleApiKey = "GOOGLE_API_KEY";

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   final Completer<GoogleMapController> _controller = Completer();
//   final TextEditingController _searchController = TextEditingController();
//   final FlutterGooglePlacesSdk _places = FlutterGooglePlacesSdk(kGoogleApiKey);

//   static const LatLng _defaultLocation = LatLng(19.0760, 72.8777); // Mumbai
//   LatLng _selectedLocation = _defaultLocation;
//   String? _selectedAddress;
//   List<AutocompletePrediction> _predictions = [];

//   /// 🗺️ Moves camera smoothly to target location
//   void _moveCamera(LatLng target) async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(
//       CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 15)),
//     );
//   }

//   /// 🔍 Updates suggestions as user types
//   Future<void> _onSearchChanged(String input) async {
//     if (input.isEmpty) {
//       setState(() => _predictions = []);
//       return;
//     }

//     final result = await _places.findAutocompletePredictions(
//       input,
//       countries: ['in'],
//     );

//     setState(() {
//       _predictions = result.predictions;
//     });
//   }

//   /// 📍 When user taps a prediction
//   Future<void> _selectPrediction(AutocompletePrediction prediction) async {
//     final details = await _places.fetchPlace(
//       prediction.placeId,
//       fields: [PlaceField.Location, PlaceField.AddressComponents],
//     );

//     final loc = details.place?.latLng;

//     if (loc != null) {
//       final pos = LatLng(loc.lat, loc.lng);
//       setState(() {
//         _selectedLocation = pos;
//         _selectedAddress = prediction.fullText;
//         _predictions = [];
//         _searchController.text = prediction.fullText;
//       });
//       _moveCamera(pos);
//     }
//   }

//   /// 🚀 When user presses enter or search icon (manual entry)
//   Future<void> _searchAndGo() async {
//     final input = _searchController.text.trim();
//     if (input.isEmpty) return;

//     final result = await _places.findAutocompletePredictions(input);
//     if (result.predictions.isNotEmpty) {
//       _selectPrediction(result.predictions.first); // Go to first match
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Location not found")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Map View'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_outlined),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Stack(
//         children: [
//           // 🌍 Google Map
//           GoogleMap(
//             onMapCreated: (controller) => _controller.complete(controller),
//             initialCameraPosition: const CameraPosition(
//               target: _defaultLocation,
//               zoom: 14.0,
//             ),
//             markers: {
//               Marker(
//                 markerId: const MarkerId("selectedLocation"),
//                 position: _selectedLocation,
//               ),
//             },
//           ),

//           // 🔎 Search Bar + Predictions
//           Positioned(
//             top: 15,
//             left: 15,
//             right: 15,
//             child: Column(
//               children: [
//                 Card(
//                   elevation: 5,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: TextField(
//                     controller: _searchController,
//                     onChanged: _onSearchChanged,
//                     onSubmitted: (_) => _searchAndGo(), // 👈 handles "Enter"
//                     decoration: InputDecoration(
//                       prefixIcon: IconButton(
//                         icon: const Icon(Icons.search),
//                         onPressed: _searchAndGo, // 👈 handles "search" tap
//                       ),
//                       hintText: "Search for a location...",
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.all(15),
//                     ),
//                   ),
//                 ),

//                 if (_predictions.isNotEmpty)
//                   Container(
//                     margin: const EdgeInsets.only(top: 5),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: _predictions.length,
//                       itemBuilder: (context, index) {
//                         final p = _predictions[index];
//                         return ListTile(
//                           leading: const Icon(Icons.location_on_outlined),
//                           title: Text(p.fullText),
//                           onTap: () => _selectPrediction(p),
//                         );
//                       },
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  // Default location (Mumbai)
  static const LatLng _initialPosition = LatLng(19.0760, 72.8777);
  LatLng _selectedPosition = _initialPosition;

  // Called when map is created
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  // Called when user taps on map
  void _onMapTap(LatLng position) async {
    setState(() {
      _selectedPosition = position;
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(position));

    // You can now use _selectedPosition.latitude & longitude anywhere
    debugPrint(
      'Selected coordinates: ${position.latitude}, ${position.longitude}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Google Map Integration',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF5E4941),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: _initialPosition,
          zoom: 14.0,
        ),
        onTap: _onMapTap, // 👈 handle map tap
        markers: {
          Marker(
            markerId: const MarkerId('selectedLocation'),
            position: _selectedPosition,
            infoWindow: const InfoWindow(title: 'Selected Location'),
          ),
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF5E4941),
        onPressed: () {
          // Print or use coordinates here
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Latitude: ${_selectedPosition.latitude}, '
                'Longitude: ${_selectedPosition.longitude}',
              ),
            ),
          );
        },
        label: const Text('Get Coordinates'),
        icon: const Icon(Icons.location_on),
      ),
    );
  }
}
