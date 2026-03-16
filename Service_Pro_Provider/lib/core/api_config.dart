class ApiConfig {
  static const String baseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8000');

  static String normalizeMediaUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) return '';

    final url = rawUrl.trim();
    final apiUri = Uri.tryParse(baseUrl);
    final sourceUri = Uri.tryParse(url);

    if (sourceUri == null || apiUri == null || !sourceUri.hasAuthority) {
      return url;
    }

    if (sourceUri.host == 'localhost' || sourceUri.host == '127.0.0.1') {
      return sourceUri
          .replace(
            scheme: apiUri.scheme,
            host: apiUri.host,
            port: apiUri.hasPort ? apiUri.port : sourceUri.port,
          )
          .toString();
    }

    return url;
  }
}
