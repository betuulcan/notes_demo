import 'package:flutter/material.dart';
import 'package:notes_demo/model/tag.dart';
import 'package:notes_demo/model/user_repository.dart';
import 'package:notes_demo/service/db_service.dart';
import 'package:notes_demo/ui/pages/notes/notes_home.dart';
import 'package:notes_demo/ui/pages/tags/add_tag.dart';
import 'package:notes_demo/ui/pages/tags/tags_details.dart';
import 'package:notes_demo/ui/widgets/tag_item.dart';
import 'package:provider/provider.dart';

class TagsHomePage extends StatefulWidget {
  @override
  _TagsHomePageState createState() => _TagsHomePageState();
}

class _TagsHomePageState extends State<TagsHomePage> {
  @override
  Widget build(BuildContext context) {
    UserRepository user = Provider.of<UserRepository>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text("Notes App"),
        actions: <Widget>[
          user.status == Status.Authenticating
              ? CircularProgressIndicator()
              : IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () => user.signOut(),
                )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'NOTES APP',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 28),
                    ),
                    Icon(
                      Icons.note_outlined,
                      color: Colors.yellow.shade600,
                      size: 55,
                    ),
                  ]),
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
            ),
            ListTile(
              title: Text('Not Sayfası'),
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => NotesHomPage()));
              },
            ),
            ListTile(
              title: Text('Tag Sayfası'),
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => TagsHomePage()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: StreamBuilder(
          stream: tagsDb.streamList(),
          builder: (BuildContext context, AsyncSnapshot<List<Tag>> snapshot) {
            if (snapshot.hasError)
              return Center(
                child: Text("Hata oluştu!"),
              );
            if (!snapshot.hasData) return CircularProgressIndicator();

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => TagItem(
                onTap: (tag) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TagDetailsPage(
                        tag: tag,
                      ),
                    )),
                tag: snapshot.data[index],
                onEdit: (tag) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddTagPage(tag: tag),
                    ),
                  );
                },
                onDelete: (tag) async {
                  if (await _confirmDelete(context)) {
                    tagsDb.removeItem(tag.id);
                  }
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, "add_tag"),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Sil"),
              content: Text("Silmek istediğinize emin misiniz?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("İptal"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text("Sil"),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));
  }
}
