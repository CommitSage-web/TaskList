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
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String _selectedPriority = 'medium';
  DateTime? _selectedDueDate;

  final List<String> _priorities = ['low', 'medium', 'high'];
  final List<String> _defaultCategories = [
    'General',
    'Work',
    'Personal',
    'Shopping',
    'Health',
    'Finance',
    'Education',
    'Home',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.get<String>('title') ?? '';
      _descController.text = widget.task!.get<String>('description') ?? '';
      _selectedPriority = widget.task!.get<String>('priority') ?? 'medium';
      _categoryController.text = widget.task!.get<String>('category') ?? 'General';
      _selectedDueDate = widget.task!.get<DateTime>('dueDate');
    } else {
      _categoryController.text = 'General';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDueDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      if (widget.task == null) {
        // Create new task
        final response = await ParseService.createTask(
          _titleController.text.trim(),
          _descController.text.trim(),
          priority: _selectedPriority,
          category: _categoryController.text.trim(),
          dueDate: _selectedDueDate,
        );

        if (!mounted) return;

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Task created successfully'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${response.error?.message ?? 'Failed to create task'}'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        // Update existing task
        final response = await ParseService.updateTask(
          widget.task!.objectId!,
          _titleController.text.trim(),
          _descController.text.trim(),
          priority: _selectedPriority,
          category: _categoryController.text.trim(),
          dueDate: _selectedDueDate,
        );

        if (!mounted) return;

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Task updated successfully'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${response.error?.message ?? 'Failed to update task'}'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  isEditing ? Icons.edit_outlined : Icons.add_task,
                  size: 64,
                  color: theme.colorScheme.primary.withOpacity(0.7),
                ),
                const SizedBox(height: 32),

                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    prefixIcon: Icon(Icons.title),
                    hintText: 'Enter task title',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Description Field
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description_outlined),
                    hintText: 'Enter task description',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Priority Selector
                Text('Priority', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: _priorities.map((priority) {
                    return ButtonSegment<String>(
                      value: priority,
                      label: Text(priority[0].toUpperCase() + priority.substring(1)),
                      icon: Icon(
                        Icons.flag,
                        color: _getPriorityColor(priority),
                      ),
                    );
                  }).toList(),
                  selected: {_selectedPriority},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedPriority = newSelection.first;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Category Field with Autocomplete
                Autocomplete<String>(
                  initialValue: TextEditingValue(text: _categoryController.text),
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return _defaultCategories;
                    }
                    return _defaultCategories.where((String option) {
                      return option.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      );
                    });
                  },
                  onSelected: (String selection) {
                    _categoryController.text = selection;
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    controller.text = _categoryController.text;
                    controller.selection = TextSelection.collapsed(
                      offset: controller.text.length,
                    );
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.label_outline),
                        hintText: 'Select or create category',
                      ),
                      onChanged: (value) {
                        _categoryController.text = value;
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a category';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Due Date Selector
                InkWell(
                  onTap: _selectDueDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Due Date (Optional)',
                      prefixIcon: Icon(Icons.calendar_today),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    child: Text(
                      _selectedDueDate != null
                          ? '${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}'
                          : 'Select due date',
                      style: _selectedDueDate != null
                          ? null
                          : TextStyle(color: theme.hintColor),
                    ),
                  ),
                ),

                if (_selectedDueDate != null) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _selectedDueDate = null);
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear due date'),
                  ),
                ],

                const SizedBox(height: 32),

                // Save Button
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : FilledButton.icon(
                        onPressed: _save,
                        icon: Icon(isEditing ? Icons.save : Icons.add),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            isEditing ? 'Update Task' : 'Create Task',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}