abstract class IHttpClient {
  Future<Object> get(String url);
  Future<Object> post(String url, [parameters]);
  Future<Object> put(String url, [parameters]);
  void setToken(String token);
}
