import 'package:rxdart/subjects.dart';

class ListItem {
  ListItem({required this.id, required this.name});

  final String id;
  final String name;
}

class ListBloc {
  final listController = BehaviorSubject<ListItem>();
  Stream<ListItem> get getList => listController.stream;

  void updateList(ListItem item) {
    listController.sink.add(item);
  }

  void dispose() {
    listController.close();
  }
}

final bloc = ListBloc();
