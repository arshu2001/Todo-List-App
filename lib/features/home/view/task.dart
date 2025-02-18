import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_app/features/authentication/view/widgets/custom_text.dart';
import 'package:todo_list_app/features/home/viewmodel/category_provider.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;
  final String userId;

  const CategoryDetailScreen({
    Key? key,
    required this.categoryId,
    required this.categoryTitle,
    required this.userId,
  }) : super(key: key);

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final TextEditingController _taskController = TextEditingController();

  String _getDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) {
      return 'Today';
    } else if (taskDate == tomorrow) {
      return 'Tomorrow';
    } else {
      return DateFormat('EEE, MMM dd, yyyy').format(date);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: widget.categoryTitle,
          size: 24,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: categoryProvider.getTasks(widget.categoryId, widget.userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var tasks = snapshot.data!.docs;

          if (tasks.isEmpty) {
            return Center(
              child: Text(
                'No tasks yet. Add your first task!',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            );
          }

          // Group tasks by date
          Map<String, List<QueryDocumentSnapshot>> groupedTasks = {};
          
          for (var task in tasks) {
            final data = task.data() as Map<String, dynamic>;
            final timestamp = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
            final dateStr = _getDateHeader(timestamp);
            
            if (!groupedTasks.containsKey(dateStr)) {
              groupedTasks[dateStr] = [];
            }
            groupedTasks[dateStr]!.add(task);
          }

          // Sort dates
          final sortedDates = groupedTasks.keys.toList()..sort((a, b) {
            if (a == 'Today') return -1;
            if (b == 'Today') return 1;
            if (a == 'Tomorrow') return -1;
            if (b == 'Tomorrow') return 1;
            return a.compareTo(b);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final dateStr = sortedDates[index];
              final dateTasks = groupedTasks[dateStr]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      dateStr,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ...dateTasks.map((task) {
                    final data = task.data() as Map<String, dynamic>;
                    return Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(data['title']),
                        leading: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task'),
        content: TextField(
          controller: _taskController,
          decoration: const InputDecoration(
            hintText: 'Task Title',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _taskController.clear();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_taskController.text.trim().isNotEmpty) {
                final categoryProvider = Provider.of<CategoryProvider>(
                  context,
                  listen: false,
                );
                categoryProvider.addTask(
                  widget.categoryId,
                  _taskController.text.trim(),
                  widget.userId,
                );
              }
              Navigator.pop(context);
              _taskController.clear();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}