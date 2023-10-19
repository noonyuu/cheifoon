import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sazikagen/component/appbar.dart';
import 'package:sazikagen/constant/color_constant.dart';
import '../../controller/bottle_controller.dart';
import 'package:sazikagen/model/bottle_model.dart';
import '../model/rectangle_model.dart';
import 'home_page.dart';

// import '../constant/String_constant.dart';

class Alert extends StatefulWidget {
  const Alert({Key? key}) : super(key: key);

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  List<seasoningItem> _rectangleList = []; // 四角形を追加していくためのリスト
  List<BottleModel> _bottleController = []; // ドロップダウンリストに表示するためのリスト
  String _recipeName = ''; // レシピ名を入れるための変数

  @override
  void initState() {
    super.initState();
    _initializeState();
    _rectangleList.add(seasoningItem()); // 初期状態で一つの四角形を追加
  }

  Future<void> _initializeState() async {
    // 登録済みの調味料を取得
    _bottleController = BottleController.bottleLists;
  }

  Widget _buildRectangle(seasoningItem recipeItem) {
    bool isBottleSelected = recipeItem.selectedBottle != null;

    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: ShapeDecoration(
              color: newColorConst.recipename,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(width: 0.50),
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Dropdown(recipeItem), // ドロップダウンリスト(調味料)
              if (isBottleSelected) // 調味料が選択されている時はナンバーピッカーを表示。選択されてなかったら表示されない
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.height * 0.13,
                  child: NumPicker(recipeItem),
                ),
            ],
          ),
        ),
      ],
    );
  }

// 調味料を表示していくためのリスト
  Widget _buildRectangleList() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          // 各調味料の情報を保持してあるリストを展開
          children: _rectangleList.map((recipeItem) {
            return _buildRectangle(recipeItem);
          }).toList(),
        ),
      ),
    );
  }

  // 戻るボタンが押された時(調味料が設定されてなかったら決定が押せないから、これを追加した)
  Widget _buildbackButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.height * 0.04,
        decoration: ShapeDecoration(
          color: newColorConst.recipename,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(width: 0.50),
          ),
        ),
        child: Center(
          child: Text(
            '戻る',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  // 追加ボタンが押された時
  Widget _buildAddButton() {
    return TextButton(
      onPressed: () {
        if (_rectangleList.any((item) => item.selectedBottle == null)) {
          return; // 調味料が選択されていない場合、何もしない
        }

        setState(() {
          _rectangleList.add(seasoningItem());
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.height * 0.04,
        decoration: ShapeDecoration(
          color: newColorConst.recipename,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(width: 0.50),
          ),
        ),
        child: Center(
          child: Text(
            '追加',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  // 調味料が設定されてなかったら決定ボタン押せない
  bool areAllIngredientsSelected() {
    return _rectangleList.every((item) => item.selectedBottle != null);
  }

  // 決定ボタン押されたとき
  Widget _buildDecisionButton() {
    return TextButton(
      onPressed: areAllIngredientsSelected()
          ? () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            }
          : null,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.height * 0.04,
        decoration: ShapeDecoration(
          color: newColorConst.recipename,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(width: 0.50),
          ),
        ),
        child: Center(
          child: Text(
            '決定',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _Dropdown(seasoningItem recipeItem) {
    return DropdownButton<BottleModel>(
      value: recipeItem.selectedBottle,
      onChanged: (newValue) {
        setState(() {
          recipeItem.selectedBottle = newValue;
        });
      },
      items: _bottleController.map((bottle) {
        return DropdownMenuItem<BottleModel>(
          value: bottle,
          child: Text(bottle.bottleTitle),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarComponentWidget(
          isInfoIconEnabled: false,
        ),
        // 全体画面
        backgroundColor: newColorConst.background,
        body: Column(
          children: [
            const SizedBox(
              // 検索バーの上に隙間入れるためのやつ
              height: 30,
            ),
            Stack(
              alignment: Alignment.center, // 検索バー背景を真ん中に持ってくる
              children: [
                Container(
                  // 検索バーの背景の四角形
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: ShapeDecoration(
                    color: newColorConst.recipename,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(width: 0.50),
                    ),
                  ),
                ),
                Center(
                  // 検索バーを真ん中に持ってくる
                  child: Container(
                    // 検索バー
                    child: TextField(
                      onChanged: (value) {
                        // 入力された値を取得
                        _recipeName = value;
                      },
                      // 入力できる形にする
                      textAlign: TextAlign.center, // テキストを真ん中にする
                      decoration: InputDecoration(
                        border: InputBorder.none, // 枠線を消す
                        // placeholderみたいなやつ
                        hintText: 'レシピ名',
                        hintStyle: TextStyle(color: basicColorConst.grey),
                      ),
                      keyboardType: TextInputType.text, // キーボードの形を決める
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              // 検索バーと調味料の間に隙間入れるために設置
              height: 30,
            ),
            _buildRectangleList(),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              _buildbackButton(),
              _buildAddButton(),
              _buildDecisionButton(),
            ]),
          ],
        ),
      ),
    );
  }

  Widget NumPicker(seasoningItem recipeItem) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              '大さじ',
              style: TextStyle(
                fontSize: 10,
                height: 3,
                fontWeight: FontWeight.bold,
              ),
            ),
            // ),
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.055,
              child: NumberPicker(
                value: recipeItem.selectedNumber1, // 値を個別に持たせるために各インスタンスから
                decoration: BoxDecoration(),
                minValue: 0,
                maxValue: 6,
                onChanged: (value) {
                  setState(() {
                    recipeItem.selectedNumber1 = value;
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text(
              '小さじ',
              style: TextStyle(
                fontSize: 10,
                height: 3,
                fontWeight: FontWeight.bold,
              ),
            ),
            // ),
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.055,
              child: NumberPicker(
                value: recipeItem.selectedNumber2, // 値を個別に持たせるために各インスタンスから
                minValue: 0,
                maxValue: 3,
                onChanged: (value) {
                  setState(() {
                    recipeItem.selectedNumber2 = value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
