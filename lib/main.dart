import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sazikagen/page/home_page.dart';

void main() {
  //   debugPaintSizeEnabled = true; // ウィジェットの境界を表示
  // debugPaintLayerBordersEnabled = true; // レイヤーの境界を表示
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// // flutterからraspberry piにデータを送る
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Data Sender',
//       home: DataSender(),
//     );
//   }
// }

// class DataSender extends StatelessWidget {
//   TextEditingController messageController = TextEditingController();

//   Future<void> sendDataToRaspberryPi(String message) async {
//     const String raspberryPiUrl = 'http://192.168.0.20:5000/api/endpoint';
//     final Map<String, String> headers = {'Content-Type': 'application/json'};
//     final Map<String, dynamic> data = {'message': message, 'name': 'sazikagen'};

//     final response = await http.post(
//       Uri.parse(raspberryPiUrl),
//       headers: headers,
//       body: jsonEncode(data),
//     );

//     if (response.statusCode == 200) {
//       print('Data sent successfully');
//     } else {
//       print('Failed to send data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('raspberry'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: messageController,
//               keyboardType: TextInputType.multiline,
//               maxLines: null,
//               decoration: InputDecoration(labelText: 'なんか'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 String message = messageController.text;
//                 sendDataToRaspberryPi(message);
//               },
//               child: Text('送信'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'raspberry->flutter',
//       home: DataReceiver(),
//     );
//   }
// }

// class DataReceiver extends StatefulWidget {
//   @override
//   _DataReceiverState createState() => _DataReceiverState();
// }

// class _DataReceiverState extends State<DataReceiver> {
//   String receivedMessage = '何もなし';

//   Future<void> fetchDataFromRaspberryPi() async {
//     final String raspberryPiUrl = 'http://192.168.0.20:5000/api/send-data';
//     final response = await http.post(Uri.parse(raspberryPiUrl));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = jsonDecode(response.body);
//       setState(() {
//         receivedMessage = data['message'];
//       });
//     } else {
//       setState(() {
//         receivedMessage = '失敗';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('raspberry->flutter'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               '受け取ったメッセージ:',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 10),
//             Text(
//               receivedMessage,
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: fetchDataFromRaspberryPi,
//               child: Text('受信'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
