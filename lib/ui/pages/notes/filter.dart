import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> countList = [];
  List<String> selectedCountList = [];

  void _openFilterDialog() async {
    await FilterListDialog.display(context,
        allTextList: countList,
        height: 700,
        borderRadius: 20,
        headlineText: "Select Count",
        searchFieldHintText: "Search Here",
        selectedTextList: selectedCountList, onApplyButtonClick: (list) {
      if (list != null) {
        setState(() {
          selectedCountList = List.from(list);
        });
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: Text("aa"),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFilterDialog,
        tooltip: 'Increment',
        child: Icon(Icons.search),
      ),
      body: Column(
        children: <Widget>[
          selectedCountList == null || selectedCountList.length == 0
              ? Expanded(
                  child: Center(
                    child: Text('No text selected'),
                  ),
                )
              : Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(selectedCountList[index]),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: selectedCountList.length),
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
    );
  }
}
