import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ParseService {
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
      debug: false,
    );
  }

  // Sign Up
  static Future<ParseResponse> signUp(String email, String password) async {
    final user = ParseUser(email, password, email);
    final response = await user.signUp();
    if (response.success) _cachedUser = user;
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

  // Current User
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

  // Update Profile
  static Future<ParseResponse> updateProfile(String displayName) async {
    final user = await currentUser();
    if (user == null) {
      return ParseResponse()
        ..error = ParseError(code: 401, message: 'No user logged in');
    }
    user.set('displayName', displayName);
    final response = await user.save();
    if (response.success) _cachedUser = user;
    return response;
  }

  // ===== NEW ENHANCED FEATURES =====

  // Create Task with Priority & Category
  static Future<ParseResponse> createTask(
    String title,
    String desc, {
    String priority = 'medium',
    String category = 'General',
    DateTime? dueDate,
  }) async {
    final user = await currentUser();
    if (user == null) {
      return ParseResponse()
        ..error = ParseError(code: 401, message: 'No user logged in');
    }

    final task = ParseObject('Task')
      ..set('title', title)
      ..set('description', desc)
      ..set('priority', priority)
      ..set('category', category)
      ..set('isCompleted', false)
      ..set('user', user)
      ..setACL(ParseACL(owner: user));

    if (dueDate != null) {
      task.set('dueDate', dueDate);
    }

    return await task.save();
  }

  // Get Tasks with Filter Options
  static Future<List<ParseObject>> getTasks({
    String? filterPriority,
    String? filterCategory,
    bool? filterCompleted,
    String sortBy = 'createdAt',
  }) async {
    final user = await currentUser();
    if (user == null) return [];

    try {
      final query = QueryBuilder<ParseObject>(ParseObject('Task'))
        ..whereEqualTo('user', user)
        ..setLimit(100);

      // Apply filters
      if (filterPriority != null) {
        query.whereEqualTo('priority', filterPriority);
      }
      if (filterCategory != null) {
        query.whereEqualTo('category', filterCategory);
      }
      if (filterCompleted != null) {
        query.whereEqualTo('isCompleted', filterCompleted);
      }

      // Apply sorting
      if (sortBy == 'dueDate') {
        query.orderByAscending('dueDate');
      } else if (sortBy == 'priority') {
        query.orderByDescending('priority');
      } else {
        query.orderByDescending('createdAt');
      }

      final response = await query.query();
      if (response.success && response.results != null) {
        return response.results!.cast<ParseObject>();
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    }
    return [];
  }

  // Search Tasks
  static Future<List<ParseObject>> searchTasks(String query) async {
    final user = await currentUser();
    if (user == null) return [];

    try {
      final queryBuilder = QueryBuilder<ParseObject>(ParseObject('Task'))
        ..whereEqualTo('user', user)
        ..whereContains('title', query, caseSensitive: false)
        ..orderByDescending('createdAt');

      final response = await queryBuilder.query();
      return response.success && response.results != null
          ? response.results!.cast<ParseObject>()
          : [];
    } catch (e) {
      print('Error searching tasks: $e');
      return [];
    }
  }

  // Toggle Task Completion
  static Future<ParseResponse> toggleTaskCompletion(
      String id, bool currentStatus) async {
    final task = ParseObject('Task')..objectId = id;
    task.set('isCompleted', !currentStatus);
    return await task.save();
  }

  // Update Task with all fields
  static Future<ParseResponse> updateTask(
    String id,
    String title,
    String desc, {
    String? priority,
    String? category,
    DateTime? dueDate,
  }) async {
    final task = ParseObject('Task')..objectId = id;
    task
      ..set('title', title)
      ..set('description', desc);

    if (priority != null) task.set('priority', priority);
    if (category != null) task.set('category', category);
    if (dueDate != null) task.set('dueDate', dueDate);

    return await task.save();
  }

  // Delete Task
  static Future<ParseResponse> deleteTask(String id) async {
    final task = ParseObject('Task')..objectId = id;
    return await task.delete();
  }

  // Get Task Statistics
  static Future<Map<String, dynamic>> getTaskStats() async {
    final tasks = await getTasks();

    int total = tasks.length;
    int completed = tasks.where((t) => t.get<bool>('isCompleted') ?? false).length;
    int pending = total - completed;

    // Count by priority
    Map<String, int> byPriority = {
      'high': 0,
      'medium': 0,
      'low': 0,
    };
    for (var task in tasks) {
      String priority = task.get<String>('priority') ?? 'medium';
      byPriority[priority] = (byPriority[priority] ?? 0) + 1;
    }

    // Count by category
    Map<String, int> byCategory = {};
    for (var task in tasks) {
      String category = task.get<String>('category') ?? 'General';
      byCategory[category] = (byCategory[category] ?? 0) + 1;
    }

    // Count overdue tasks
    int overdue = 0;
    for (var task in tasks) {
      final dueDate = task.get<DateTime>('dueDate');
      final isCompleted = task.get<bool>('isCompleted') ?? false;
      if (dueDate != null && !isCompleted && dueDate.isBefore(DateTime.now())) {
        overdue++;
      }
    }

    return {
      'total': total,
      'completed': completed,
      'pending': pending,
      'overdue': overdue,
      'byPriority': byPriority,
      'byCategory': byCategory,
      'completionRate': total > 0 ? (completed / total * 100).toStringAsFixed(1) : '0',
    };
  }

  // Get All Categories
  static Future<List<String>> getCategories() async {
    final tasks = await getTasks();
    Set<String> categories = {};
    for (var task in tasks) {
      String category = task.get<String>('category') ?? 'General';
      categories.add(category);
    }
    return categories.toList()..sort();
  }

  static void clearCache() {
    _cachedUser = null;
  }
}