class DirectionDetails {
  String distanceText;
  String durationText;
  int distanceValue;
  int durationValue;
  String encodedPoints;

  DirectionDetails({
    required this.distanceText,
    required this.distanceValue,
    required this.durationText,
    required this.durationValue,
    required this.encodedPoints,
  });

  static DirectionDetails fromJson(Map<String, dynamic> json){
    return DirectionDetails(
      distanceText: json['routes'][0]['legs'][0]['distance']['text'],
      distanceValue: json['routes'][0]['legs'][0]['distance']['value'],
      durationText: json['routes'][0]['legs'][0]['duration']['text'],
      durationValue: json['routes'][0]['legs'][0]['duration']['value'],
      encodedPoints: json['routes'][0]['overview_polyline']['points'],
    );
  }
}
