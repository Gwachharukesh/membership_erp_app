// // ignore_for_file: use_build_context_synchronously

// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';



// final locationUtilsProvider = Provider<LocationUtils>((ref) => LocationUtils());
// final FutureProvider<LatLng?> liveLocationProvider =
//     FutureProvider<LatLng?>((ref) async {
//   bool locationRetrieved =
//       false; // Flag to track if location is retrieved within 15 seconds

//   // Show loading indicator
//   EasyLoading.show(status: 'Getting Location');

//   // Set up a Future.delayed to dismiss loading indicator after 15 seconds
//   Future.delayed(const Duration(seconds: 15), () {
//     if (!locationRetrieved) {
//       EasyLoading
//           .dismiss(); // Dismiss loading indicator if location not retrieved within 15 seconds
//     }
//   });

//   try {
//     // Check if location permission is granted
//     if (await LocationUtils.checkLocationPermission()) {
//       var result = await LocationUtils.getUserCurrentLocation();
//       locationRetrieved = true;
//       // String placemark = await LocationUtils.getPlaceNameOnly(
//       //   latLng: LatLng(result.latitude, result.longitude),
//       // );

//       // ref.read(locationNameProvider.notifier).update((state) => placemark);
//       ref
//           .read(selectedLocationProvider.notifier)
//           .update((state) => LatLng(result.latitude, result.longitude));
//       EasyLoading
//           .dismiss(); // Dismiss loading indicator since location is retrieved
//       return LatLng(result.latitude, result.longitude);
//     } else {
//       bool enablePermission = await LocationUtils.requestLocationPermission();
//       if (enablePermission) {
//         var result = await LocationUtils.getUserCurrentLocation();
//         locationRetrieved = true;
//         // String placemark = await LocationUtils.getPlaceNameOnly(
//         //   latLng: LatLng(result.latitude, result.longitude),
//         // );

//         // ref.read(locationNameProvider.notifier).update((state) => placemark);
//         ref
//             .read(selectedLocationProvider.notifier)
//             .update((state) => LatLng(result.latitude, result.longitude));
//         EasyLoading
//             .dismiss(); // Dismiss loading indicator since location is retrieved
//         return LatLng(result.latitude, result.longitude);
//       } else {
//         EasyLoading.dismiss();
//         throw 'Location permission denied by user';
//       }
//     }
//   } catch (e) {
//     EasyLoading.dismiss();
//     // Handle any exception to prevent crashing the code
//     log('Error getting current location: $e');
//     EasyLoading.showToast('Error: $e. Please try again.');
//     var position = await LocationUtils._getCachedLocation();
//     return LatLng(position.latitude, position.longitude);
//   }
// });

// final locationNameProvider = StateProvider<String?>((ref) {
//   return;
// });

// class LocationUtils {
//   static const kathmanduGps = LatLng(27.700769, 85.300140);
//   static String gpsErrorMessage =
//       'GPS is disabled. Please enable it manually in the system settings to continue using location-based features.';
//   static String gpsPermissionErrorMessage =
//       'Location Permission is disabled. Please enable it manually in the system settings to continue using location-based features.';
//   DateTime? lastDistanceFetchTime;

//   static Position getDefaultPosition() => Position(
//         longitude: 0.0,
//         latitude: 0.0,
//         timestamp: DateTime.now(),
//         accuracy: 0.0,
//         altitude: 0.0,
//         altitudeAccuracy: 0.0,
//         heading: 0.0,
//         headingAccuracy: 0.0,
//         speed: 0.0,
//         speedAccuracy: 0.0,
//         isMocked: true,
//       );

//   static Future<bool> requestLocationPermission() async {
//     LocationPermission permission = await Geolocator.requestPermission();
//     return permission == LocationPermission.always ||
//         permission == LocationPermission.whileInUse;
//   }

