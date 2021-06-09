import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

main() {
  final searchField = find.byValueKey(SEARCH_FIELD);
  final searchButton = find.byValueKey(SEARCH_BUTTON);
  final searchContent = find.byValueKey(SEARCH_CONTENT);

  final content1 = find.byValueKey(CONTENT_KEY + "1");
  final content2 = find.byValueKey(CONTENT_KEY + "2");

  final detailLeading = find.byValueKey(DETAIL_LEADING);
  final detailContent = find.byValueKey(DETAIL_CONTENT);
  final detailImage = find.byValueKey(DETAIL_IMAGE);
  enableFlutterDriverExtension();
  group("Application test", () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test("widget is available", () async {
      await driver.waitFor(searchButton);
      await driver.waitFor(searchField);
    });

    test("enter text on search field", () async {
      await driver.tap(searchField);
      await driver.enterText("dicodingacademy");
      await driver.enterText("dicoding");
      await driver.enterText("flutter");
      await driver.enterText("testing");
    });

    test("show detail of user", () async {
      await driver.waitFor(content1);
      await driver.tap(content1);
      await driver.waitFor(detailImage);
      await driver.waitFor(detailContent);
      await driver.tap(detailLeading);
    });

    test("show another detail of user", () async {
      await driver.waitFor(content2);
      await driver.tap(content2);
      await driver.waitFor(detailImage);
      await driver.waitFor(detailContent);
      await driver.tap(detailLeading);
    });
  });
}
