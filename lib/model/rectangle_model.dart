import 'package:sazikagen/model/user_bottle/user_bottle_model.dart';

import 'admin_botle/admin_bottle_model.dart';

class seasoningItem {
  UserBottle? selectedBottle;
  int tableSpoon = 1;
  int teaSpoon = 1;

  seasoningItem({this.selectedBottle, this.tableSpoon = 1, this.teaSpoon = 1});
}

class ItemAdmin {
  AdminBottle? selectedBottle;
  int tableSpoon = 1;
  int teaSpoon = 1;

  ItemAdmin({this.selectedBottle, this.tableSpoon = 1, this.teaSpoon = 1});
}
