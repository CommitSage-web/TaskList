import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ParseService {
  // Cache for current user to reduce API calls
  static ParseUser? _cachedUser;

  static Future<void> initializeParse() async {
    const appId = 'CwSBbdU01wKjMU9f5QwAY7ZeIoykY1a75yV0oeJe';
    const clientKey = '6eiH0fFudofqDVxIFysbMt1Pqd1HGHWYMvrrWx02';
    const serverUrl = 'https://parseapi.back4app.com';

    await Parse().initialize(
      appId,
      serverUrl,
      clientKey: clientKey,
      autoSendSessionId: true,
      debug: false, // Set to false in production
    );
  }

  // Sign Up with optional email validation
  static Future<ParseResponse> signUp(String email, String password) async {
    // Uncomment to enforce student email validation
    // final emailPattern = RegExp(r'^[0-9]{4}[a-z]{2}[0-9]{5}@wilp\.bits-pilani\.ac\.in$');
    // if (!emailPattern.hasMatch(email)) {
    //   return ParseResponse()
    //     ..error = ParseError(code: 400, message: 'Use student email only.');
    // }

    final user = ParseUser(email, password, email);
    final response = await user.signUp();

    if (response.success) {
      _cachedUser = user;
    }

    return response;
  }

  // Login
  static Future<ParseUser?> login(String email, String password) async {
    final user = ParseUser(email, password, email);
    final response = await user.login();

    if (response.success) {
      _cachedUser = user;
      return user;
    }

    return null;
  }

  // Get current user with caching
  static Future<ParseUser?> currentUser() async {
    if (_cachedUser != null) return _cachedUser;

    _cachedUser = await ParseUser.currentUser() as ParseUser?;
    return _cachedUser;
  }

  // Logout
  static Future<void> logout() async {
    final user = await currentUser();
    if (user != null) {
      await user.logout();
      _cachedUser = null;
    }
  }

  // Update user profile
  static Future<ParseResponse> updateProfile(String displayName) async {
    final user = await currentUser();
    if (user == null) {
      return ParseResponse()
        ..error = ParseError(code: 401, message: 'No user logged in');
    }

    user.set('displayName', displayName);
    final response = await user.save();

    if (response.success) {
      _cachedUser = user;
    }

    return response;
  }

  // Create Task
  static Future<ParseResponse> createTask(String title, String desc) async {
    final user = await currentUser();

    if (user == null) {
      return ParseResponse()
        ..error = ParseError(code: 401, message: 'No user logged in');
    }

    final task = ParseObject('Task')
      ..set('title', title)
      ..set('description', desc)
      ..set('user', user)
      ..setACL(ParseACL(owner: user));

    return await task.save();
  }

  // Get Tasks (optimized with single query)
  static Future<List<ParseObject>> getTasks() async {
    final user = await currentUser();

    if (user == null) {
      return [];
    }

    try {
      final query = QueryBuilder<ParseObject>(ParseObject('Task'))
        ..whereEqualTo('user', user)
        ..orderByDescending('createdAt')
        ..setLimit(100); // Add limit to prevent loading too many tasks

      final response = await query.query();

      if (response.success && response.results != null) {
        return response.results!.cast<ParseObject>();
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    }

    return [];
  }

  // Update Task
  static Future<ParseResponse> updateTask(
    String id,
    String title,
    String desc,
  ) async {
    final task = ParseObject('Task')..objectId = id;
    task
      ..set('title', title)
      ..set('description', desc);

    return await task.save();
  }

  // Delete Task
  static Future<ParseResponse> deleteTask(String id) async {
    final task = ParseObject('Task')..objectId = id;
    return await task.delete();
  }

  // Clear cache (useful when switching users)
  static void clearCache() {
    _cachedUser = null;
  }
}