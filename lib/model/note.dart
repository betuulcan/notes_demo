import 'package:notes_demo/model/database_item.dart';

class Note extends DatabaseItem {
  final String title;
  final String id;
  final String description;
  final DateTime createdAt;
  final String userId;
  final List<String> tags;

  Note(
      {this.title,
      this.id,
      this.description,
      this.createdAt,
      this.userId,
      this.tags})
      : super(id);

  Note.fromDS(String id, Map<String, dynamic> data)
      : id = id,
        title = data['title'],
        description = data['description'],
        userId = data['user_id'],
        createdAt = data['created_at']?.toDate(),
        tags = data['tags'].cast<String>(),
        super(id);

  Map<String, dynamic> toMap() => {
        "title": title,
        "description": description,
        "created_at": createdAt,
        "user_id": userId,
        "tags": tags,
      };
}
