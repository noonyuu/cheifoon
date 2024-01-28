import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../controller/recipe_controller.dart';
import '../model/recipe/recipe_model.dart';

class SingleShotLottie extends StatefulWidget {
  const SingleShotLottie({Key? key, required this.asset}) : super(key: key);
  final String asset;

  @override
  State<SingleShotLottie> createState() => _SingleShotLottieState();
}

class _SingleShotLottieState extends State<SingleShotLottie> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  List<Recipe> _recipePost = []; // レシピデータ
  int randomIndex = 0;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _initializeState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 7000)); // 例として500ミリ秒を指定
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeState() async {
    await RecipeController.menuList().then((menuList) {
      setState(() {
        _recipePost = menuList;
        print(_recipePost);
        // if (menuList.isNotEmpty) {
        //   fetchCheck['menu'] = true;
        // }
      });
    });
  }

  Future<void> _playAnimation() async {
    if (_controller.isCompleted) {
      // 2回目以降はリセット
      setState(() {
        _isPlaying = true;
      });
      _controller.reset();
    }
    // 最初のフレームからアニメーションを再生
    await _controller.forward();
    // アニメーションを再生して最後のフレームに到達
    await _controller.animateTo(1);
    // 1秒待つ
    await Future<void>.delayed(const Duration(seconds: 1));

    setState(() {
      randomIndex = _random(_recipePost.length);
      _isPlaying = false;
    });
  }

  int _random(int recipeCount) {
    final random = Random();
    final int randomIndex = random.nextInt(recipeCount);
    return randomIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: const Center(child: Text('今日の献立ガチャ！')),
        ),
        _isPlaying
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Lottie.asset(
                  widget.asset,
                  repeat: false,
                  controller: _controller,
                  fit: BoxFit.contain,
                ),
              )
            : Container(
                color: Colors.white,
                
                child: Column(
                  children: [
                    Image.memory(
                     height: MediaQuery.of(context).size.width * 0.5,
                      width: MediaQuery.of(context).size.width * 0.5,
                      _recipePost[randomIndex].menu_image,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        _recipePost[randomIndex].recipe_name,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
        _isPlaying ?
          ElevatedButton(
            onPressed: _playAnimation,
            child: const Text('もう一度みる'),
          )
          : const SizedBox()
      ],
    );
  }
}
