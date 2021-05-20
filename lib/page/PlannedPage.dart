import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/model/Planned.dart';
import 'package:gomoney_finance_app/page/LoadingPage.dart';
import 'package:gomoney_finance_app/screen/AddPlannedScreen.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:gomoney_finance_app/widget/PlannedPage/PlannedCard.dart';

class PlannedPage extends StatefulWidget {
  @override
  _PlannedPageState createState() => _PlannedPageState();
}

class _PlannedPageState extends State<PlannedPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetIt.I<SqliteService>().getAllPlanned(),
        builder: (context, AsyncSnapshot<List<Planned>> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                    child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return PlannedCard(snapshot.data![index]);
                    },
                  ),
                )),
                Container(
                  height: 80.r,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPlannedScreen(true)),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10.r),
                            child: Container(
                              decoration:
                                  StyleUtil.rowndedBoxWithShadow.copyWith(
                                color: StyleUtil.secondaryColor,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Center(
                                child: Text(
                                  "INCOME",
                                  style: TextStyle(
                                      fontFamily: "Prompt",
                                      fontSize: 30.r,
                                      color: StyleUtil.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddPlannedScreen(false)),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10.r),
                            child: Container(
                              decoration:
                                  StyleUtil.rowndedBoxWithShadow.copyWith(
                                color: StyleUtil.secondaryColor,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Center(
                                child: Text(
                                  "EXPENSE",
                                  style: TextStyle(
                                      fontFamily: "Prompt",
                                      fontSize: 30.r,
                                      color: StyleUtil.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return LoadingPage(StyleUtil.secondaryColor);
          }
        });
  }

  void update(ind) {
    setState(() {});
  }
}
