import 'dart:io';
import 'dart:convert';

class connection {
  static Future<void> fetchDataFromRaspberryPi(
      String menuName,
      List<String> seasoningId,
      List<String> seasoningName,
      List<String> tableSpoon,
      List<String> teaSpoon) async {
    String seasoningInfo = '';
    for (int i = 0; i < seasoningName.length; i++) {
      if (tableSpoon[i] != "0") {
        seasoningInfo += '${seasoningName[i]},1,${tableSpoon[i]}';
      }
      if (teaSpoon[i] != "0") {
        seasoningInfo += '${seasoningName[i]},0,${teaSpoon[i]}';
      }
      // カレー,醤油,0,1,ウスターソース,1,1
      // seasoningInfo += '${seasoningName[i]},1,${tableSpoon[i]},0,${teaSpoon[i]}';
      if (i != seasoningName.length - 1) {
        seasoningInfo += ',';
      }
    }
    String date = '$menuName,$seasoningInfo';
    // String date = 'カレー,醤油,0,1,ウスターソース,1,1';

    // final socket = await Socket.connect('192.168.179.49', 8081);
    // final socket = await Socket.connect('10.200.2.136', 8081);
    final socket = await Socket.connect('192.168.179.45', 8081);
    String message = date;

    // サーバーへデータを送信
    socket.write(message);
    await socket.flush();

    // サーバーからのレスポンスを受け取る
    List<int> receivedData = [];
    socket.listen((data) {
      receivedData.addAll(data);
    }).onDone(() async {
      String receivedMessage = utf8.decode(receivedData);
      sleep(Duration(seconds: 5));
      // サーバーからのデータを受信したらソケットを閉じる
      print(utf8.decode(receivedData));
      await socket.close();
    });
  }
}
