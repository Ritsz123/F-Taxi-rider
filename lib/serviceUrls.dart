library service_url;

const String domain = 'http://192.168.1.103:5001/api';

const String registerUser = '$domain/auth/rider/register';
const String loginUser = '$domain/auth/rider/login';
const String getUserData = '$domain/auth/getUserProfile';

const String getDriverFcmToken = '$domain/auth/fcmtoken';

const String getPlaceSearchSuggestion = '$domain/google/searchplace';
const String getPlaceDetails = '$domain/google/placeDetails';
const String getLatLngDetails = '$domain/google/latlngdetails';
const String getRouteDetails = '$domain/google/routedetails';