import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../component/app_bar.dart';
import '../component/button.dart';
import '../component/text_field.dart';
import '../constant/color_constant.dart';
import '../constant/layout.dart';
import '../controller/user_bottle_controller.dart';
import '../db/menu_add.dart';
import '../db/recipe_add.dart';
import '../logic/avoid_dropdown_duplication.dart';
import '../logic/camera.dart';
import '../model/rectangle_model.dart';
import '../model/user_bottle/user_bottle_model.dart';
import '../validator/max_length_validator.dart';
import '../validator/required_validator.dart';

class AddRecipe extends StatefulWidget {
  final PhoneSize _size;
  const AddRecipe({
    Key? key,
    required PhoneSize size,
  })  : _size = size,
        super(key: key);

  @override
  State<AddRecipe> createState() => getImageFromGally();
}

class getImageFromGally extends State<AddRecipe> {
  List<UserBottle> _bottleController = [];
  final List<SeasoningItem> _useSeasoningList = [SeasoningItem()];
  late DropDown dropDown;
  bool _isSelected = false;

  UserBottle? selectSeasoning;
  int tableSpoon = 0;
  int teaSpoon = 0;

  late SizeConfig sizeConfig;
  TextEditingController recipeController = TextEditingController();
  bool cute = false;
  bool beautiful = false;

  late List<CameraDescription> cameras;
  XFile? image;
  final imagePicker = ImagePicker();

  String _recipeName = "";
  bool _isValidRecipeName = false;

  void _setRecipeName(String pass) {
    setState(() {
      _recipeName = pass;
    });
  }

