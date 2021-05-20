import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/dialogs/AddName.dart';
import 'package:gomoney_finance_app/dialogs/AreYouSure.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RenameOrDelete {
  RenameOrDelete(context, void onRename(TextEditingController controller),
      void onDelete()) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          child: Column(
            children: [
              Expanded(child: Container()),
              Padding(
                padding: EdgeInsets.all(10.r),
                child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: StyleUtil.secondaryColor),
                    child: Column(
                      children: [
                        ListTile(
                            onTap: () =>
                                AddName(context, "RENAME", (_nameController) {
                                  onRename(_nameController);
                                  Navigator.pop(context);
                                }),
                            title: Text("Rename",
                                style: TextStyle(
                                  fontSize: 20.r,
                                  color: StyleUtil.primaryColor,
                                ))),
                        Divider(height: 0),
                        ListTile(
                            onTap: () {
                              AreYouSure(context, "ARE YOU SURE?", () {
                                onDelete();
                                Navigator.pop(context);
                              });
                            },
                            title: Text("Delete",
                                style: TextStyle(
                                  fontSize: 20.r,
                                  color: StyleUtil.primaryColor,
                                ))),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
