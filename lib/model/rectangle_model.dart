import 'bottle_model.dart';

class seasoningItem {
  BottleModel? selectedBottle;
  int tableSpoon = 1;
  int teaSpoon = 1;

  seasoningItem({this.selectedBottle, this.tableSpoon = 1, this.teaSpoon = 1});
}

class ItemAdmin {
  BottleAdminModel? selectedBottle;
  int tableSpoon = 1;
  int teaSpoon = 1;

  ItemAdmin({this.selectedBottle, this.tableSpoon = 1, this.teaSpoon = 1});
}
