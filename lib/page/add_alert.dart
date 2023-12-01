import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';

import '../component/app_bar.dart';
import '../constant/color_constant.dart';
import '../constant/layout.dart';
import '../controller/user_bottle_controller.dart';
import '../db/database_helper.dart';
import '../db/menu_add.dart';
import '../db/recipe_add.dart';
import '../logic/camera.dart';
import '../model/rectangle_model.dart';
import '../model/user_bottle/user_bottle_model.dart';
import 'branch_point.dart';

class Alert extends StatefulWidget {
  const Alert({Key? key}) : super(key: key);

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  final List<SeasoningItem> _rectangleList = []; // 四角形を追加していくためのリスト
  List<UserBottle> _bottleController = []; // ドロップダウンリストに表示するためのリスト
  String _recipeName = ''; // レシピ名を入れるための変数

  final dbHelper = DatabaseHelper.instance;

  late List<CameraDescription> cameras;
  int count = 0;

  SizeConfig sizeConfig = SizeConfig();

  XFile? image;
  final imagePicker = ImagePicker();

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

  // ギャラリーから写真を取得するメソッド
  Future getImageFromGarally() async {
    try {
      final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          image = XFile(pickedFile.path);
          imagePaths.setFilePath(image!.path);
        }
      });
    } catch (e) {
      print('error${e}');
    }
  }

  Widget _buildRectangle(SeasoningItem recipeItem, int index) {
    sizeConfig.init(context);
    bool isBottleSelected = recipeItem.selectedBottle != null;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        //   child: Container(
        //     width: MediaQuery.of(context).size.width * 0.8,
        //     height: MediaQuery.of(context).size.height * 0.15,
        //     decoration: ShapeDecoration(
        //       color: ColorConst.recipename,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10.0),
        //         side: const BorderSide(width: 0.50),
        //       ),
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.15,
            // child: Image.asset(
            //   'assets/images/board.png',
            //   fit: BoxFit.fill,
            // ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Dropdown(recipeItem), // ドロップダウンリスト(調味料)
              if (isBottleSelected) // 調味料が選択されている時はナンバーピッカーを表示。選択されてなかったら表示されない
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.height * 0.13,
                  child: numPicker(recipeItem),
                ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _rectangleList.removeAt(index);
                    });
                  },
                  child: const FaIcon(
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
          Navigator.pop(context, true);
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.height * 0.04,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/images/spoon_button.svg',
                  fit: BoxFit.cover,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Text(
                  '戻る',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ));
  }

  // 追加ボタンが押された時
  Widget _buildAddButton() {
    return TextButton(
        onPressed: () {
          print(count);
          if (_rectangleList.any((item) => item.selectedBottle == null)) {
            return; // 調味料が選択されていない場合、何もしない
          }
          if (count == 0) return;

          setState(() {
            _rectangleList.add(SeasoningItem());
          });
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.height * 0.04,
          child: Stack(
            // Use Stack to position the SVG and text on top of each other
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/images/spoon_button.svg',
                  fit: BoxFit.cover,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Text(
                  '追加',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _Dropdown(SeasoningItem recipeItem) {
    return DropdownButton<UserBottle>(
      value: recipeItem.selectedBottle,
      onChanged: (newValue) {
        setState(() {
          recipeItem.selectedBottle = newValue;
        });
      },
      items: _bottleController.map((bottle) {
        return DropdownMenuItem<UserBottle>(
          value: bottle,
          child: Text(bottle.seasoning_name),
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
                // TODO: user_idを変更する
                try {
                  File file = File(imagePaths.getFilePath());
                  int recipeId = await postRecipe(1, _recipeName, file);
                  List<Map<String, dynamic>> menu = [];
                  for (var item in _rectangleList) {
                    int? i = item.selectedBottle?.seasoning_id ?? 0;
                    menu.add({"recipe_id": recipeId, "user_id": 1, "seasoning_id": i, "table_spoon": item.tableSpoon - 1, "tea_spoon": item.teaSpoon - 1});
                  }
                  print('Menu Contents: $menu');
                  await postMenu(menu)
                      .then((value) => imagePaths.setFilePath(''))
                      .then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BranchPoint())));
                } catch (e) {
                  if (kDebugMode) {
                    print(e);
                  }
                }
              }
            : null,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.height * 0.04,
          child: Stack(
            // Use Stack to position the SVG and text on top of each other
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/images/spoon_button.svg',
                  fit: BoxFit.cover,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Text(
                  '決定',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ));
  }

// TODO:カメラ画面の表示
  Widget _camera() {
    double cameraSize = MediaQuery.of(context).size.width * 0.3; // 正方形にするために値は固定した

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          SizedBox(
            // height: MediaQuery.of(context).size.height * 0.2,
            width: cameraSize,
            height: cameraSize,
            // child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Camera(
                                camera: cameras.first,
                              )),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    // height: MediaQuery.of(context).size.height * 0.3,
                    height: cameraSize,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorConst.mainColor, // 枠線の色
                        width: 5.0, // 枠線の幅
                      ),
                      // color: Colors.amber,
                      // borderRadius: BorderRadius.circular(24.0), // 角の丸みを設定
                    ),
                    child: imagePaths.getFilePath().isNotEmpty ? Image.file(File(imagePaths.getFilePath())) : const Icon(Icons.camera_alt_outlined, size: 50),
                  )),
            ),
            // ),
          ),
          GestureDetector(
            onTap: getImageFromGarally,
            child: Container(
              width: cameraSize,
              height: cameraSize * 0.2,
              color: ColorConst.mainColor,
              child: const Center(child: Text("フォルダから選択")),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        // 全体画面
        backgroundColor: ColorConst.background,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(sizeConfig.screenHeight * 0.05),
          child: AppBarComponentWidget(
            title: 'Cheifoon',
            isInfoIconEnabled: true,
            context: context,
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                const SizedBox(
                  // 検索バーの上に隙間入れるためのやつ
                  height: 30,
                ),
                const Text(
                  "レシピ追加",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    // color: newColorConst.mainColor,
                  ),
                ),
                const SizedBox(
                  // 検索バーの上に隙間入れるためのやつ
                  height: 30,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        _camera(), // ここで直接 _camera() を呼び出す
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center, // 検索バー背景を真ん中に持ってくる
                      children: [
                        // Container(
                        //   // 検索バーの背景の四角形
                        //   height: MediaQuery.of(context).size.height * 0.07,
                        //   width: MediaQuery.of(context).size.width * 0.75,
                        //   decoration: ShapeDecoration(
                        //     color: const Color(0xFFFFEDAE),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       side: const BorderSide(width: 0.50),
                        //     ),
                        //   ),
                        // ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                // color: newColorConst.mainColor, // 下線色
                                width: 2.0, // 下線の太さ
                              ),
                            ),
                          ),
                        ),
                        Center(
                          // 検索バーを真ん中に持ってくる
                          child: SizedBox(
                            // 検索バー
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  count++;
                                });
                                // 入力された値を取得
                                _recipeName = value;
                                if (count == 1) {
                                  _rectangleList.add(SeasoningItem()); // 初期状態で一つの四角形を追加
                                }
                              },
                              // 入力できる形にする
                              textAlign: TextAlign.center, // テキストを真ん中にする
                              decoration: const InputDecoration(
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
                  ],
                ),
                // camera
                // TODO:カメラ画面の表示
                // count > 0 ? _camera() : Container(),

                // const SizedBox(
                //   // 検索バーと調味料の間に隙間入れるために設置
                //   height: 30,
                // ),
                _buildRectangleList(),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        _buildbackButton(),
                      ]),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      _buildAddButton(),
                      _buildDecisionButton(),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget numPicker(SeasoningItem recipeItem) {
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.055,
              child: NumberPicker(
                value: recipeItem.tableSpoon, // 値を個別に持たせるために各インスタンスから
                decoration: const BoxDecoration(),
                minValue: 0,
                maxValue: 5,
                infiniteLoop: true, // 0 ~ 5しか表示されない
                onChanged: (value) {
                  setState(() {
                    recipeItem.tableSpoon = value;
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.055,
              child: NumberPicker(
                value: recipeItem.teaSpoon, // 値を個別に持たせるために各インスタンスから
                minValue: 0,
                maxValue: 2,
                infiniteLoop: true, // 0 ~ 2しか表示されない
                onChanged: (value) {
                  setState(() {
                    recipeItem.teaSpoon = value;
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

  // Future<int> menuInsert(menuName, imagePath) async {
  //   Uint8List? uint8List = await readCacheFileToUint8List(imagePath);
  //   int? lastMenuId;
  //   Map<String, dynamic> menuTable = {DatabaseHelper.menuName: menuName, DatabaseHelper.menuImage: uint8List};
  //   return lastMenuId = await dbHelper.insertMenu(menuTable);
  // }

  // void recipeInsert(menuId, seasoningId, tableSpoon, teaSpoon) async {
  //   print(menuId);
  //   int? lastMenuId;
  //   Map<String, dynamic> recipeTable = {};
  //   Map<String, dynamic> menuTable = {};

  //   recipeTable = {
  //     DatabaseHelper.menuId: menuId,
  //     DatabaseHelper.seasoningId: seasoningId,
  //     DatabaseHelper.tableSpoon: tableSpoon != 0 ? tableSpoon - 1 : 0,
  //     DatabaseHelper.teaSpoon: teaSpoon != 0 ? teaSpoon - 1 : 0
  //   };
  //   await dbHelper.insertRecipe(recipeTable);
  // }
}
// --------------------------------------------------------------------------------
// class SeasoningItemCount {
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