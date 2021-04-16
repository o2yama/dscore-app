import 'package:flutter/material.dart';

class VtDropDown extends StatefulWidget {
  @override
  _VtDropDownState createState() => _VtDropDownState();
}

class _VtDropDownState extends State<VtDropDown> {
  List<DropdownMenuItem<int>> _items = [];
  int _selectItem = 0;

  void initState() {
    super.initState();
    setItems();
    _selectItem = _items[0].value;
  }

  void setItems() {
    _items
      ..add(DropdownMenuItem(
        child: Text(
          'カサマツ',
          style: TextStyle(fontSize: 30.0),
        ),
        value: 1,
      ))
      ..add(DropdownMenuItem(
        child: Text(
          'アカピアン',
          style: TextStyle(fontSize: 30.0),
        ),
        value: 2,
      ))
      ..add(DropdownMenuItem(
        child: Text(
          'ドリックス',
          style: TextStyle(fontSize: 30.0),
        ),
        value: 3,
      ));
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: _items,
      value: _selectItem,
      onChanged: (value) => {
        setState(
          () {
            _selectItem = value;
          },
        ),
      },
    );
  }
}