//   static Future<bool> checkLocationPermission() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.always ||
//         permission == LocationPermission.whileInUse) {
//       return true;
//     } else {
//       // Ask for permission again
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.always ||
//           permission == LocationPermission.whileInUse) {
//         return true;
//       } else {
//         // Show EasyLoading toast message
//         EasyLoading.showToast('Location permission not granted.');
//         return false;
//       }
//     }
//   }

//   // Future<bool> checkLocationServices() async {
//   //   var isLocationEnabled = await Geolocator.isLocationServiceEnabled();

//   //   // If location is disabled, prompt the user to enable it
//   //   if (!isLocationEnabled) {
//   //     await _openLocationSettings();
//   //     return await Geolocator.isLocationServiceEnabled();
//   //   } else {
//   //     return true;
//   //   }
//   // }
//   //  Future<void> _openLocationSettings() async {
//   //   await Geolocator.openLocationSettings();
//   //   // Optionally, you can navigate back to a specific screen or just stay here
//   // }

//   static Future<bool> checkLocationService() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

//       if (!serviceEnabled) {
//         // Attempt to open location settings
//         await Geolocator.openLocationSettings();
//         bool service = await Geolocator.isLocationServiceEnabled();
//         if (!service) {
//           EasyLoading.showError(
//             'Location services are disabled.Location Track will not be active ',
//           );
//           return false;
//         } else {
//           return true;
//         }
//       } else {
//         log('Location services are enabled.');
//         return true;

//         // Proceed with fetching location data
//       }
//     } catch (e) {
//       return false;
//       // Handle any errors that occur during the process
//     }
//   }

//   static Future<Position> getUserCurrentLocation({
//     LocationAccuracy accuracy = LocationAccuracy.high,
//     Duration timeout = const Duration(seconds: 6),
//   }) async {
//     try {
//       // 1. Check Location Service
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         throw 'Location services are disabled.';
//       }

//       // 2. Check Permission
//       bool permissionGranted = await checkLocationPermission();
//       if (!permissionGranted) {
//         throw 'Location permission denied.';
//       }

//       // 3. Fetch Current Position (with timeout)
//       Position position = await Geolocator.getCurrentPosition(
//         locationSettings: LocationSettings(accuracy: accuracy),
//       ).timeout(
//         timeout,
//         onTimeout: () async {
//           var lastKnownPosition = await Geolocator.getLastKnownPosition();
//           if (lastKnownPosition != null) {
//             return lastKnownPosition;
//           }
//           return getDefaultPosition();
//         },
//       );

//       return position;
//     } catch (e) {
//       var lastKnownPosition = await Geolocator.getLastKnownPosition();
//       if (lastKnownPosition != null) {
//         return lastKnownPosition;
//       }

//       // 5. Fallback: Default Position (if no cache)
//       return getDefaultPosition();
//     }
//   }

//   Future<dynamic> getDistanceBetween({required LatLng location}) async {
//     return '';
//     // try {
//     //   // Check if it's been at least 30 seconds since the last distance fetch
//     //   if (lastDistanceFetchTime != null &&
//     //       DateTime.now().difference(lastDistanceFetchTime!) < const Duration(seconds: 20)) {
//     //     // Wait for 30 seconds before fetching distance again
//     //     await Future.delayed(const Duration(seconds: 20));
//     //   }

//     //   var value = await getUserCurrentLocation();
//     //   double distance = Geolocator.distanceBetween(
//     //     location.latitude,
//     //     location.longitude,
//     //     value.latitude,
//     //     value.longitude,
//     //   );

//     //   // Update the last fetch time
//     //   lastDistanceFetchTime = DateTime.now();

//     //   return distance;
//     // } on SocketException catch (e) {
//     //   log('Timeout while getting current location. $e');
//     //   EasyLoading.showToast('No Internet Connection');
//     //   return 0;
//     // } on TimeoutException {
//     //   // Notify the user that the operation timed out and give them a chance to retry
//     //   EasyLoading.showToast(
//     //     'Failed to get location within 10 seconds. Please try again.',
//     //   );
//     //   return 0;
//     // } on PlatformException {
//     //   // EasyLoading.showToast('Could not parse distance . Please try again.');
//     //   return 0;
//     // } catch (e) {
//     //   //EasyLoading.showToast('Unexpected error: Please try again.');
//     //   return 0;
//     // }
//   }

