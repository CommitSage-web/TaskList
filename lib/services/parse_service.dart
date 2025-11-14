import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ParseService {
  static Future<void> initializeParse() async {
    const appId = 'CwSBbdU01wKjMU9f5QwAY7ZeIoykY1a75yV0oeJe';
    const clientKey = '6eiH0fFudofqDVxIFysbMt1Pqd1HGHWYMvrrWx02';
    const serverUrl = 'https://parseapi.back4app.com';

    await Parse().initialize(
      appId,
      serverUrl,
      clientKey: clientKey,
      autoSendSessionId: true,
      debug: true,
    );
  }

  // 🔹 Sign Up (validate student email)
  static Future<ParseResponse> signUp(String email, String password) async {
    // final emailPattern = RegExp(r'^[0-9]{4}[a-z]{2}[0-9]{5}@wilp\.bits-pilani\.ac\.in$');
    // if (!emailPattern.hasMatch(email)) {
    //   final error = ParseError(code: 400, message: 'Use student email only.');
    //   return ParseResponse()..error = error;
    // }

    final user = ParseUser(email, password, email);
    return await user.signUp();
  }

  static Future<ParseUser?> login(String email, String password) async {
    final user = ParseUser(email, password, email);
    final response = await user.login();
    return response.success ? user : null;
  }

  static Future<ParseUser?> currentUser() async =>
      await ParseUser.currentUser() as ParseUser?;

  static Future<void> logout() async {
    final user = await currentUser();
    if (user != null) await user.logout();
  }

  // 🔹 CRUD
  static Future<ParseResponse> createTask(String title, String desc) async {
  // Get the currently logged-in user
  final user = await ParseUser.currentUser() as ParseUser?;

  // Create a new Task object with user reference
  final task = ParseObject('Task')
    ..set('title', title)
    ..set('description', desc)
    ..set('user', user)
    ..setACL(ParseACL(owner: user));
  // Save the object to Back4App
  return await task.save();
}


  static Future<List<ParseObject>> getTasks() async {
    final user = await ParseUser.currentUser() as ParseUser?;

    if (user == null) {
      print("❌ No logged-in user. Cannot fetch tasks.");
      return [];
    }

    final query = QueryBuilder<ParseObject>(ParseObject('Task'))
      ..whereEqualTo('user', user)
      ..orderByDescending('createdAt');

    final response = await query.query();

    if (response.success && response.results != null) {
      return response.results!.cast<ParseObject>();
    } else {
      print('❌ Error fetching tasks: ${response.error?.message}');
      return [];
    }
  }


  static Future<void> updateTask(String id, String title, String desc) async {
    final task = ParseObject('Task')..objectId = id;
    task
      ..set('title', title)
      ..set('description', desc);
    await task.save();
  }

  static Future<void> deleteTask(String id) async {
    final task = ParseObject('Task')..objectId = id;
    await task.delete();
  }
}