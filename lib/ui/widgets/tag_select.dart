import 'package:flutter/widgets.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:notes_demo/model/tag.dart';
import 'package:notes_demo/service/db_service.dart';

class TagSelect extends StatelessWidget {
  List<Tag> _selectedtags = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot<List<Tag>> snapshot) {
          return MultiSelectDialogField(
            items: snapshot.data
                    ?.map((e) => MultiSelectItem(e, e.name))
                    .toList() ??
                [],
            listType: MultiSelectListType.CHIP,
            
            onConfirm: (values) {
              _selectedtags = values;
            },
          );
        },
        stream: tagsDb.streamList(),
      ),
    );
  }
}
