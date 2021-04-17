abstract class AuthLocalDataSource {
  Future<String> getUserAccessToken();
  Future<void> cacheUserAccessToken(String accessToken);
  Future<void> unCacheUserAccessToken();
}
