import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class LocationRepository {
  static LocationData currentLocation;
  static Location location;
  static List<Address> addresses;

  static Future<Address> getLocation() async {
    location = Location();
    try {
      currentLocation = await location.getLocation();
      addresses = await Geocoder.local.findAddressesFromCoordinates(
          Coordinates(currentLocation.latitude, currentLocation.longitude));
    } catch (_) {
      currentLocation = null;
    }
    return addresses.first;
  }

  static String getCityName(Address address) {
    String addressLine = address.addressLine;
    addressLine = addressLine.replaceAll(' Governorate', '');
    List<String> addressList = addressLine.split(', ');
    return '${addressList[addressList.length - 2]}, ${addressList[addressList.length - 1]}';
  }
}
