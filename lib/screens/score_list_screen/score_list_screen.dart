import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dscore_app/common/convertor.dart';
import 'package:dscore_app/common/utilities.dart';
import 'package:dscore_app/domain/score.dart';
import 'package:dscore_app/domain/score_with_cv.dart';
import 'package:dscore_app/screens/common_widgets/ad/banner_ad.dart';
import 'package:dscore_app/screens/common_widgets/custom_dialog/ok_cancel_dialog.dart';
import 'package:dscore_app/screens/common_widgets/loading_view/loading_view.dart';
import 'package:dscore_app/screens/home_screen/home_model.dart';
import 'package:dscore_app/screens/home_screen/home_screen.dart';
import 'package:dscore_app/screens/score_edit_screen/score_edit_screen.dart';
import 'package:dscore_app/screens/score_list_screen/score_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ScoreListScreen extends StatelessWidget {
  const ScoreListScreen({
    Key? key,
    required this.event,
  }) : super(key: key);
  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final scoreModel = ref.watch(scoreModelProvider);
          final homeModel = ref.watch(homeModelProvider);

          return Container(
            color: Theme.of(context).backgroundColor,
            child: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Utilities.screenHeight(context) * 0.1,
                          child: _backButton(context, event),
                        ),
                        SizedBox(
                          height: Utilities.screenHeight(context) * 0.1,
                          child: _eventNameDisplay(context, scoreModel),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: RefreshIndicator(
                            onRefresh: () async => scoreModel.getScores(event),
                            child: _scoreList(context, scoreModel, homeModel),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: const [
                      Expanded(child: SizedBox()),
                      BannerAdWidget(),
                    ],
                  ),
                  const LoadingView(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _backButton(BuildContext context, Event event) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Platform.isIOS
          ? Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  '6種目',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            )
          : Icon(
              Icons.clear,
              color: Theme.of(context).primaryColor,
            ),
    );
  }

  Widget _eventNameDisplay(BuildContext context, ScoreModel scoreModel) {
    return Row(
      children: [
        SizedBox(width: Utilities.screenWidth(context) * 0.15),
        Text(
          Convertor.eventName[event]!,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        Expanded(child: Container()),
        IconButton(
          icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
          onPressed: () {
            scoreModel
              ..selectEvent(event)
              ..resetScore();
            Navigator.push<Object>(
              context,
              MaterialPageRoute(
                builder: (context) => ScoreEditScreen(event: event),
              ),
            );
          },
        ),
        SizedBox(width: Utilities.screenWidth(context) * 0.1),
      ],
    );
  }

  Widget _scoreList(
    BuildContext context,
    ScoreModel scoreModel,
    HomeModel homeModel,
  ) {
    switch (event) {
      case Event.fx:
        return ListView(
          children: scoreModel.fxScoreList
              .map(
                (score) => _scoreTile(
                  context,
                  scoreModel,
                  homeModel,
                  scoreWithCV: score,
                ),
              )
              .toList(),
        );
      case Event.ph:
        return ListView(
          children: scoreModel.phScoreList
              .map(
                (score) => _scoreTile(
                  context,
                  scoreModel,
                  homeModel,
                  score: score,
                ),
              )
              .toList(),
        );
      case Event.sr:
        return ListView(
          children: scoreModel.srScoreList
              .map(
                (score) => _scoreTile(
                  context,
                  scoreModel,
                  homeModel,
                  score: score,
                ),
              )
              .toList(),
        );
      case Event.pb:
        return ListView(
          children: scoreModel.pbScoreList
              .map(
                (score) => _scoreTile(
                  context,
                  scoreModel,
                  homeModel,
                  score: score,
                ),
              )
              .toList(),
        );
      case Event.hb:
        return ListView(
          children: scoreModel.hbScoreList
              .map(
                (score) => _scoreTile(
                  context,
                  scoreModel,
                  homeModel,
                  scoreWithCV: score,
                ),
              )
              .toList(),
        );
      default:
        return ListView();
    }
  }

  Widget _scoreTile(
    BuildContext context,
    ScoreModel scoreModel,
    HomeModel homeModel, {
    Score? score,
    ScoreWithCV? scoreWithCV,
  }) {
    return InkWell(
      onTap: () async {
        await scoreModel.getScore(
          score == null ? scoreWithCV!.scoreId : score.scoreId,
          event,
        );
        await Navigator.push<Object>(
          context,
          MaterialPageRoute(
            builder: (context) => ScoreEditScreen(
              event: event,
              scoreId: score == null ? scoreWithCV!.scoreId : score.scoreId,
            ),
          ),
        );
      },
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              label: '複製',
              backgroundColor: Colors.blue,
              icon: CupertinoIcons.plus_square_fill_on_square_fill,
              onPressed: (context) => _onCopyButtonPressed(
                context,
                score == null ? scoreWithCV!.scoreId : score.scoreId,
                scoreModel,
                homeModel,
              ),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              label: '削除',
              backgroundColor: Colors.red,
              icon: Icons.remove,
              onPressed: (context) => _onDeleteButtonPressed(
                context,
                score == null ? scoreWithCV!.scoreId : score.scoreId,
                scoreModel,
              ),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _favoriteButton(
                context,
                score == null ? scoreWithCV!.isFavorite : score.isFavorite,
                score == null ? scoreWithCV!.scoreId : score.scoreId,
                homeModel,
                scoreModel,
              ),
            ),
            Expanded(
              flex: 9,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: Utilities.screenWidth(context) * 0.05),
                      Text(
                        '${score == null ? scoreWithCV!.total : score.total}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(width: Utilities.screenWidth(context) * 0.05),
                      _techsListView(
                        context,
                        score == null ? scoreWithCV!.techs : score.techs,
                      ),
                      SizedBox(width: Utilities.screenWidth(context) * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///選択した演技を複製する
  Future<void> _onCopyButtonPressed(
    BuildContext context,
    String scoreId,
    ScoreModel scoreModel,
    HomeModel homeModel,
  ) async {
    await scoreModel.getScore(scoreId, event);
    await scoreModel.setScore(event);
    await scoreModel.getScores(event);
    await homeModel.getFavoriteScores();
    await showOkAlertDialog(
      context: context,
      title: '複製が完了しました。',
    );
  }

  Future<void> _onDeleteButtonPressed(
    BuildContext context,
    String scoreId,
    ScoreModel scoreModel,
  ) async {
    await showDialog<Dialog>(
      context: context,
      builder: (context) => OkCancelDialog(
        onOk: () {
          scoreModel.deletePerformance(event, scoreId);
          Navigator.pop(context);
        },
        onCancel: () => Navigator.pop(context),
        title: 'この演技を削除してもよろしいですか？',
        content: '削除した演技は元には戻りません。',
      ),
    );
  }

  Widget _favoriteButton(
    BuildContext context,
    bool isFavorite,
    String scoreId,
    HomeModel homeModel,
    ScoreModel scoreModel,
  ) {
    return IconButton(
      icon: Icon(
        Icons.star,
        size: 30,
        color: isFavorite ? Theme.of(context).primaryColor : Colors.white,
      ),
      onPressed: () async {
        await scoreModel.onFavoriteButtonTapped(event, isFavorite, scoreId);
        await homeModel.getFavoriteScores();
      },
    );
  }

  //演技の内容が見れるところ
  Widget _techsListView(BuildContext context, List<String> techs) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListView(
        children: techs
            .map(
              (tech) => Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(child: Text(tech)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