  // バリデーションの結果を保持
  void _setIsvalidRecipeName(bool isValid) {
    setState(() {
      _isValidRecipeName = isValid;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeState();
    initCamera();
  }

  Future<void> _initializeState() async {
    // 登録済みの調味料を取得
    _bottleController = BottleController.bottleLists;
    dropDown = DropDown(_bottleController);
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
  }

  // 画像選択の確認
  bool imageSelected() {
    return imagePaths.getFilePath().isNotEmpty ? true : false;
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

  @override
  Widget build(BuildContext context) {
    sizeConfig = SizeConfig();
    sizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false, // キーボードを被せる
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(sizeConfig.screenHeight * appBar(widget._size)),
          child: AppBarComponentWidget(
            title: 'Cheifoon',
            isInfoIconEnabled: true,
            context: context,
            size: widget._size,
          ),
        ), // リ
        body: Column(
          children: [
            SizedBox(
              height: sizeConfig.screenHeight * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                  SizedBox(
                    width: sizeConfig.screenWidth * 0.8,
                    child: TextView(
                      labelText: "レシピ名",
                      controller: _setRecipeName,
                      validator: [
                        RequiredValidator(),
                        MaxLengthValidator(16),
                      ],
                      setIsValid: _setIsvalidRecipeName,
                      secret: false,
                    ),
                  ),
                ],
              ),
            ),
            ExpansionTile(
              title: Row(
                children: [
                  const Text('レシピ画像'),
                  const SizedBox(width: 4.0),
                  imageSelected()
                      ? const Icon(Icons.check, size: 16.0, color: ColorConst.red)
                      : const Row(
                          children: [
                            Icon(Icons.warning, size: 16.0, color: ColorConst.red),
                            Text("未選択", style: TextStyle(fontSize: 12.0, color: ColorConst.red)),
                          ],
                        ),
                ],
              ),
              collapsedBackgroundColor: ColorConst.mainColors,
              backgroundColor: ColorConst.mainColors,
              controlAffinity: ListTileControlAffinity.leading,
              onExpansionChanged: (bool changed) {
                setState(() {
                  cute = false;
                  beautiful = changed;
                });
              },
              children: <Widget>[
                _camera(),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            ExpansionTile(
              title: const Text('調味料'),
              collapsedBackgroundColor: ColorConst.mainColors,
              backgroundColor: ColorConst.mainColors,
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8), color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  children: [
                                    const Text("調味料"),
                                    DropdownButton<UserBottle>(
                                      underline: Container(),
                                      value: selectSeasoning,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectSeasoning = newValue;
                                          _useSeasoningList[_useSeasoningList.length - 1].selectedBottle = newValue!;
                                          _isSelected = true;
                                        });
                                      },
                                      items: dropDown.newSeasoningList.map((bottle) {
                                        return DropdownMenuItem<UserBottle>(
                                          value: bottle,
                                          child: Text(bottle.seasoning_name),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                )),
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  children: [
                                    const Text("大さじ"),
                                    DropdownButton<int>(
                                      underline: Container(),
                                      value: tableSpoon,
                                      onChanged: (newTableSpoon) {
                                        setState(() {
                                          tableSpoon = newTableSpoon!;
                                          _useSeasoningList[_useSeasoningList.length - 1].tableSpoon = newTableSpoon;
                                        });
                                      },
                                      items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8].map((int tableSpoon) {
                                        return DropdownMenuItem<int>(
                                          value: tableSpoon,
                                          child: Text(tableSpoon.toString()),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                )),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text("小さじ"),
                                DropdownButton<int>(
                                  underline: Container(),
                                  value: teaSpoon,
                                  onChanged: (newTeaSpoon) {
                                    setState(() {
                                      teaSpoon = newTeaSpoon!;
                                      _useSeasoningList[_useSeasoningList.length - 1].teaSpoon = newTeaSpoon;
                                    });
                                  },
                                  items: <int>[0, 1, 2].map((int teaSpoon) {
                                    return DropdownMenuItem<int>(
                                      value: teaSpoon,
                                      child: Text(teaSpoon.toString()),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              // 未入力時は追加しない
                              if (!_isSelected) {
                                return;
                              }
                              dropDown.newList(_useSeasoningList);
                              _useSeasoningList.add(SeasoningItem());
                              setState(() {
                                selectSeasoning = null;
                                tableSpoon = 0;
                                teaSpoon = 0;
                                _isSelected = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LimitedBox(
                    maxHeight: sizeConfig.screenHeight * 0.5,
                    child: ReorderableListView.builder(
                      shrinkWrap: true,
                      itemCount: _useSeasoningList.length -1,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final item = _useSeasoningList.removeAt(oldIndex);
                          _useSeasoningList.insert(newIndex, item);
                        });
                      },
                      itemBuilder: (BuildContext context, index) {
                        return Dismissible(
                          key: ObjectKey(_useSeasoningList[index]),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16.0),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              _useSeasoningList.removeAt(index);
                              if (_useSeasoningList.isNotEmpty) {
                                _useSeasoningList[_useSeasoningList.length - 1].selectedBottle = null;
                              }
                              dropDown.newList(_useSeasoningList);
                              _isSelected = false;
                            });
                          },
                          child: Card(
                            key: ValueKey(_useSeasoningList[index]),
                            child: ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 16.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "調味料",
                                              style: TextStyle(fontFamily: 'NotoSansJP', fontSize: 12, color: ColorConst.grey),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _useSeasoningList[index].selectedBottle!.seasoning_name,
                                          style: const TextStyle(fontFamily: 'NotoSansJP', fontSize: 20),
                                          strutStyle: const StrutStyle(height: 2),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 16.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "大さじ",
                                              style: TextStyle(fontFamily: 'NotoSansJP', fontSize: 12, color: ColorConst.grey),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _useSeasoningList[index].tableSpoon.toString(),
                                          style: const TextStyle(fontFamily: 'NotoSansJP', fontSize: 20),
                                          strutStyle: const StrutStyle(height: 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 16.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "小さじ",
                                              style: TextStyle(fontFamily: 'NotoSansJP', fontSize: 12, color: ColorConst.grey),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _useSeasoningList[index].teaSpoon.toString(),
                                          style: const TextStyle(fontFamily: 'NotoSansJP', fontSize: 20),
                                          strutStyle: const StrutStyle(height: 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            // 送信ボタン
            CustomButton(
              buttonTitle: "追加",
              height: 0.05,
              width: 0.3,
              textSize: 20,
              onPressed: () async {
                // TODO: user_idを変更する
                try {
                  File file = File(imagePaths.getFilePath());
                  int recipeId = await postRecipe(1, recipeController.text, file);
                  List<Map<String, dynamic>> menu = [];
                  for (var item in _useSeasoningList) {
                    int? i = item.selectedBottle?.seasoning_id ?? 0;
                    menu.add({"recipe_id": recipeId, "user_id": 1, "seasoning_id": i, "table_spoon": item.tableSpoon, "tea_spoon": item.teaSpoon});
                  }
                  await postMenu(menu).then((value) => imagePaths.setFilePath('')).then((value) => Navigator.pop(context, true));
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _camera() {
    double cameraSize = MediaQuery.of(context).size.width * 0.3; // 正方形にするために値は固定した

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          SizedBox(
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
                  child: SizedBox(
                    height: cameraSize,
                    width: double.infinity,
                    child: imagePaths.getFilePath().isNotEmpty ? Image.file(File(imagePaths.getFilePath())) : const Icon(Icons.camera_alt_outlined, size: 50),
                  )),
            ),
          ),
          GestureDetector(
            onTap: getImageFromGarally,
            child: Container(
              width: cameraSize,
              height: cameraSize * 0.2,
              color: ColorConst.mainColors,
              child: const Center(child: Text("フォルダから選択")),
            ),
          )
        ],
      ),
    );
  }
}
