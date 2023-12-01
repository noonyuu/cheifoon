import 'package:flutter/material.dart';

import '../constant/color_constant.dart';
import '../db/database_helper.dart';
import '../model/admin_bottle/admin_bottle_model.dart';
import '../model/rectangle_model.dart';
import '../model/user_bottle/user_bottle_model.dart';

class InsertSeasoningAlert extends StatelessWidget {
  final ItemAdmin itemAdmin;
  final List<AdminBottle> bottleAdmin;
  final List<UserBottle> bottlePost;
  final Function() insertBottle;

  const InsertSeasoningAlert({Key? key, required this.itemAdmin, required this.bottleAdmin, required this.bottlePost, required this.insertBottle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorConst.background,
      title: const Column(
        children: [
          Text(
            '調味料を選択',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
        child: SizedBox(
          height: 50,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => Center(
              child: DropdownButton<AdminBottle>(
                underline: Container(), //下線なくす
                value: itemAdmin.selectedBottle,
                onChanged: (newValue) {
                  setState(() {
                    itemAdmin.selectedBottle = newValue;
                  });
                },
                items: bottleAdmin.map((bottle) {
                  return DropdownMenuItem<AdminBottle>(
                    value: bottle,
                    child: Text(bottle.admin_seasoning_name),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: bottleAdmin.isEmpty ? const Text('もう登録できる調味料はありません') : Container()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    if (itemAdmin.selectedBottle != null) {
                      AdminBottle selectedBottle = itemAdmin.selectedBottle!;

                      UserBottle newBottle = UserBottle(
                        seasoning_id: selectedBottle.admin_seasoning_id,
                        seasoning_name: selectedBottle.admin_seasoning_name,
                        tea_second: selectedBottle.admin_tea_second,
                      );

                      int id = itemAdmin.selectedBottle!.admin_seasoning_id;
                      String name = itemAdmin.selectedBottle!.admin_seasoning_name;
                      double tea = itemAdmin.selectedBottle!.admin_tea_second;

                      // 調味料を追加
                      _insertSeasoning(id, name, tea);
                      bottlePost.add(newBottle);

                      insertBottle();
                    }
                  },
                  icon: const Icon(
                    Icons.add_circle,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
    );
  }

  // userがセットした調味料を追加
  void _insertSeasoning(int seasoningId, String title, double tea) async {
    final dbHelper = DatabaseHelper.instance; // DBヘルパー
    Map<String, dynamic> row = {DatabaseHelper.seasoningId: seasoningId, DatabaseHelper.seasoningName: title, DatabaseHelper.teaSecond: tea};
    await dbHelper.insertSeasoning(row);
  }
}
