class TokenManager {
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static void clearToken() {
    _token = null;
  }

  static String? getToken() {
    if (_token != null) {
      return _token;
    } else {
      return '';
    }
  }

  static Map<String, String> getHeaders() {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }
}
