import 'dart:io';
import 'package:dscore_app/screens/event_screen/event_screen.dart';
import 'package:dscore_app/screens/theme_color/theme_color_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'intro/intro_model.dart';
import 'intro/intro_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> event = ['床', 'あん馬', '吊り輪', '跳馬', '平行棒', '鉄棒'];
  final List<String> eventEng = ['FX', 'PH', 'SR', 'VT', 'PB', 'HB'];
  @override
  Widget build(BuildContext context) {
    final introModel = Provider.of<IntroModel>(context, listen: false);
    return FutureBuilder(
      future: Future(() async {
        await introModel.checkIsIntroWatched();
        if (introModel.isIntroWatched) {
          try {
            await introModel.getUserData();
          } catch (e) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Platform.isIOS
                    ? CupertinoAlertDialog(
                        title: Text('$e'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          )
                        ],
                      )
                    : AlertDialog(
                        title: Text('$e'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          )
                        ],
                      );
              },
            );
          }
        }
      }),
      builder: (context, snapshot) {
        return Consumer<IntroModel>(builder: (context, model, child) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Text('6種目'),
                  actions: [
                    CupertinoButton(
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Theme.of(context).primaryColor,
                        child: Icon(Icons.color_lens, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ThemeColorScreen()),
                        );
                      },
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    _eventTile(context, event[0], eventEng[0]),
                    _eventTile(context, event[1], eventEng[1]),
                    _eventTile(context, event[2], eventEng[2]),
                    _eventTile(context, event[3], eventEng[3]),
                    _eventTile(context, event[4], eventEng[4]),
                    _eventTile(context, event[5], eventEng[5]),
                  ],
                ),
              ),
              (!model.isIntroWatched) ? IntroScreen() : Container(),
              (model.isLoading)
                  ? Container(
                      color: Colors.grey.withOpacity(0.6),
                      child: Center(
                        child: Platform.isIOS
                            ? CupertinoActivityIndicator()
                            : CircularProgressIndicator(),
                      ),
                    )
                  : Container(),
            ],
          );
        });
      },
    );
  }

  Widget _eventTile(BuildContext context, String event, String eventEng) {
    return ListTile(
      title: Text(
        '$event',
        style: TextStyle(fontSize: 20),
      ),
      subtitle: Text(
        '$eventEng',
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventScreen(event)),
        );
      },
    );
  }
}
