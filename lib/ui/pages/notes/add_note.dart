import 'package:flutter/material.dart';
import 'package:notes_demo/model/note.dart';
import 'package:notes_demo/model/tag.dart';
import 'package:notes_demo/model/user_repository.dart';
import 'package:notes_demo/service/db_service.dart';
import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddNotePage extends StatefulWidget {
  final Note note;

  const AddNotePage({Key key, this.note}) : super(key: key);

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  FocusNode _descriptionNode;
  bool _editMode;
  bool _processing;
  List<dynamic> _selectedtags;

  @override
  void initState() {
    super.initState();
    _processing = false;
    _editMode = widget.note != null;
    _titleController =
        TextEditingController(text: _editMode ? widget.note.title : null);
    _descriptionController =
        TextEditingController(text: _editMode ? widget.note.description : null);
    _descriptionNode = FocusNode();
    _selectedtags = [];
    // categoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Not Ekle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
              ),
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_descriptionNode);
              },
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _descriptionController,
              focusNode: _descriptionNode,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Description",
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              child: StreamBuilder(
                builder:
                    (BuildContext context, AsyncSnapshot<List<Tag>> snapshot) {
                  if (snapshot.hasError)
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  var selected = [];
                  if (_editMode) {
                    selected = snapshot.data
                        .where((element) => widget.note.tags
                            .any((element2) => element2 == element.id))
                        .toList();
                  } else {
                    selected = snapshot.data;
                  }

                  return MultiSelectDialogField(
                    initialValue: selected,
                    items: snapshot.data
                            .map((e) => MultiSelectItem(e, e.name))
                            .toList() ??
                        [],
                    onConfirm: (values) {
                      _selectedtags = values;
                    },
                  );
                },
                stream: tagsDb.streamList(),
              ),
            ),
            const SizedBox(height: 10.0),
            RaisedButton(
              child: _processing ? CircularProgressIndicator() : Text("Kaydet"),
              onPressed: _processing
                  ? null
                  : () async {
                      setState(() {
                        _processing = true;
                      });
                      if (_titleController.text.isEmpty) {
                        _key.currentState.showSnackBar(SnackBar(
                          content: Text("Title alanı boş."),
                        ));
                        return;
                      }
                      Note note = Note(
                        id: _editMode ? widget.note.id : null,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        createdAt: DateTime.now(),
                        userId:
                            Provider.of<UserRepository>(context, listen: false)
                                .user
                                .uid,
                        tags: _selectedtags.map<String>((e) => e.id).toList(),
                      );
                      if (_editMode) {
                        await notesDb.updateItem(note);
                      } else {
                        await notesDb.createItem(note);
                      }
                      setState(() {
                        _processing = false;
                      });
                      Navigator.pop(context);
                    },
            )
          ],
        ),
      ),
    );
  }
}
