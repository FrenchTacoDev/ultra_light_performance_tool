import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ultra_light_performance_tool/src/database/workqueue.dart';

void main() {
  test('Testing the workqueue', () async {
    var wq = DBWorkQueue(onWorkStarted: ()async{}, onWorkFinished: ()async{});

    var work1 = Work(workFunction: () async => Future.delayed(const Duration(seconds: 5)));
    var work2 = Work<int>(workFunction: () async => 999);
    var work3 = Work<String>(workFunction: () async{
      await Future.delayed(const Duration(seconds: 3));
      return "test";
    });

    var start = DateTime.now();
    wq.scheduleNewWork(work1);
    wq.scheduleNewWork(work2);
    wq.scheduleNewWork(work3);

    var res = await work2.completer.future;
    expect(res, 999);
    var msg = await work3.completer.future;
    expect(msg, "test");
    expect(DateTime.now().difference(start).inSeconds, 8);
  });
}