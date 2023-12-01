import 'admin_bottle/admin_bottle_model.dart';
import 'user_bottle/user_bottle_model.dart';

class SeasoningItem {
  UserBottle? selectedBottle;
  int tableSpoon = 1;
  int teaSpoon = 1;

  SeasoningItem({this.selectedBottle, this.tableSpoon = 1, this.teaSpoon = 1});
}

class ItemAdmin {
  AdminBottle? selectedBottle;
  int tableSpoon = 1;
  int teaSpoon = 1;

  ItemAdmin({this.selectedBottle, this.tableSpoon = 1, this.teaSpoon = 1});
}
