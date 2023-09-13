import 'package:flutter/material.dart';

import '../db/database_helper.dart';

class AlertDialogs extends StatelessWidget {
  final String bottleTitle; // bottleTitle をフィールドとして追加
  final int bottleId; // bottleId をフィールドとして追加
  final Function onDeletePressed; // onDeletePressed をフィールドとして追加

  const AlertDialogs({
    required this.bottleTitle, // コンストラクタで bottleTitle を受け取る
    required this.bottleId, // コンストラクタで bottleId を受け取る
    required this.onDeletePressed, // コンストラクタで onDeletePressed を受け取る
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('$bottleTitleボトルを削除しますか？',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '本当に削除しますか？',
            textAlign: TextAlign.center, // テキストを中央揃え
          ),
          SizedBox(height: 8),
          Text('※関連するレシピも削除されます。',
              textAlign: TextAlign.center, // テキストを中央揃え
              style: TextStyle(
                fontSize: 12,
              )),
        ],
      ),
      actions: <Widget>[
        GestureDetector(
          child: Text('いいえ'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: GestureDetector(
            child: Text(
              'はい',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onTap: () async {
              await _deleteBottle(bottleId); // _deleteBottle の完了を待つ
              onDeletePressed();
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }

  Future<void> _deleteBottle(int bottleId) async {
    await DatabaseHelper.instance.deleteBottle(bottleId);
  }
}
