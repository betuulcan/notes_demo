import 'package:flutter/material.dart';
import 'package:notes_demo/model/tag.dart';
import 'package:notes_demo/model/user_repository.dart';
import 'package:notes_demo/service/db_service.dart';
import 'package:provider/provider.dart';

class AddTagPage extends StatefulWidget {
  final Tag tag;

  const AddTagPage({Key key, this.tag}) : super(key: key);

  @override
  _AddTagPageState createState() => _AddTagPageState();
}

class _AddTagPageState extends State<AddTagPage> {
  TextEditingController _nameController;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  bool _editMode;
  bool _processing;

  @override
  void initState() {
    super.initState();
    _processing = false;
    _editMode = widget.tag != null;
    _nameController =
        TextEditingController(text: _editMode ? widget.tag.name : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Tag Ekle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name",
              ),
              textInputAction: TextInputAction.next,
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
                      if (_nameController.text.isEmpty) {
                        _key.currentState.showSnackBar(SnackBar(
                          content: Text("Name alanı boş."),
                        ));
                        return;
                      }
                      Tag tag = Tag(
                        id: _editMode ? widget.tag.id : null,
                        name: _nameController.text,
                        createdAt: DateTime.now(),
                        userId:
                            Provider.of<UserRepository>(context, listen: false)
                                .user
                                .uid,
                      );
                      if (_editMode) {
                        await tagsDb.updateItem(tag);
                      } else {
                        await tagsDb.createItem(tag);
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
