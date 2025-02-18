import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/features/authentication/view/widgets/custom_text.dart';
import 'package:todo_list_app/features/home/model/category_model.dart';
import 'package:todo_list_app/features/home/view/settings.dart';
import 'package:todo_list_app/features/home/view/task.dart';
import 'package:todo_list_app/features/home/viewmodel/category_provider.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({required this.userId, Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        
        title: CustomText(text: 'Categories',size: 24,color: Colors.black,),centerTitle: true,

        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Settingsss(),));
            },
            child: CircleAvatar(child: Icon(Icons.person),)),
        ),
        
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(
                  '"The memories is a shield and life helper."',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                subtitle: Text('Tamim Al-Barghouti'),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: categoryProvider.getCategories(widget.userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var categories = snapshot.data!.docs;

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildAddButton();
                    }

                    var category = Category.fromMap(
                      categories[index - 1].data() as Map<String, dynamic>,
                    );

                    return _buildCategoryCard(category);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Card(
      child: InkWell(
        onTap: () => _showAddCategoryDialog(),
        child: Center(
          child: Icon(
            Icons.add,
            size: 40,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
  return Card(
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailScreen(
              categoryId: category.id,
              categoryTitle: category.title,
              userId: widget.userId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              category.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${category.tasks} tasks',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Category'),
        content: TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: 'Category Title',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _titleController.clear();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.trim().isNotEmpty) {
                final categoryProvider = Provider.of<CategoryProvider>(
                  context,
                  listen: false,
                );
                categoryProvider.addCategory(
                  _titleController.text.trim(),
                  widget.userId, // Pass userId
                );
              }
              Navigator.pop(context);
              _titleController.clear();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}