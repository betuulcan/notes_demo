import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes_demo/model/tag.dart';

class TagItem extends StatelessWidget {
  final Tag tag;
  final Function(Tag) onEdit;
  final Function(Tag) onDelete;
  final Function(Tag) onTap;

  const TagItem({
    Key key,
    @required this.tag,
    @required this.onEdit,
    @required this.onDelete,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(color: Colors.white),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: ListTile(
          onTap: () => onTap(tag),
          title: Text(tag.name),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Düzenle',
            color: Colors.black45,
            icon: Icons.edit,
            onTap: () => onEdit(tag),
          ),
          IconSlideAction(
            caption: 'Sil',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => onDelete(tag),
          ),
        ],
      ),
    );
  }
}
