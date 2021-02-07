import 'package:flutter/material.dart';
import 'package:notes_demo/model/user_repository.dart';
import 'package:notes_demo/ui/pages/notes/add_note.dart';
import 'package:notes_demo/ui/pages/auth_home.dart';
import 'package:notes_demo/ui/pages/tags/add_tag.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserRepository.instance(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Notes',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.indigo,
            textTheme: ButtonTextTheme.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          ),
          inputDecorationTheme: InputDecorationTheme(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 16.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              labelStyle: TextStyle(
                fontSize: 18.0,
                color: Colors.grey.shade600,
              )),
        ),
        home: AuthHomePage(),
        routes: {
          "add_note": (_) => AddNotePage(),
          "add_tag": (_) => AddTagPage(),
        },
      ),
    );
  }
}
