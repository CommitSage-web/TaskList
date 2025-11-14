import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../services/parse_service.dart';
import 'task_form_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ParseObject> tasks = [];
  bool loading = true;
  String? filterPriority;
  String? filterCategory;
  bool? filterCompleted;
  String searchQuery = '';
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => loading = true);

    if (searchQuery.isNotEmpty) {
      tasks = await ParseService.searchTasks(searchQuery);
    } else {
      tasks = await ParseService.getTasks(
        filterPriority: filterPriority,
        filterCategory: filterCategory,
        filterCompleted: filterCompleted,
      );
    }

    setState(() => loading = false);
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ParseService.logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  Future<void> _deleteTask(ParseObject task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ParseService.deleteTask(task.objectId!);
      _loadTasks();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task deleted successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _toggleCompletion(ParseObject task) async {
    final currentStatus = task.get<bool>('isCompleted') ?? false;
    await ParseService.toggleTaskCompletion(task.objectId!, currentStatus);
    _loadTasks();
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Tasks',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),

              // Priority Filter
              Text('Priority', style: Theme.of(context).textTheme.titleSmall),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: filterPriority == null,
                    onSelected: (selected) {
                      setModalState(() => filterPriority = null);
                      setState(() => filterPriority = null);
                      _loadTasks();
                    },
                  ),
                  FilterChip(
                    label: const Text('High'),
                    selected: filterPriority == 'high',
                    onSelected: (selected) {
                      setModalState(() => filterPriority = 'high');
                      setState(() => filterPriority = 'high');
                      _loadTasks();
                    },
                  ),
                  FilterChip(
                    label: const Text('Medium'),
                    selected: filterPriority == 'medium',
                    onSelected: (selected) {
                      setModalState(() => filterPriority = 'medium');
                      setState(() => filterPriority = 'medium');
                      _loadTasks();
                    },
                  ),
                  FilterChip(
                    label: const Text('Low'),
                    selected: filterPriority == 'low',
                    onSelected: (selected) {
                      setModalState(() => filterPriority = 'low');
                      setState(() => filterPriority = 'low');
                      _loadTasks();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Completion Filter
              Text('Status', style: Theme.of(context).textTheme.titleSmall),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: filterCompleted == null,
                    onSelected: (selected) {
                      setModalState(() => filterCompleted = null);
                      setState(() => filterCompleted = null);
                      _loadTasks();
                    },
                  ),
                  FilterChip(
                    label: const Text('Completed'),
                    selected: filterCompleted == true,
                    onSelected: (selected) {
                      setModalState(() => filterCompleted = true);
                      setState(() => filterCompleted = true);
                      _loadTasks();
                    },
                  ),
                  FilterChip(
                    label: const Text('Pending'),
                    selected: filterCompleted == false,
                    onSelected: (selected) {
                      setModalState(() => filterCompleted = false);
                      setState(() => filterCompleted = false);
                      _loadTasks();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      filterPriority = null;
                      filterCategory = null;
                      filterCompleted = null;
                    });
                    _loadTasks();
                    Navigator.pop(context);
                  },
                  child: const Text('Clear All Filters'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search tasks...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  searchQuery = value;
                  _loadTasks();
                },
              )
            : const Text('My Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        elevation: 0,
        actions: [
          if (isSearching)
            IconButton(
              onPressed: () {
                setState(() {
                  isSearching = false;
                  searchQuery = '';
                });
                _loadTasks();
              },
              icon: const Icon(Icons.close),
            )
          else ...[
            IconButton(
              onPressed: () {
                setState(() => isSearching = true);
              },
              icon: const Icon(Icons.search),
              tooltip: 'Search',
            ),
            IconButton(
              onPressed: _showFilterDialog,
              icon: Badge(
                isLabelVisible: filterPriority != null || filterCompleted != null,
                child: const Icon(Icons.filter_list),
              ),
              tooltip: 'Filter',
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StatsScreen()),
                );
              },
              icon: const Icon(Icons.analytics_outlined),
              tooltip: 'Statistics',
            ),
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              icon: const Icon(Icons.account_circle_outlined),
              tooltip: 'Profile',
            ),
            IconButton(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
            ),
          ],
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTasks,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : tasks.isEmpty
                ? _buildEmptyState()
                : _buildTaskList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskFormScreen()),
          );
          if (result == true) _loadTasks();
        },
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 120,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            searchQuery.isNotEmpty ? 'No tasks found' : 'No tasks yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isNotEmpty
                ? 'Try a different search term'
                : 'Tap the + button to create your first task',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _TaskCard(
          task: task,
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TaskFormScreen(task: task),
              ),
            );
            if (result == true) _loadTasks();
          },
          onDelete: () => _deleteTask(task),
          onToggleComplete: () => _toggleCompletion(task),
        );
      },
    );
  }
}

class _TaskCard extends StatelessWidget {
  final ParseObject task;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;

  const _TaskCard({
    required this.task,
    required this.onTap,
    required this.onDelete,
    required this.onToggleComplete,
  });

  Color _getPriorityColor(String priority, BuildContext context) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = task.get<String>('title') ?? '';
    final description = task.get<String>('description') ?? '';
    final priority = task.get<String>('priority') ?? 'medium';
    final category = task.get<String>('category') ?? 'General';
    final isCompleted = task.get<bool>('isCompleted') ?? false;
    final dueDate = task.get<DateTime>('dueDate');

    final isOverdue = dueDate != null &&
                      !isCompleted &&
                      dueDate.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Checkbox
              Checkbox(
                value: isCompleted,
                onChanged: (_) => onToggleComplete(),
                shape: const CircleBorder(),
              ),

              // Priority indicator
              Container(
                width: 4,
                height: 48,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: _getPriorityColor(priority, context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                              color: isCompleted
                                  ? theme.colorScheme.onSurface.withOpacity(0.5)
                                  : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(priority, context).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            priority.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getPriorityColor(priority, context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.label_outline, size: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.5)),
                        const SizedBox(width: 4),
                        Text(
                          category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                        if (dueDate != null) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: isOverdue ? Colors.red : theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${dueDate.day}/${dueDate.month}/${dueDate.year}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isOverdue ? Colors.red : theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              IconButton(
                icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                onPressed: onDelete,
                tooltip: 'Delete task',
              ),
            ],
          ),
        ),
      ),
    );
  }
}