class AppConfig {
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.skillsocket.dev/api', // Fallback URL
  );

  static const String _socketUrl = String.fromEnvironment(
    'SOCKET_BASE_URL',
    defaultValue: 'https://api.skillsocket.dev/',
  );

  // API endpoints
  static String get baseUrl => _baseUrl;
  static String get socketUrl => _socketUrl;

  // Full endpoint URLs
  static String get apiUrl => '$_baseUrl';
  static String get authUrl => '$_baseUrl/auth';
  static String get userUrl => '$_baseUrl/user';
  static String get chatUrl => '$_baseUrl/chat';
  static String get reviewsUrl => '$_baseUrl/reviews';
  static String get connectionsUrl => '$_baseUrl/connections';
  static String get notificationsUrl => '$_baseUrl/notifications';
  static String get todosUrl => '$_baseUrl/todos';
  static String get eventsUrl => '$_baseUrl/events';
  static String get postsUrl => '$_baseUrl/posts';

  // Environment detection
  static bool get isProduction =>
      _baseUrl.contains('skillsocket-backend.onrender.com');
  static bool get isDevelopment =>
      _baseUrl.contains('localhost') || _baseUrl.contains('127.0.0.1');

  // Debug info
  static Map<String, dynamic> get debugInfo => {
        'baseUrl': _baseUrl,
        'socketUrl': _socketUrl,
        'isProduction': isProduction,
        'isDevelopment': isDevelopment,
      };
}
