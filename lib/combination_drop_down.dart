import 'package:flutter/material.dart';

class CombinationDropDown extends StatefulWidget {
  @override
  _CombinationDropDownState createState() => _CombinationDropDownState();
}

class _CombinationDropDownState extends State<CombinationDropDown> {
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
          '0.1',
          style: TextStyle(fontSize: 30.0),
        ),
        value: 1,
      ))
      ..add(DropdownMenuItem(
        child: Text(
          '0.2',
          style: TextStyle(fontSize: 30.0),
        ),
        value: 2,
      ))
      ..add(DropdownMenuItem(
        child: Text(
          '0.3',
          style: TextStyle(fontSize: 30.0),
        ),
        value: 3,
      ))
      ..add(DropdownMenuItem(
        child: Text(
          '0.4',
          style: TextStyle(fontSize: 30.0),
        ),
        value: 4,
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
