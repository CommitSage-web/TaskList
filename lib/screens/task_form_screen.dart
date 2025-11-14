import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../services/parse_service.dart';

class TaskFormScreen extends StatefulWidget {
  final ParseObject? task;
  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title.text = widget.task!.get<String>('title') ?? '';
      _desc.text = widget.task!.get<String>('description') ?? '';
    }
  }

  Future<void> _save() async {
  setState(() => _loading = true);

  if (widget.task == null) {
    final response = await ParseService.createTask(
      _title.text,
      _desc.text,
    );

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task added successfully')),
      );
      Navigator.pop(context, true); // go back and trigger refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.error?.message ?? 'Failed to save task'}')),
      );
    }
  } else {
    await ParseService.updateTask(widget.task!.objectId!, _title.text, _desc.text);
    Navigator.pop(context, true);
  }

  setState(() => _loading = false);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Add Task' : 'Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _save, child: const Text('Save Task')),
          ],
        ),
      ),
    );
  }
}
