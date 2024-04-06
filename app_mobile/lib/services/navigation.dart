class Navigation {
  static Navigation? _instance;

  Navigation._(); // Constructeur privé

  static Navigation getInstance() {
    _instance ??= Navigation._();
    return _instance!;
  }

  static int index = 0;

  void setIndex(int value){
    index = value;
    selectedIndex();
  }

  Stream<int> selectedIndex() async* {
      yield index;
  }
}