// class Getdirection {
//   Future<void> _openMap() async {
//   // 🗺️ Mess address 
//   const String destination = "123, Foodie Lane, Gourmet City";
  
//   // Convert address to a Google Maps search query
//   final Uri googleUrl = Uri.parse(
//     'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(destination)}&travelmode=driving',
//   );

//   if (await canLaunchUrl(googleUrl)) {
//     await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
//   } else {
//     throw 'Could not open the map.';
//   }
// }

// }AIzaSyCr0Yqr4orUuYR3fdee6LMiEwPcBce33v8