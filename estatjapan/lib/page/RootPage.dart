import 'package:estatjapan/model/state/AppConfigState.dart';
import 'package:estatjapan/model/state/PurchaseState.dart';
import 'package:estatjapan/model/state/RepositoryDataState.dart';
import 'package:estatjapan/model/state_notifier/APIRepositoryNotifier.dart';
import 'package:estatjapan/util/SharedPreferencesUtil.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'GraphDataSelectPage.dart';
import 'ImmigrationStatisticsTypeSelectPage.dart';
import 'MenuDrawer.dart';
import 'VisaInfoPage.dart';

class RootPage extends StatelessWidget {
  final String title;
  const RootPage({Key? key, required this.title}) : super(key: key);

  Widget _body(BuildContext context) {
    context.read<APIRepositoryNotifier>().getMenuData();
    return getPageWidget(context);
  }

  Widget getPageWidget(BuildContext context) {
    final bAdModel = context.watch<AppConfigState>().bannerAdModel!
      ..loadBannerAd(context);
    return OrientationBuilder(builder: (context, orientation) {
      final rootPageState = context.watch<RepositoryDataState>();
      return Column(
        children: [
          if (orientation == Orientation.portrait &&
              bAdModel.isAdLoaded() &&
              !context.watch<PurchaseState>().isAdDeletedDone)
            Container(
              width: double.infinity,
              height: 72.0,
              alignment: Alignment.center,
              child: AdWidget(ad: bAdModel.bannerAd()),
            ),
          if (rootPageState.immigrationStatisticsRoot != null)
            Expanded(
                flex: 1,
                child: () {
                  switch (rootPageState.selectedIndex) {
                    case 0:
                      return const ImmigrationStatisticsTypeSelectPage();
                    case 1:
                      return const GraphDataSelectPage();
                    case 2:
                      return const VisaInfoPage();
                    default:
                      return const Center(child: Text("予想外エラー"));
                  }
                }()),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferencesUtil.getBool('isShowedPrivacyPolicyDialog')
        .then((isShowedPrivacyPolicyDialog) async {
      if (isShowedPrivacyPolicyDialog != true) {
        await SharedPreferencesUtil.setBool(
            'isShowedPrivacyPolicyDialog', true);
        if (context.mounted) {
          showPrivacyPolicyDialog(context);
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
      body: _body(context),
      drawer: const MenuDrawer(), //抽屉
      bottomNavigationBar: Builder(builder: (context) {
        return BottomNavigationBar(
          // 底部导航
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.add_chart_rounded), label: '在留資格審査'),
            BottomNavigationBarItem(
                icon: Icon(Icons.align_horizontal_left_rounded), label: 'グラフ'),
            //　審査通れないのでコメントアウト
            // https://play.google.com/console/u/0/policy-emails/developers/8555153811676652561?id=4980033980793107208&id=4980239439883718177
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.all_inbox_rounded), label: 'ビザに関する情報'),
          ],
          currentIndex: context.watch<RepositoryDataState>().selectedIndex,
          onTap: (index) =>
              context.read<APIRepositoryNotifier>().selectedIndex = index,
        );
      }),
    );
  }

  void showPrivacyPolicyDialog(BuildContext pcontext) {
    showDialog(
      context: pcontext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('情報について'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                    'このアプリで提供される政府関連の情報は、日本の政府統計ポータルサイト「e-Stat」から取得したものです。'
                    'データはe-Statの利用規約に基づいて公開されています。'
                    '詳細については、e-Statの利用規約をご参照ください。'),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    const url = 'https://www.e-stat.go.jp/terms-of-use';
                    launchUrl(Uri.parse(url));
                  },
                  child: const Text(
                    'e-Stat 利用規約',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('閉じる'),
            ),
          ],
        );
      },
    );
  }
}
