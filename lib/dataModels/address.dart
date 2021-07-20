class Address {
  String placeName;
  double latitude;
  double longitude;
  String? formattedPlaceAddress;
  String? placeID;
  Address({
    required this.placeName,
    required this.latitude,
    required this.longitude,
    this.placeID,
    this.formattedPlaceAddress,
  });
}
