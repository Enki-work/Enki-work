import 'package:estatjapan/util/UIUnti.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EStaInfoPage extends StatelessWidget {
  const EStaInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: const Text("データ提供元"),
        ),
        body: Container(
            padding:
                const EdgeInsets.only(top: 26, left: 16, right: 16, bottom: 16),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'images/stat.svg',
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                const SizedBox(height: 26),
                const Text(
                  "このサービスは、政府統計総合窓口(e-Stat)のAPI機能を使用していますが、サービスの内容は国によって保証されたものではありません。",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "e-Statとは",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'https://www.youtube.com/watch?v=39NW-vGtA5k',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchURL(context,
                                "https://www.youtube.com/watch?v=39NW-vGtA5k");
                          },
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
