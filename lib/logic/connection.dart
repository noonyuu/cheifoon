import 'dart:io';
import 'dart:convert';

class connection {
  static Future<void> fetchDataFromRaspberryPi(String menuName, List<String> seasoningName, List<String> tableSpoon, List<String> teaSpoon) async {
    String seasoningInfo = '';
    for (int i = 0; i < seasoningName.length; i++) {
      seasoningInfo += '${seasoningName[i]},${tableSpoon[i]},${teaSpoon[i]}';
      if (i != seasoningName.length - 1) {
        seasoningInfo += ',';
      }
    }
    String date = '$menuName,$seasoningInfo';

    final socket = await Socket.connect('192.168.0.7', 8081);
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
      print('finsh');
      // サーバーからのデータを受信したらソケットを閉じる
      await socket.close();
    });
  }
}
