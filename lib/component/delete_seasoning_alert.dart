import 'package:flutter/material.dart';

import '../db/database_helper.dart';

class AlertDialogs extends StatelessWidget {
  final String bottleTitle; // bottleTitleフィールド
  final int bottleId; // bottleIdフィールド
  final Function onDeletePressed; // onDeletePressedフィールド

  const AlertDialogs({
    required this.bottleTitle,
    required this.bottleId,
    required this.onDeletePressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('$bottleTitleを削除します',
          textAlign: TextAlign.center, // テキストを中央揃え
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          )),
      content: const Column(
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
          child: const Text('いいえ'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: GestureDetector(
            child: const Text(
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
