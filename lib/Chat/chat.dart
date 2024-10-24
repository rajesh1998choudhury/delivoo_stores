// import 'package:cloud_firestore/cloud_firestore.dart';

// class Chat {
//   final String sender;
//   final String text;
//   final String docId;
//   final Timestamp time;
//   final bool isDelivered;

//   Chat(this.sender, this.text, this.time, this.isDelivered, {this.docId});

//   Chat.fromJson(Map<String, dynamic> json)
//       : sender = json['sender'],
//         text = json['text'],
//         time = json['time'],
//         isDelivered = json['isDelivered'] ?? false,
//         docId = json['docId'];

//   Map<String, dynamic> toJson() => {
//         'sender': sender,
//         'text': text,
//         'time': time,
//         'isDelivered': isDelivered,
//         'docId': docId,
//       };
// }
