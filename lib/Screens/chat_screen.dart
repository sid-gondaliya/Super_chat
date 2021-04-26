import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String messagetext;
  final cleartext = TextEditingController();
  final String sender = FirebaseAuth.instance.currentUser.email;
  int senderid;
  Map idtest = {};
  String chatid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userid();
  }

  void userid() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: sender)
        .get()
        .then((value) {
      idtest = value.docs.single.data();

      setState(() {
        senderid = idtest['user-id'];
      });
    });
  }

  /* Widget Messagesget(String id) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat/$id/messages')
          .orderBy('createAt')
          .snapshots(),
      builder: (context, streamsnapshot) {
        if (streamsnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          );
        }
        final chat = streamsnapshot.data.docs;
        return Expanded(
          child: ListView.builder(
              controller: _controller,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: chat.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Bubble(
                    text: chat[index]['text'],
                    sender: chat[index]['sender'],
                    isMe: sender == chat[index]['sender'],
                    time: chat[index]['createAt'],
                  ),
                );
              }),
        );
      },
    );
  } */

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context).settings.arguments as Map;

    var reciverid = data['id'];
    String url = data['image'];
    String name = data['username'];

    if (senderid != null) {
      if (senderid < reciverid) {
        chatid = '$senderid' + '_' + '$reciverid';
      }
      if (reciverid < senderid) {
        chatid = '$reciverid' + '_' + '$senderid';
      }
    }

    return (chatid != null)
        ? Scaffold(
            appBar: AppBar(
              title: FittedBox(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(url),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(name),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Messages(chatid),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: cleartext,
                            onChanged: (value) {
                              messagetext = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'Enter your message',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.send,
                              size: 33,
                            ),
                            onPressed: () {
                              Timestamp time = Timestamp.now();
                              String mid = '$time';
                              if (messagetext != null) {
                                FirebaseFirestore.instance
                                    .collection('chat/$chatid/messages')
                                    .doc(mid)
                                    .set({
                                  'text': messagetext,
                                  'sender': sender,
                                  'createAt': time,
                                });
                              }
                              cleartext.clear();
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}

class Messages extends StatelessWidget {
  String id;

  Messages(this.id);

  User loggeduser = FirebaseAuth.instance.currentUser;

  bool isMe = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat/$id/messages')
          .orderBy('createAt', descending: true)
          .snapshots(),
      builder: (context, streamsnapshot) {
        if (streamsnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          );
        }
        final chat = streamsnapshot.data.docs;
        return Expanded(
          child: ListView.builder(
              reverse: true,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: chat.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    child: Bubble(
                      text: chat[index]['text'],
                      sender: chat[index]['sender'],
                      isMe: loggeduser.email == chat[index]['sender'],
                      time: chat[index]['createAt'],
                    ),
                    onLongPress: () {
                      return (loggeduser.email == chat[index]['sender'])
                          ? showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13)),
                                title: const Text(
                                  'Are you sure?',
                                  style: TextStyle(fontSize: 20),
                                ),
                                content: const Text(
                                  'Do you want to delete message!',
                                  style: TextStyle(fontSize: 18),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text(
                                      'No',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      String mid =
                                          chat[index]['createAt'].toString();
                                      await FirebaseFirestore.instance
                                          .collection('chat/$id/messages')
                                          .doc(mid)
                                          .delete()
                                          .then((value) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                duration: Duration(
                                                    milliseconds: 1000),
                                                padding: EdgeInsets.all(8),
                                                content: Text(
                                                  'Message Deleted',
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                backgroundColor: Colors.black));
                                      });
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : null;
                    },
                  ),
                );
              }),
        );
      },
    );
  }
}

class Bubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  final Timestamp time;
  Bubble({this.text, this.sender, this.isMe, this.time});

  @override
  Widget build(BuildContext context) {
    DateTime date = time.toDate();
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat.yMMMMd('en_US').add_jm().format(date),
          style: TextStyle(
            color: Colors.grey,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        Material(
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0))
              : BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
          elevation: 5.0,
          color: isMe ? Colors.redAccent : Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
