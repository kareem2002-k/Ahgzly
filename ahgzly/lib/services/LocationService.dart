// ignore: file_names
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<String> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placemark = placemarks[0];

      // Return the formatted location as a string
      return '${placemark.locality}, ${placemark.country}';
    } catch (e) {
      print(e);
      return 'Location not found';
    }
  }
}
