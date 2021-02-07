import 'package:flutter/material.dart';
import 'package:notes_demo/model/note.dart';
import 'package:notes_demo/model/user_repository.dart';
import 'package:notes_demo/service/db_service.dart';
import 'package:notes_demo/ui/pages/notes/add_note.dart';
import 'package:notes_demo/ui/pages/notes/note_details.dart';
import 'package:notes_demo/ui/pages/tags/tags_home.dart';
import 'package:notes_demo/ui/widgets/note_item.dart';
import 'package:provider/provider.dart';
import 'package:filter_list/filter_list.dart';

class NotesHomPage extends StatefulWidget {
  @override
  _NotesHomPageState createState() => _NotesHomPageState();
}

class _NotesHomPageState extends State<NotesHomPage> {
  List<String> countList = [];
  List<String> selectedCountList = [];
  Future<void> selectAll() async {
    selectedCountList = await tagsDb
        .getQueryList()
        .then((value) => value.map((e) => e.name).toList());
  }

  @override
  void initState() {
    super.initState();
    selectAll();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedCountList = [];
  }

  void _openFilterDialog() async {
    countList = await tagsDb
        .getQueryList()
        .then((value) => value.map((e) => e.name).toList());
    await FilterListDialog.display(context,
        allTextList: countList,
        height: 700,
        borderRadius: 20,
        headlineText: "Filtreleme",
        searchFieldHintText: "Ara",
        selectedTextList: selectedCountList, onApplyButtonClick: (list) {
      if (list != null) {
        setState(() {
          selectedCountList = List.from(list);
        });
        Navigator.pop(context);
      }
    });
  }

  Future<List<Note>> getSelectedList() async {
    var selectedTags = await tagsDb.getQueryList().then((value) => value
        .where((e) => selectedCountList.any((element) => element == e.name))
        .toList());

    var notes = await notesDb.getQueryList();

    var selectedList = notes
        .where((note) => note.tags
            .any((tag) => selectedTags.any((element) => element.id == tag)))
        .toList();
    if (selectedTags.length > 0) {
      return selectedList;
    } else {
      return notes;
    }
  }

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
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getSelectedList(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
                if (snapshot.hasError)
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                if (!snapshot.hasData) return CircularProgressIndicator();

                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => NoteItem(
                    onTap: (note) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteDetailsPage(
                            note: note,
                          ),
                        )),
                    note: snapshot.data[index],
                    onEdit: (note) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddNotePage(note: note),
                        ),
                      );
                    },
                    onDelete: (note) async {
                      if (await _confirmDelete(context)) {
                        notesDb.removeItem(note.id);
                      }
                    },
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                onPressed: _openFilterDialog,
                child: Text(
                  "Filtrele",
                  style: TextStyle(color: Colors.black),
                ),
                color: Colors.yellow.shade600,
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, "add_note"),
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
