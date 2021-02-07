import 'package:flutter/material.dart';
import 'package:notes_demo/model/tag.dart';

class TagDetailsPage extends StatelessWidget {
  final Tag tag;

  const TagDetailsPage({Key key, @required this.tag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tag Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              tag.name,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
