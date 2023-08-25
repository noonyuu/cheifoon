import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sazikagen/component/appbar.dart';

import 'package:sazikagen/constant/color_constant.dart';
import '../../controller/bottle_controller.dart';
import 'package:sazikagen/model/bottle_model.dart';
import '../db/database_helper.dart';
import '../logic/camera.dart';
import '../model/rectangle_model.dart';
import 'home_page.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Alert extends StatefulWidget {
  const Alert({Key? key}) : super(key: key);

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  List<seasoningItem> _rectangleList = []; // 四角形を追加していくためのリスト
  List<BottleModel> _bottleController = []; // ドロップダウンリストに表示するためのリスト
  String _recipeName = ''; // レシピ名を入れるための変数

  final dbHelper = DatabaseHelper.instance;

  late List<CameraDescription> cameras;
  int count = 0;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    cameras = await availableCameras();
    // 登録済みの調味料を取得
    _bottleController = BottleController.bottleLists;
  }

  Widget _buildRectangle(seasoningItem recipeItem, int index) {
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
              color: ColorConst.recipename,
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
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _rectangleList.removeAt(index);
                    });
                  },
                  child: FaIcon(
                    FontAwesomeIcons.trash,
                    color: ColorConst.red,
                    size: 20.0, // 任意のサイズを指定
                  ),
                ),
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
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            // 各調味料の情報を保持してあるリストを展開
            // children: _rectangleList.map((recipeItem) {
            //   return _buildRectangle(recipeItem);
            // }).toList(),
            children: _rectangleList.asMap().entries.map((entry) {
              return _buildRectangle(entry.value, entry.key);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildbackButton() {
    return TextButton(
      onPressed: () {
        imagePaths.setFilePath('');
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.height * 0.04,
        decoration: ShapeDecoration(
          color: ColorConst.recipename,
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
          color: ColorConst.recipename,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(width: 0.50),
          ),
        ),
        child: Center(
          child: Text(
            '調味料追加',
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

  // 調味料が設定されてなかったら決定ボタン押せない
  bool areAllIngredientsSelected() {
    return _rectangleList.every((item) => item.selectedBottle != null);
  }

  //画像が設定されてなかったら決定ボタン押せない
  bool imageSelected() {
    return imagePaths.getFilePath().isNotEmpty ? true : false;
  }

// 決定ボタン押されたとき
  Widget _buildDecisionButton() {
    return TextButton(
      onPressed: areAllIngredientsSelected() && imageSelected()
          ? () async {
              int menuId = await menuInsert(_recipeName, imagePaths.getFilePath());
              _rectangleList.forEach((item) async {
                recipeInsert(menuId, item.selectedBottle?.bottleId, item.selectedNumber1, item.selectedNumber1);
              });
              imagePaths.setFilePath('');
              Navigator.pop(context);
              // 更新かけるとおかしくなる
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
            }
          : null,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.height * 0.04,
        decoration: ShapeDecoration(
          color: ColorConst.recipename,
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

// TODO:カメラ画面の表示
  Widget _camera() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Camera(camera: cameras.first)));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorConst.mainColor, // 枠線の色
                      width: 5.0, // 枠線の幅
                    ),
                    // color: Colors.amber,
                    borderRadius: BorderRadius.circular(24.0), // 角の丸みを設定
                  ),
                  child: imagePaths.getFilePath().isNotEmpty ? Image.file(File(imagePaths.getFilePath())) : Icon(Icons.camera_alt_outlined, size: 50, color: ColorConst.mainColor),
                )),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // 全体画面
        backgroundColor: ColorConst.background,
        appBar: AppBarComponentWidget(
          isInfoIconEnabled: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
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
                        color: Color(0xFFFFEDAE),
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
                            setState(() {
                              count++;
                            });
                            // 入力された値を取得
                            _recipeName = value;
                            if (count == 1) {
                              _rectangleList.add(seasoningItem()); // 初期状態で一つの四角形を追加
                            }
                          },
                          // 入力できる形にする
                          textAlign: TextAlign.center, // テキストを真ん中にする
                          decoration: InputDecoration(
                            border: InputBorder.none, // 枠線を消す
                            // placeholderみたいなやつ
                            hintText: 'レシピ名',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          keyboardType: TextInputType.text, // キーボードの形を決める
                        ),
                      ),
                    ),
                  ],
                ),
                // camera
                // TODO:カメラ画面の表示
                count > 0 ? _camera() : Container(),

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
                maxValue: 5,
                infiniteLoop: true, // 0 ~ 5しか表示されない
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
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.055,
              child: NumberPicker(
                value: recipeItem.selectedNumber2, // 値を個別に持たせるために各インスタンスから
                minValue: 0,
                maxValue: 2,
                infiniteLoop: true, // 0 ~ 2しか表示されない
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

  Future<Uint8List?> readCacheFileToUint8List(String filePath) async {
    try {
      File file = File(filePath);

      if (await file.exists()) {
        Uint8List uint8List = await file.readAsBytes();
        return uint8List;
      } else {
        print("File not found: $filePath");
        return null;
      }
    } catch (e) {
      print("Error reading file: $e");
      return null;
    }
  }

  Future<int> menuInsert(menuName, imagePath) async {
    Uint8List? uint8List = await readCacheFileToUint8List(imagePath);
    int? lastMenuId;
    Map<String, dynamic> menuTable = {DatabaseHelper.menuName: menuName, DatabaseHelper.menuImage: uint8List};
    return lastMenuId = await dbHelper.insertMenu(menuTable);
  }

  void recipeInsert(menuId, seasoningId, tableSpoon, teaSpoon) async {
    print(menuId);
    int? lastMenuId;
    Map<String, dynamic> recipeTable = {};
    Map<String, dynamic> menuTable = {};

    recipeTable = {
      DatabaseHelper.menuId: menuId,
      DatabaseHelper.seasoningId: seasoningId,
      DatabaseHelper.tableSpoon: tableSpoon != 0 ? tableSpoon - 1 : 0,
      DatabaseHelper.teaSpoon: teaSpoon != 0 ? teaSpoon - 1 : 0
    };
    await dbHelper.insertRecipe(recipeTable);
  }
}

// class seasoningItemCount {
//   static int s = 0;
//   static void setSeasoningItemCount() {
//     ;
//     s++;
//   }

//   static int getSeasoningItemCount() {
//     return s;
//   }
// }
// カレー,seasoningId{1},2,1,seasoningId{1},1,1,seasoningId{2},2,1,seasoningId{2},1,1,
// カレー,seasoningId{1},2,1,seasoningId{2},1,1,

// 醤油
// みりん
// さけ
// ウスターソース