//   // Helper function to retrieve the cached location or return a default position
//   static Future<Position> _getCachedLocation() async {
//     try {
//       var cachedLocation = await Geolocator.getLastKnownPosition().timeout(
//         const Duration(seconds: 10),
//         onTimeout: () {
//           throw TimeoutException(
//             'Timeout occurred while fetching cached location',
//           );
//         },
//       );

//       return cachedLocation ?? getDefaultPosition();
//     } on SocketException catch (e) {
//       log('Timeout while getting current location. $e');
//       EasyLoading.showToast('No Internet Connection');
//       return getDefaultPosition();
//     } on PlatformException {
//       return getDefaultPosition(); // Return a default value or handle the error as needed
//     } on TimeoutException {
//       EasyLoading.showToast(
//         'Timeout Exception:on getting Location',
//         toastPosition: EasyLoadingToastPosition.bottom,
//       );

//       return getDefaultPosition(); // Return a default value or handle the error as needed
//     } catch (e) {
//       EasyLoading.showToast(
//         'An error occurred: $e',
//         toastPosition: EasyLoadingToastPosition.bottom,
//       );

//       return getDefaultPosition(); // Return a default value or handle the error as needed
//     }
//   }

//   static Future<bool> isGpsEnabled() async =>
//       await Geolocator.isLocationServiceEnabled();

