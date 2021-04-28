import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../../ad_state.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen(this.event);
  final String event;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    final height = MediaQuery.of(context).size.height - 50;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //広告
                  ad(context),
                  //戻るボタン
                  Container(
                    height: height * 0.1,
                    child: _backButton(context, widget.event),
                  ),
                  //検索バー
                  Container(
                    height: height * 0.1,
                    child: _searchBar(_searchController),
                  ),
                  //検索結果
                  Container(
                    height: height * 0.7,
                    child: _searchResults(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //広告
  Widget ad(BuildContext context) {
    return banner == null
        ? Container(height: 50)
        : Container(
            height: 50,
            child: AdWidget(ad: banner!),
          );
  }

  //戻るボタン
  _backButton(BuildContext context, String event) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.clear,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  //検索バー
  Widget _searchBar(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: controller,
        cursorColor: Theme.of(context).primaryColor,
        autofocus: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          hintText: '検索',
        ),
        onChanged: (text) {
          //todo:dataのキーと比較
        },
      ),
    );
  }

  //検索結果
  Widget _searchResults() {
    return ListView(
      children: [
        SizedBox(
          height: 80.0,
          child: Card(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Center(
                      child: Icon(Icons.accessibility),
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 3.0),
                    child: ListTile(
                      title: Center(
                        child: Text(
                          'コールマン',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
