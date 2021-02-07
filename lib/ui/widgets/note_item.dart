import 'package:flutter/material.dart';
import 'package:notes_demo/model/note.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes_demo/model/tag.dart';
import 'package:notes_demo/service/db_service.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final Function(Note) onEdit;
  final Function(Note) onDelete;
  final Function(Note) onTap;

  const NoteItem({
    Key key,
    @required this.note,
    @required this.onEdit,
    @required this.onDelete,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: tagsDb.streamList(),
      builder: (BuildContext context, AsyncSnapshot<List<Tag>> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text(snapshot.error.toString()),
          );
        if (!snapshot.hasData) return CircularProgressIndicator();
        return Container(
          margin: EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(color: Colors.white),
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: ListTile(
              onTap: () => onTap(note),
              title: Text(note.title),
              subtitle: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var tag = snapshot.data
                      .firstWhere((element) => element.id == note.tags[index]);
                  return Text(tag.name);
                },
                itemCount: note.tags.length,
              ),
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Düzenle',
                color: Colors.black45,
                icon: Icons.edit,
                onTap: () => onEdit(note),
              ),
              IconSlideAction(
                caption: 'Sil',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => onDelete(note),
              ),
            ],
          ),
        );
      },
    );
  }
}
