import 'package:notes_demo/model/database_item.dart';

class Tag extends DatabaseItem {
  final String name;
  final String id;
  final DateTime createdAt;
  final String userId;

  Tag({this.name, this.id, this.createdAt, this.userId}) : super(id);

  Tag.fromDS(String id, Map<String, dynamic> data)
      : id = id,
        name = data['name'],
        userId = data['user_id'],
        createdAt = data['created_at']?.toDate(),
        super(id);

  Map<String, dynamic> toMap() => {
        "name": name,
        "created_at": createdAt,
        "user_id": userId,
      };


      
}
