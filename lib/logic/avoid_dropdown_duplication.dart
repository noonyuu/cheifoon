import 'package:sazikagen/model/rectangle_model.dart';

import '../model/user_bottle/user_bottle_model.dart';

class DropDown {
  final List<UserBottle> _bottle;
  List<UserBottle> newBottle;

  List<UserBottle> get newSeasoningList => newBottle;

  DropDown(List<UserBottle> bottle) : _bottle = bottle, newBottle = bottle;

  // すでに追加した調味料を選択できないようにする
  newList(List<SeasoningItem> currentBottle) {
    // 差分を取得するためにSetに変換
    Set<UserBottle> bottleSet = _bottle.toSet();
    Set<UserBottle?> currentBottleSet = currentBottle.map((e) => e.selectedBottle).toSet();

    // 差分を取得
    Set<UserBottle> difference = bottleSet.difference(currentBottleSet);

    // SetをListに変換
    newBottle = difference.toList();
  }
}
