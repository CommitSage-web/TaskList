import 'package:flutter/material.dart';
import '../services/parse_service.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ParseUser? _user;
  final _name = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    final u = await ParseService.currentUser();
    setState(() {
      _user = u;
      _name.text = u?.get<String>('displayName') ?? '';
      _loading = false;
    });
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    final res = await ParseService.updateProfile(_name.text.trim());
    setState(() => _loading = false);
    if (res.success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${res.error?.message ?? 'Failed'}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                CircleAvatar(radius: 36, child: Text((_user?.username ?? '?').substring(0, 1).toUpperCase())),
                const SizedBox(height: 12),
                Text(_user?.username ?? ''),
                const SizedBox(height: 12),
                TextField(controller: _name, decoration: const InputDecoration(labelText: 'Display name')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: ElevatedButton(onPressed: _save, child: const Text('Save'))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
