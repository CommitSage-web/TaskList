import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../services/parse_service.dart';
import 'task_form_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ParseObject> tasks = [];
  bool loading = true;

  Future<void> _loadTasks() async {
    setState(() => loading = true);
    tasks = await ParseService.getTasks();
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _logout() async {
    await ParseService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? const Center(child: Text('No tasks yet'))
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      title: Text(task.get<String>('title') ?? ''),
                      subtitle: Text(task.get<String>('description') ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await ParseService.deleteTask(task.objectId!);
                          _loadTasks();
                        },
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskFormScreen(task: task),
                          ),
                        );
                        _loadTasks();
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
  onPressed: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TaskFormScreen()),
    );

    if (result == true) {
      _loadTasks(); // 👈 This reloads your list when you come back
    }
  },
  child: const Icon(Icons.add),

      ),
    );
  }
}
