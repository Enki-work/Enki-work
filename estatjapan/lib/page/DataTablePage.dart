import 'dart:io';

import 'package:estatjapan/model/RouteModel.dart';
import 'package:estatjapan/model/jsonModel/ClassOBJ.dart';
import 'package:estatjapan/model/jsonModel/ImmigrationStatisticsRoot.dart';
import 'package:estatjapan/model/jsonModel/Value.dart';
import 'package:estatjapan/model/state/AppConfigState.dart';
import 'package:estatjapan/model/state_notifier/APIRepositoryNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:provider/provider.dart';

class DataTablePage extends StatefulWidget {
  static const double height = 56;
  static const double width = 110;
  static const double compactWidth = 70;

  final RouteModel routeModel;

  const DataTablePage({Key? key, required this.routeModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DataTablePageState();
}

class _DataTablePageState extends State<DataTablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: Text(
              "${widget.routeModel.selectedCLASS.name}（${widget.routeModel.selectedMonth?.name ?? ""}）"),
        ),
        body: FutureBuilder(
            future: context
                .read<APIRepositoryNotifier>()
                .getDataTable(widget.routeModel),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                ImmigrationStatisticsRoot rootModel = snapshot.data;
                widget.routeModel.loadedDatarootModel = rootModel;
                if (rootModel
                    .GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE.isEmpty) {
                  return const Center(
                    child: Text("データなし"),
                  );
                }
                return _getBodyWidget();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            SystemChrome.setPreferredOrientations(
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? [DeviceOrientation.portraitUp]
                        : [DeviceOrientation.landscapeRight])
                .then((value) {
              if (Platform.isIOS) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight
                ]);
              }
            });
          },
          child: const Icon(Icons.screen_rotation_rounded),
        ));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  Widget _getBodyWidget() {
    final leftHandSideColumnWidth =
        widget.routeModel.selectedCLASS.parentID == "cat02"
            ? DataTablePage.compactWidth * 2
            : DataTablePage.width;
    final rightHandSideColumnWidth =
        widget.routeModel.selectedCLASS.parentID == "cat03"
            ? MediaQuery.of(context).size.width - leftHandSideColumnWidth
            : widget.routeModel.rootModel!.GET_STATS_DATA.STATISTICAL_DATA
                    .CLASS_INF.CLASS_OBJ
                    .firstWhere((element) => element.id == "cat03")
                    .CLASS
                    .length *
                DataTablePage.width;
    return OrientationBuilder(builder: (context, orientation) {
      final bAdModel = context.watch<AppConfigState>().bannerAdModel!
        ..loadBannerAd(context);
      return Column(children: [
        if (orientation == Orientation.portrait && bAdModel.isAdLoaded())
          Container(
            width: bAdModel.bannerAd().size.width.toDouble(),
            height: 72.0,
            alignment: Alignment.center,
            child: AdWidget(ad: bAdModel.bannerAd()),
          ),
        Expanded(
          child: HorizontalDataTable(
            leftHandSideColumnWidth: leftHandSideColumnWidth,
            rightHandSideColumnWidth: rightHandSideColumnWidth,
            isFixedHeader: true,
            headerWidgets: _getTitleWidget(),
            leftSideItemBuilder: _generateFirstColumnRow,
            rightSideItemBuilder: _generateRightHandSideColumnRow,
            itemCount: () {
              if (widget.routeModel.selectedCLASS.parentID == "cat01") {
                return widget.routeModel.rootModel!.GET_STATS_DATA
                    .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                    .firstWhere((element) => element.id == "cat02")
                    .CLASS
                    .length;
              } else if (widget.routeModel.selectedCLASS.parentID == "cat02") {
                return widget.routeModel.rootModel!.GET_STATS_DATA
                    .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                    .firstWhere((element) => element.id == "cat01")
                    .CLASS
                    .length;
              } else {
                return widget.routeModel.rootModel!.GET_STATS_DATA
                        .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                        .firstWhere((element) => element.id == "cat01")
                        .CLASS
                        .length *
                    widget.routeModel.rootModel!.GET_STATS_DATA.STATISTICAL_DATA
                        .CLASS_INF.CLASS_OBJ
                        .firstWhere((element) => element.id == "cat02")
                        .CLASS
                        .length;
              }
            }(),
            rowSeparatorWidget: Divider(
              color: Colors.grey[120],
              height: 0.5,
              thickness: 0.0,
            ),
            leftHandSideColBackgroundColor:
                Theme.of(context).colorScheme.background,
            rightHandSideColBackgroundColor:
                Theme.of(context).colorScheme.background,
            verticalScrollbarStyle: ScrollbarStyle(
              thumbColor: Theme.of(context).primaryColorDark,
              isAlwaysShown: true,
              thickness: 4.0,
              radius: const Radius.circular(5.0),
            ),
            horizontalScrollbarStyle: ScrollbarStyle(
              thumbColor: Theme.of(context).primaryColorDark,
              isAlwaysShown: true,
              thickness: 4.0,
              radius: const Radius.circular(5.0),
            ),
          ),
        )
      ]);
    });
  }

  List<Widget> _getTitleWidget() {
    if (widget.routeModel.selectedCLASS.parentID == "cat03") {
      return [
        const SizedBox(
          width: DataTablePage.width,
          height: DataTablePage.height,
        ),
        _getTitleItemWidget(
            widget.routeModel.selectedCLASS.name, DataTablePage.width)
      ];
    } else {
      List<Widget> list = List<Widget>.from(widget.routeModel.rootModel!
          .GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat03")
          .CLASS
          .map((e) => _getTitleItemWidget(e.name, DataTablePage.width))
          .toList());
      list.insert(
          0,
          const SizedBox(
            width: DataTablePage.width,
            height: DataTablePage.height,
          ));
      return list;
    }
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: DataTablePage.height,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    if (widget.routeModel.selectedCLASS.parentID == "cat01") {
      ClassOBJ obj = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat02");
      return Container(
        width: DataTablePage.width,
        height: DataTablePage.height,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
        child: Text(obj.CLASS[index].name),
      );
    } else if (widget.routeModel.selectedCLASS.parentID == "cat02") {
      ClassOBJ obj = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat01");
      return Container(
        width: DataTablePage.compactWidth * 2,
        height: DataTablePage.height,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
                flex: 1,
                child: Text(
                  obj.CLASS[index].name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                )),
            Expanded(
                flex: 1,
                child: Text(widget.routeModel.selectedCLASS.name,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center))
          ],
        ),
      );
    } else {
      ClassOBJ cat01Obj = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat01");
      ClassOBJ cat02Obj = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat02");
      int cat01Index = index ~/ cat02Obj.CLASS.length;
      int cat02Index = (index % cat02Obj.CLASS.length).toInt();
      return Container(
        width: DataTablePage.compactWidth * 2,
        height: DataTablePage.height,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
        child: Flex(
          direction: Axis.horizontal,
          children: () {
            return [
              Expanded(
                  flex: 1,
                  child: Text(cat01Obj.CLASS[cat01Index].name,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center)),
              Expanded(
                  flex: 1,
                  child: Text(cat02Obj.CLASS[cat02Index].name,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center))
            ];
          }(),
        ),
      );
    }
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    if (widget.routeModel.selectedCLASS.parentID == "cat01") {
      ClassOBJ objCat02 = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat02");
      ClassOBJ objCat03 = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat03");
      String cat02Code = objCat02.CLASS[index].code;
      List<Widget> children = [];
      for (var element in objCat03.CLASS) {
        for (Value value in widget.routeModel.loadedDatarootModel.GET_STATS_DATA
            .STATISTICAL_DATA.DATA_INF.VALUE) {
          if (value.cat01 == widget.routeModel.selectedCLASS.code &&
              value.cat02 == cat02Code &&
              value.cat03 == element.code) {
            children.add(Container(
              width: DataTablePage.width,
              height: DataTablePage.height,
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
              child: Text(value.value ?? ""),
            ));
            break;
          }
        }
      }
      return Row(children: children);
    } else if (widget.routeModel.selectedCLASS.parentID == "cat02") {
      ClassOBJ objCat01 = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat01");
      ClassOBJ objCat03 = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat03");
      String cat01Code = objCat01.CLASS[index].code;
      List<Widget> children = [];
      for (var element in objCat03.CLASS) {
        for (Value value in widget.routeModel.loadedDatarootModel.GET_STATS_DATA
            .STATISTICAL_DATA.DATA_INF.VALUE) {
          if (value.cat01 == cat01Code &&
              value.cat02 == widget.routeModel.selectedCLASS.code &&
              value.cat03 == element.code) {
            children.add(Container(
              width: DataTablePage.width,
              height: DataTablePage.height,
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
              child: Text(value.value ?? ""),
            ));
            break;
          }
        }
      }
      return Row(children: children);
    } else {
      ClassOBJ cat01Obj = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat01");
      ClassOBJ cat02Obj = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat02");
      int cat01Index = index ~/ cat02Obj.CLASS.length;
      int cat02Index = (index % cat02Obj.CLASS.length).toInt();
      List<Widget> children = [];

      for (Value value in widget.routeModel.loadedDatarootModel.GET_STATS_DATA
          .STATISTICAL_DATA.DATA_INF.VALUE) {
        if (value.cat01 == cat01Obj.CLASS[cat01Index].code &&
            value.cat02 == cat02Obj.CLASS[cat02Index].code &&
            value.cat03 == widget.routeModel.selectedCLASS.code) {
          children.add(Container(
            width: DataTablePage.width,
            height: DataTablePage.height,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.center,
            child: Text(value.value ?? ""),
          ));
          break;
        }
      }
      return Row(
        children: children,
      );
    }
  }
}
