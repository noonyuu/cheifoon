// エリアの指定
import '../constant/layout.dart';

double functionArea(PhoneSize size) {
  return (size.functionAreaSize);
}

extension FunctionAreaSize on PhoneSize {
  double get functionAreaSize => switch (this) {
        PhoneSize.verticalMobile => 0.2,
        PhoneSize.horizonMobile => 0.45,
        PhoneSize.verticalTablet => 0.4,
        PhoneSize.horizonTablet => 0.4,
      };
}

// poisonedの指定
class PotionPoint {
  final double top;
  final double left;

  PotionPoint({
    required this.top,
    required this.left,
  });
}

PotionPoint potionPoint(PhoneSize size) {
  print(size.showSeasoningSize);
  return (size.showSeasoningSize);
}

extension PotionPointExtension on PhoneSize {
  PotionPoint get showSeasoningSize => switch (this) {
        PhoneSize.verticalMobile => PotionPoint(
            top: 0.095,
            left: 0.05,
          ),
        PhoneSize.horizonMobile => PotionPoint(
            top: 0.19,
            left: 0.1,
          ),
        PhoneSize.verticalTablet => PotionPoint(
            top: 0.19,
            left: 0.1,
          ),
        PhoneSize.horizonTablet => PotionPoint(
            top: 0.19,
            left: 0.1,
          ),
      };
}