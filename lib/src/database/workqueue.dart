import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';

///Work Queue implementation for db operations.
///Makes sure db requests are handled one after another and as efficient as possible.
class DBWorkQueue{

  DBWorkQueue({required this.onWorkStarted, required this.onWorkFinished});

  final Queue<Work> _workQueue = Queue<Work>();
  List<Work> _discardWork = [];
  bool isRunning = false;
  AsyncCallback onWorkStarted;
  AsyncCallback onWorkFinished;

  void scheduleNewWork(Work work){
    if(isRunning) return _workQueue.add(work);
    _workQueue.add(work);
    _runWork();
  }

  void _runWork() async{
    isRunning = true;
    await onWorkStarted();

    while(_workQueue.isNotEmpty){
      var work = _workQueue.first;

      if(_discardWork.contains(work)){
        _discardWork.remove(work);
        continue;
      }

      await work.runWork();
      await Future.delayed(Duration.zero);
      _workQueue.removeFirst();
    }

    if(_discardWork.isNotEmpty) _discardWork = [];
    await onWorkFinished();
    isRunning = false;
    if(_workQueue.isNotEmpty) _runWork();
  }

  void discardWork(Work work){
    if(_discardWork.contains(work)) return;
    _discardWork.add(work);
  }
}

class Work<T>{

  Work({required this.workFunction}){
    completer = Completer<T>();
  }

  final Future<T> Function() workFunction;
  late final Completer<T> completer;

  Future<void> runWork() async{
    var completionValue = await workFunction();
    completer.complete(completionValue);
  }
}