library service_url;

const String domain = 'http://192.168.1.102:5001';

const String registerUser = '$domain/api/auth/rider/register';
const String loginUser = '$domain/api/auth/rider/login';
const String getUserData = '$domain/api/auth/getUserProfile';

const String getPlaceSearchSuggestion = '$domain/api/google/searchplace';
const String getPlaceDetails = '$domain/api/google/placeDetails';