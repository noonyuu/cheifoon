import '../model/bottle_model.dart';
//import '../constant/String_constant.dart';

class BottleController {
  final List<BottleModel> _bottle = [
    BottleModel(
      bottleId: 1,
      bottleTitle: '醤油',
    ),
    BottleModel(
      bottleId: 2,
      bottleTitle: 'みりん',
    ),
    BottleModel(
      bottleId: 3,
      bottleTitle: 'ごま油',
    ),
    BottleModel(
      bottleId: 4,
      bottleTitle: 'めんつゆ',
    ),
    BottleModel(
      bottleId: 5,
      bottleTitle: '料理酒',
    ),
    BottleModel(
      bottleId: 6,
      bottleTitle: 'ケチャップ',
    ),
    BottleModel(
      bottleId: 7,
      bottleTitle: 'ポン酢',
    ),
    BottleModel(
      bottleId: 8,
      bottleTitle: '醤油',
    ),
  ];

  List<BottleModel> get bottle => _bottle;
}