//   /// Check and request location permission
//   static Future<bool> checkAndRequestPermission({
//     required BuildContext context,
//     Future<void> Function()? onSkipFunction,
//   }) async {
//     try {
//       // Check if location services are enabled
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         var shouldContinue = await showLocationErrorDialogue(
//           context: context,
//           isPermissionError: false,
//           onSkipFunction: onSkipFunction,
//         );
//         return shouldContinue ?? false;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();

//       if (permission == LocationPermission.whileInUse ||
//           permission == LocationPermission.always) {
//         return true;
//       }

//       if (permission == LocationPermission.deniedForever) {
//         var shouldContinue = await showLocationErrorDialogue(
//           context: context,
//           isPermissionError: true,
//           onSkipFunction: onSkipFunction,
//         );
//         return shouldContinue ?? false;
//       }

//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         return permission == LocationPermission.whileInUse ||
//             permission == LocationPermission.always;
//       }

//       return false;
//     } catch (e) {
//       debugPrint('Permission check error: $e');
//       return false;
//     }
//   }

//   static Future<dynamic> showLocationErrorDialogue({
//     required BuildContext context,
//     required bool isPermissionError,
//     required Future<void> Function()? onSkipFunction,
//   }) {
//     return showDialog(
//       context: context,
//       builder: (context) {
//         bool isNepali = true; // Initial language state
// //अर्डर ,ट्रयाक
//         return StatefulBuilder(
//           builder: (context, setState) {
//             var permissionErrorTItle = isNepali
//                 ? 'लोकेशन अनुमतिमा दिसएबल छ'
//                 : 'Location Permission Denied';
//             var subtitle = isNepali
//                 ? 'अर्डर  तथा लोकेशन  ट्रयाक मा समस्या हुन सक्छ'
//                 : 'It might error on order and location tracking';
//             var gpsErrorTItle =
//                 isNepali ? 'Gps अनुमतिमा दिसएबल छ' : 'Gps is disabled';
//             return AlertDialog(
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Language Toggle Row
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton.icon(
//                       icon: const Icon(Icons.language),
//                       onPressed: () => setState(() => isNepali = !isNepali),
//                       label: Text(!isNepali ? 'नेपाली' : 'English'),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     textAlign: TextAlign.center,
//                     isPermissionError ? permissionErrorTItle : gpsErrorTItle,
//                     style: Theme.of(context).textTheme.titleSmall,
//                   ),
//                   Text(
//                     textAlign: TextAlign.center,
//                     subtitle,
//                     style: Theme.of(context).textTheme.labelMedium,
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   // Icon
//                   const Icon(Icons.location_off, size: 60, color: Colors.red),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   // Instruction Title
//                   Text(
//                     isNepali
//                         ? isPermissionError
//                             ? 'लोकेशन अनुमतिमा प्रदान गर्नुस '
//                             : 'GPS सुविधा सक्रिय गर्नुस '
//                         : isPermissionError
//                             ? 'Enable Location Permission:'
//                             : 'Enable Gps Access',
//                     style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),

//                   // Instructions
//                   Text(
//                     isNepali
//                         ? isPermissionError
//                             ? 'नोट :कृपया "Allow only while using the app" or "Allow all the time" चयन गर्नुहोस्'
//                             : 'नोट : उच्च सटिकता (High Accuracy) मोड चयन गर्नुहोस्'
//                         : isPermissionError
//                             ? 'Note: Choose "Allow only while using the app" or "Allow all the time"'
//                             : 'Note: Select High Accuracy mode',
//                     textAlign: TextAlign.left,
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   // Buttons
//                   CustomElevatedButton(
//                     onPressed: () async {
//                       try {
//                         Navigator.pop(context);

//                         if (!isPermissionError) {
//                           await Geolocator.openLocationSettings();
//                         } else {
//                           try {
//                             var permission =
//                                 await Geolocator.requestPermission();
//                             if (permission == LocationPermission.whileInUse ||
//                                 permission == LocationPermission.always) {
//                               return;
//                             }

//                             if (permission ==
//                                 LocationPermission.deniedForever) {
//                               await openAppSettings();
//                             }
//                           } catch (e) {
//                             await openAppSettings();
//                           }
//                         }
//                       } catch (e) {
//                         await openAppSettings();
//                       }

//                       // Requires permission_handler package
//                     },
//                     title: isNepali ? 'सेटिङ खोल्नुहोस्' : 'Open Settings',
//                   ),
//                   const SizedBox(width: 10),

//                   AnimatedGoToButton(
//                     style: DynamicTheme.blue15pxsemibold,
//                     title: isNepali
//                         ? 'छोड्नुहोस् र अगाडि जानुहोस् '
//                         : 'Skip to Forward',
//                     color: DynamicTheme.primaryBlueColor,
//                     padding: 16,
//                     ontap: () async {
//                       if (onSkipFunction != null) {
//                         await onSkipFunction.call();
//                       }
//                     },
//                   ),
//                   // GreenArrowAddedButton(
//                   //   onTap: () async {
//                   //     if (onSkipFunction != null) {
//                   //       await onSkipFunction.call();
//                   //     }
//                   //   },
//                   //   title: isNepali ? 'छोड्नुहोस्' : 'Skip',
//                   // ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   /// Handle enabling GPS
//   static Future<bool> enableGps(context) async {
//     bool gpsEnabled = await isGpsEnabled();

//     if (!gpsEnabled) {
//       bool status = await showGpsStatusErrorDialog(
//         context,
//       );

//       return status;
//     } else {
//       return true;
//     }
//   }

//   static Future<bool> checkLocationAccess(BuildContext context) async {
//     try {
//       // Check and request location permission
//       bool permission = await checkAndRequestPermission(
//         context: context,
//       );

//       bool gpsEnabled = await enableGps(context);

//       return gpsEnabled && permission;
//     } catch (e) {
//       return false;
//     }
//   }

//   static Future<bool> showGpsStatusErrorDialog(BuildContext context) async {
//     bool? status = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: RichText(
//           text: const TextSpan(
//             children: [
//               WidgetSpan(
//                 alignment: PlaceholderAlignment.middle,
//                 child: Icon(
//                   Icons.error,
//                   color: Colors.red,
//                   size: 24,
//                 ),
//               ),
//               TextSpan(
//                 text: ' GPS is disabled',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 18,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         content: RichText(
//           text: const TextSpan(
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 12,
//             ),
//             children: [
//               TextSpan(text: '1. Location or GPS permission is disabled.\n'),
//               TextSpan(
//                 text:
//                     '2. Location services and GPS are required to use background service.\n\n',
//               ),
//               TextSpan(
//                 text: 'Would you like to open settings to enable them?',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           Row(
//             children: [
//               Expanded(
//                 child: CustomElevatedButton(
//                   color: Colors.redAccent,
//                   child: const Text('Cancel'),
//                   onPressed: () async {
//                     bool gpsEnabled = await isGpsEnabled();
//                     if (context.mounted) {
//                       Navigator.of(context).pop(gpsEnabled);
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(width: 4),
//               Expanded(
//                 child: CustomElevatedButton(
//                   color: Colors.green,
//                   onPressed: () async {
//                     try {
//                       await Geolocator.openLocationSettings();
//                       Future.delayed(const Duration(seconds: 1));
//                       bool gpsEnabled = await isGpsEnabled();
//                       if (context.mounted) {
//                         Navigator.pop(context, gpsEnabled);
//                       }
//                     } catch (e) {
//                       log('Error opening location settings: $e');
//                       // Optionally show an error message to the user
//                     }
//                   },
//                   child: const Text('Enable'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );

//     return status ?? false;
//   }

//   static Future<bool> showGpsPermisionStatusErrorDialog(
//     BuildContext context,
//   ) async {
//     bool? status = await showAdaptiveDialog<bool>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog.adaptive(
//         title: RichText(
//           text: const TextSpan(
//             children: [
//               WidgetSpan(
//                 alignment: PlaceholderAlignment.middle,
//                 child: Icon(
//                   Icons.error,
//                   color: Colors.red,
//                   size: 24,
//                 ),
//               ),
//               TextSpan(
//                 text: 'Location permission is disabled',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 18,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         content: RichText(
//           text: const TextSpan(
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 12,
//             ),
//             children: [
//               TextSpan(
//                 text: '1. Location or GPS permission is disabled.\n',
//               ),
//               TextSpan(
//                 text:
//                     '2. Location services and GPS are required to use background service.\n\n',
//               ),
//               TextSpan(
//                 text: 'Would you like to open settings to enable them?',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           Row(
//             children: [
//               Expanded(
//                 child: CustomElevatedButton(
//                   width: 100,
//                   child: const Text('Cancel'),
//                   onPressed: () async {
//                     LocationPermission permission =
//                         await Geolocator.checkPermission();
//                     if (permission == LocationPermission.denied ||
//                         permission == LocationPermission.deniedForever) {
//                       if (context.mounted) {
//                         Navigator.pop(context, false);
//                       }
//                     } else {
//                       if (context.mounted) {
//                         Navigator.pop(context, true);
//                       }
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 width: 5,
//               ),
//               Expanded(
//                 child: CustomElevatedButton(
//                   width: 100,
//                   color: Colors.green,
//                   onPressed: () async {
//                     // Open location settings
//                     await Geolocator.openAppSettings();
//                     Future.delayed(const Duration(seconds: 1));
//                     LocationPermission permission =
//                         await Geolocator.checkPermission();
//                     if (permission == LocationPermission.denied ||
//                         permission == LocationPermission.deniedForever) {
//                       if (context.mounted) {
//                         Navigator.pop(
//                           context,
//                           false,
//                         ); // Return the GPS status
//                       }
//                     } else {
//                       if (context.mounted) {
//                         Navigator.pop(context, true);
//                       }
//                     }
//                   },
//                   child: const Text('Enable'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );

//     // Return the status if the dialog was closed with an OK or Cancel action
//     return status ?? false; // Default to false if null
//   }
// }
