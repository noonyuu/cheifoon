// import 'dart:ui';

// import 'package:flutter/cupertino.dart';
import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sazikagen/component/button.dart';
import 'package:sazikagen/constant/color_constant.dart';
import 'package:sazikagen/validator/min_lingth_validator.dart';

import '../component/text_field.dart';
import '../db/create_room.dart';
import '../validator/email_validator.dart';
import '../validator/max_lingth_validator.dart';
import '../validator/required_validator.dart';
import 'branch_point.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> yellowBoxHeightAnimation;
  late Animation<double> whiteBoxHeightAnimation;
  late Animation<double> logoOpacityAnimation;
  late Animation<double> logoSizeAnimation;

  late Animation<double> commonFadeSlideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 4));

    /**
     * 0.25秒かけて、0から1になる
     * Tween : アニメーションの始点と終点を定義
     * begin : 始点
     * end   : 終点
     * 
     * CurveTween : アニメーションにイージングをつける
     */
    yellowBoxHeightAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(
            tween: Tween<double>(begin: 0, end: 1).chain(
              CurveTween(curve: Curves.fastOutSlowIn),
            ),
            weight: 0.25),
        TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1), weight: 0.41),
        TweenSequenceItem(
            tween: Tween<double>(begin: 1, end: 0.5).chain(
              CurveTween(curve: Curves.decelerate),
            ),
            weight: 0.33),
      ],
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.75),
      ),
    );

    whiteBoxHeightAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.75, curve: Curves.decelerate),
      ),
    );

    logoOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.25, 0.35, curve: Curves.fastOutSlowIn),
      ),
    );
    logoSizeAnimation = Tween<double>(begin: 1, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.75, curve: Curves.decelerate),
      ),
    );

    commonFadeSlideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.65, 0.9, curve: Curves.decelerate),
      ),
    );
    setState(() {
      _animationController.forward();
    });
  }

  void onClick() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BranchPoint(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true, // キーボードを被せる
        body: SingleChildScrollView(
          reverse: false,
          child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    YellowBox(
                      yellowBoxHeightAnimation: yellowBoxHeightAnimation,
                      commonFadeSlideAnimation: commonFadeSlideAnimation,
                      logoOpacityAnimation: logoOpacityAnimation,
                      logoSizeAnimation: logoSizeAnimation,
                    ),
                    WhiteBox(
                      whiteBoxHeightAnimation: whiteBoxHeightAnimation,
                      commonFadeSlideAnimation: commonFadeSlideAnimation,
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class WhiteBox extends StatelessWidget {
  const WhiteBox({
    Key? key,
    required this.whiteBoxHeightAnimation,
    required this.commonFadeSlideAnimation,
  }) : super(key: key);

  final Animation<double> whiteBoxHeightAnimation;
  final Animation<double> commonFadeSlideAnimation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * whiteBoxHeightAnimation.value,
      child: SlideFadeWidget(
        commonFadeSlideAnimation: commonFadeSlideAnimation,
        child: const LogInForm(),
      ),
    );
  }
}

class LogInForm extends StatefulWidget {
  const LogInForm({
    Key? key,
  }) : super(key: key);

  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  TextEditingController roomNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // 入力値
  String _roomName = "";
  String _email = "";
  String _password = "";

  /// バリデーション結果
  bool _isValidName = false;
  bool _isValidPass = false;
  bool _isValidEmail = false;

  // 入力値を保持
  void _setName(String roomName) {
    setState(() {
      _roomName = roomName;
    });
  }

  void _setEmail(String email) {
    setState(() {
      _email = email;
    });
  }

  void _setPassword(String pass) {
    setState(() {
      _password = pass;
    });
  }

  // バリデーションの結果を保持
  void _setIsvalidRoomName(bool isValid) {
    setState(() {
      _isValidName = isValid;
    });
  }

  void _setIsvalidEmail(bool isValid) {
    setState(() {
      _isValidEmail = isValid;
    });
  }

  void _setIsvalidPass(bool isValid) {
    setState(() {
      _isValidPass = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: TabBarView(
              children: <Widget>[
                Column(
                  children: [
                    TextView(
                      labelText: "ルーム名(16文字以内)",
                      controller: _setName,
                      validator: [RequiredValidator(), MaxLengthValidator(16), MinLengthValidator(2)],
                      setIsValid: _setIsvalidRoomName,
                      secret: false,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    TextView(
                      labelText: "Email",
                      controller: _setEmail,
                      validator: [RequiredValidator(), EmailValidator(_email)],
                      setIsValid: _setIsvalidEmail,
                      secret: false,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    TextView(
                      labelText: "Password",
                      controller: _setPassword,
                      validator: [RequiredValidator(), MinLengthValidator(8)],
                      setIsValid: _setIsvalidPass,
                      secret: true,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                        buttonTitle: "作成",
                        height: 0.05,
                        width: 30,
                        textSize: 20,
                        onPressed: () async {
                          Map<String, dynamic> room = {};
                          room.addAll({'room_name': _roomName, 'password': _password, 'email': _email});
                          await postRoom(room);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BranchPoint(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextView(
                      labelText: "ルーム名",
                      controller: _setName,
                      validator: [
                        RequiredValidator(),
                        MaxLengthValidator(16),
                      ],
                      setIsValid: _setIsvalidRoomName,
                      secret: false,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    TextView(
                      labelText: "Email",
                      controller: _setEmail,
                      validator: [
                        RequiredValidator(),
                      ],
                      setIsValid: _setIsvalidEmail,
                      secret: false,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    TextView(
                      labelText: "Password",
                      controller: _setPassword,
                      validator: [
                        RequiredValidator(),
                      ],
                      setIsValid: _setIsvalidPass,
                      secret: true,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                        buttonTitle: "参加",
                        height: 0.05,
                        width: 30,
                        textSize: 20,
                        onPressed: () async {
                          Map<String, dynamic> room = {};
                          room.addAll({
                            'room_name': roomNameController.text,
                            'password': passwordController.text,
                          });
                          await postRoom(room);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BranchPoint(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class YellowBox extends StatelessWidget {
  const YellowBox({
    Key? key,
    required this.yellowBoxHeightAnimation,
    required this.commonFadeSlideAnimation,
    required this.logoOpacityAnimation,
    required this.logoSizeAnimation,
  }) : super(key: key);

  final Animation<double> yellowBoxHeightAnimation;
  final Animation<double> commonFadeSlideAnimation;
  final Animation<double> logoOpacityAnimation;
  final Animation<double> logoSizeAnimation;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height * yellowBoxHeightAnimation.value),
      color: ColorConst.mainColors,
      alignment: Alignment.bottomCenter,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // const Spacer(),
          Logo(
            logoOpacityAnimation: logoOpacityAnimation,
            logoSizeAnimation: logoSizeAnimation,
          ),
          // const Spacer(),
          SizedBox(
            height: MediaQuery.of(context).size.height * logoSizeAnimation.value * 0.09,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SlideFadeWidget(
                  commonFadeSlideAnimation: commonFadeSlideAnimation,
                  child: const TabBar(
                    tabs: <Widget>[
                      SizedBox(
                        width: 150, // タブ1の横幅
                        child: Tab(text: 'ルーム作成'),
                      ),
                      SizedBox(
                        width: 150, // タブ2の横幅
                        child: Tab(text: 'ルーム参加'),
                      ),
                    ],
                    labelColor: ColorConst.black,
                    unselectedLabelColor: ColorConst.grey,
                    indicatorColor: ColorConst.strongMainColors,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

// ロゴ
class Logo extends StatelessWidget {
  const Logo({
    Key? key,
    required this.logoOpacityAnimation,
    required this.logoSizeAnimation,
  }) : super(key: key);

  final Animation<double> logoOpacityAnimation;
  final Animation<double> logoSizeAnimation;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: logoOpacityAnimation.value,
      child: Image.asset(
        'assets/dragon.png',
        // color: background,
        height: MediaQuery.of(context).size.height * logoSizeAnimation.value * 0.8,
        // size: logoSizeAnimation.value * 150,
      ),
    );
  }
}

class SlideFadeWidget extends StatelessWidget {
  const SlideFadeWidget({
    Key? key,
    required this.commonFadeSlideAnimation,
    required this.child,
  }) : super(key: key);

  final Animation<double> commonFadeSlideAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(MediaQuery.of(context).size.width * (1 - commonFadeSlideAnimation.value), 0),
      child: Opacity(
        opacity: commonFadeSlideAnimation.value,
        child: child,
      ),
    );
  }
}
