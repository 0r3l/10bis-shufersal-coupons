import 'package:rxdart/subjects.dart';

class IntBloc {
  final intController = BehaviorSubject<int>();
  Stream<int> get getInt => intController.stream;

  void updateInt(int number) {
    intController.sink.add(number);
  }

  void dispose() {
    intController.close();
  }
}

final intBloc = IntBloc();
