import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_app/features/home/model/category_model.dart';
import 'package:uuid/uuid.dart';

class CategoryProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> addCategory(String title, String userId) async {
    if (title.trim().isEmpty) return;

    final categoryId = Uuid().v4();
    final category = Category(
      id: categoryId,
      title: title.trim(),
      tasks: 0,
      
    );

    await _firestore.collection('categories').doc(categoryId).set({
      ...category.toMap(),
      'userId': userId, // Add userId to the category
    });

    notifyListeners();
  }

  Future<void> addTask(String categoryId, String taskTitle, String userId) async {
    final taskId = Uuid().v4();
    
    // Add task to tasks collection
    await _firestore.collection('categories').doc(categoryId)
        .collection('tasks').doc(taskId).set({
      'id': taskId,
      'title': taskTitle,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': userId
    });

    // Update task count in category
    await _firestore.collection('categories').doc(categoryId)
        .update({
      'tasks': FieldValue.increment(1),
    });
    
    notifyListeners();
  }

  Stream<QuerySnapshot> getCategories(String userId) {
    return _firestore
        .collection('categories')
        .where('userId', isEqualTo: userId) // Get categories by userId
        .snapshots();
  }

  Stream<QuerySnapshot> getTasks(String categoryId, String userId) {
    return _firestore
        .collection('categories')
        .doc(categoryId)
        .collection('tasks')
        .snapshots();
  }


}