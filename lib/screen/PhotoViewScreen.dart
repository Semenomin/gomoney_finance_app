import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhotoViewScreen extends StatelessWidget {
  final Image image;
  PhotoViewScreen(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: StyleUtil.primaryColor,
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: StyleUtil.primaryColor,
          child: Column(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 60.r,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        height: double.infinity,
                        width: 60.r,
                        child: FittedBox(
                          child: Icon(
                            Icons.arrow_back,
                            color: StyleUtil.secondaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PhotoView.customChild(
                    backgroundDecoration:
                        BoxDecoration(color: StyleUtil.primaryColor),
                    child: image),
              )
            ],
          ),
        ),
      )),
    );
  }
}
