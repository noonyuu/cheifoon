import '../constant/layout.dart';

double appBar(PhoneSize size) {
  return (size.appBarSize);
}

extension AppBarSize on PhoneSize {
  double get appBarSize => switch (this) {
        PhoneSize.verticalMobile => 0.05,
        PhoneSize.horizonMobile => 0.1,
        PhoneSize.verticalTablet => 0.1,
        PhoneSize.horizonTablet => 0.1,
      };
}
