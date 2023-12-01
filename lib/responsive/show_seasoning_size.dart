import '../constant/layout.dart';

class ShowSeasoningSize {
  final double height;
  final double width;
  final double bottomPadding;
  final double bottleHeight;

  ShowSeasoningSize({
    required this.height,
    required this.width,
    required this.bottomPadding,
    required this.bottleHeight,
  });
}

ShowSeasoningSize showSeasoning(PhoneSize size) {
  print(size.showSeasoningSize);
  return (size.showSeasoningSize);
}

extension ShowSeasoningSizeExtension on PhoneSize {
  ShowSeasoningSize get showSeasoningSize => switch (this) {
        PhoneSize.verticalMobile => ShowSeasoningSize(
            height: 0.1,
            width: 1,
            bottomPadding: 0.008,
            bottleHeight: 0.08,
          ),
        PhoneSize.horizonMobile => ShowSeasoningSize(
            height: 0.2,
            width: 1,
            bottomPadding: 0.016,
            bottleHeight: 0.16,
          ),
        PhoneSize.verticalTablet => ShowSeasoningSize(
            height: 0.2,
            width: 1,
            bottomPadding: 0.016,
            bottleHeight: 0.16,
          ),
        PhoneSize.horizonTablet => ShowSeasoningSize(
            height: 0.2,
            width: 1,
            bottomPadding: 0.016,
            bottleHeight: 0.16,
          ),
      };
}
