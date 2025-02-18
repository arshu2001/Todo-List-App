class Category {
  String id;
  String title;
  int tasks;
  

  Category({
    required this.id,
    required this.title,
    this.tasks = 0,
    
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'tasks': tasks
      
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      title: map['title'],
      tasks: map['tasks'],
      
    );
  }
}