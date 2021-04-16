import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen(this.event);
  final String event;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            //検索バー
            _searchBar(),
            //検索結果
            _searchResults(),
          ],
        ),
      ),
    );
  }

  //検索バー
  Widget _searchBar() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            '検索',
            style: TextStyle(fontSize: 25.0),
          ),
        ),
        TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'コールマン',
          ),
        )
      ],
    );
  }

  //検索結果
  Widget _searchResults() {
    return ListTile(
      leading: Icon(Icons.accessibility),
      contentPadding: EdgeInsets.all(10.0),
      title: Text('コールマン'),
    );
  }
}
