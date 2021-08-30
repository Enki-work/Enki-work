import 'package:dio/dio.dart';
import 'package:estatjapan/model/Class.dart';
import 'package:estatjapan/model/ImmigrationStatisticsRoot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MenuDrawer.dart';

class ImmigrationStatisticsPage extends StatefulWidget {
  final String title;

  const ImmigrationStatisticsPage({Key? key, required this.title})
      : super(key: key);
  @override
  _ImmigrationStatisticsPageState createState() =>
      _ImmigrationStatisticsPageState();
}

class _ImmigrationStatisticsPageState extends State<ImmigrationStatisticsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Dio _dio = Dio();
    ScrollController _controller = new ScrollController();
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: Text(widget.title),
          actions: <Widget>[
            //导航栏右侧菜单
            IconButton(icon: Icon(Icons.share), onPressed: () {}),
          ],
        ),
        drawer: new MenuDrawer(), //抽屉
        bottomNavigationBar: BottomNavigationBar(
          // 底部导航
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.add_chart_rounded), title: Text('在留資格審査')),
            BottomNavigationBarItem(
                icon: Icon(Icons.align_horizontal_left_rounded),
                title: Text('審査受理・処理')),
            BottomNavigationBarItem(
                icon: Icon(Icons.all_inbox_rounded), title: Text('在留管理局・支局')),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.blue,
          onTap: _onItemTapped,
        ),
        body: Container(
          child: FutureBuilder(
              future: _dio.get(
                  "http://api.e-stat.go.jp/rest/3.0/app/json/getStatsData?appId=7bed85b352e6c3d46ad6def4390196b23d86bcec&lang=J&statsDataId=0003423913&metaGetFlg=Y&cntGetFlg=N&explanationGetFlg=Y&annotationGetFlg=Y&sectionHeaderFlg=1&replaceSpChars=0"),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  Response response = snapshot.data;
                  ImmigrationStatisticsRoot rootModel =
                      ImmigrationStatisticsRoot.fromJson(response.data);
                  switch (_selectedIndex) {
                    case 0:
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          () {
                            List<Class> CLASSList = rootModel.GET_STATS_DATA
                                .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                                .firstWhere((e) => e.id == "cat01")
                                .CLASS;
                            return Expanded(
                                child: ListView.separated(
                              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                              itemCount: CLASSList.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) =>
                                  ListTile(
                                title: Text(CLASSList[index].name),
                                minVerticalPadding: 25,
                              ),
                              separatorBuilder:
                                  (BuildContext context, int index) => Divider(
                                height: 0.5,
                                indent: 20,
                                color: Colors.grey[120],
                              ),
                            ));
                          }(),
                        ],
                      );
                    case 1:
                      return Center(child: Text("111"));
                    case 2:
                      return Center(child: Text("222"));
                    default:
                      return Center(child: Text("予想外エラー"));
                  }
                } else {
//请求未完成时弹出loading
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
