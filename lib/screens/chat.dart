import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:appointmentapp/model/chart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
//widgets
import 'package:appointmentapp/api/api.dart';

import 'dart:convert';

class ChatPage extends StatefulWidget {
  final String username;
  final String receiver;
  const ChatPage({Key key, @required this.username, this.receiver})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String userid;
  Future<String> getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('id');
    print(">>><<<<");
    print(userJson);
    // var user = json.decode(userJson);
    // String userId = user['id'].toString();
    var user = json.decode(userJson);
    String userId = user['id'].toString();
    setState(() {
      userid = userJson;
    });
  }

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatModel> _messages = [];

  final bool _showSpinner = false;
  final bool _showVisibleWidget = false;
  final bool _showErrorIcon = false;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future<List<ChatModel>> fetchChatData() async {
    final response = await CallApi().getChatData();
    var body = json.decode(response.body);
    print("-------------BODY-----------------");
    print(body.runtimeType);
    List oldChatsss = [];
    for (var u in body) {
      oldChatsss.add(u);
    }
    print(oldChatsss);
    List<ChatModel> chat = [];
    for (int i = 0; i < oldChatsss.length; i++) {
      chat.add(ChatModel.fromJson(oldChatsss[i]));
    }
    return chat;
  }

  Socket socket;
  List<ChatModel> oldChats;
  Future<List<ChatModel>> _oldChats;

  @override
  void initState() {
    getUserInfo();
    super.initState();
    fetchChatData().then((value) {
      print(value);
      setStateIfMounted(() {
        oldChats = value;
        value.forEach((element) {
          if ((element.username == widget.receiver &&
                  element.receiver == widget.username) ||
              (element.username == widget.username &&
                  element.receiver == widget.receiver)) {
            print("condition match");
            setState(() {
              _messages.add(element);
            });
          }
        });
      });
    });
    try {
      socket = io("http://127.0.0.1:3000", <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
      });

      socket.connect();

      socket.on('connect', (data) {
        debugPrint('connected');
        print(socket.connected);
        _oldChats = fetchChatData();
      });

      socket.on('message', (data) {
        var message = ChatModel.fromJson(data);
        print(message.message);

        print(message.username);
        print(message.receiver);

        print(widget.username);
        print(widget.receiver);
        if ((message.username == widget.receiver &&
                message.receiver == widget.username) ||
            (message.username == widget.username &&
                message.receiver == widget.receiver)) {
          print("condition match");
          setState(() {
            _messages.add(message);
          });
        }
        // setStateIfMounted(() {
        //   _messages.add(message);
        // });
      });

      socket.onDisconnect((_) => debugPrint('disconnect'));
    } catch (e) {
      print(e);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Chat'),
          backgroundColor: Color.fromRGBO(88, 124, 202,1.0)),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFEAEFF2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    reverse: _messages.isEmpty ? false : true,
                    itemCount: 1,
                    shrinkWrap: false,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 3),
                        child: Column(
                          mainAxisAlignment: _messages.isEmpty
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: _messages.map((message) {
                                  return ChatBubble(
                                    date: message.sentAt,
                                    message: message.message,
                                    isMe: !(message.username ==
                                            widget.receiver &&
                                        message.receiver == widget.username),
                                  );
                                }).toList()),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                    bottom: 10, left: 20, right: 10, top: 5),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        child: TextField(
                          minLines: 1,
                          maxLines: 5,
                          controller: _messageController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration.collapsed(
                            hintText: "Type a message",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 43,
                      width: 42,
                      child: FloatingActionButton(
                        backgroundColor: Color.fromRGBO(88, 124, 202,1.0),
                        onPressed: () async {
                          if (_messageController.text.trim().isNotEmpty) {
                            String message = _messageController.text.trim();
                            print(widget.username);
                            print(widget.receiver);
                            socket.emit(
                                "message",
                                ChatModel(
                                        id: socket.id,
                                        message: message,
                                        username: widget.username,
                                        receiver: widget.receiver,
                                        sentAt: DateTime.now()
                                            .toLocal()
                                            .toString()
                                            .substring(0, 16))
                                    .toJson());

                            _messageController.clear();
                          }
                        },
                        mini: true,
                        child: Transform.rotate(
                            angle: 4.7,
                            child: const Icon(Icons.send, size: 20)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final String date;

  ChatBubble({
    Key key,
    this.message,
    this.isMe = true,
    this.date,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            constraints: BoxConstraints(maxWidth: size.width * .5),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFFE3D8FF) : const Color(0xFFFFFFFF),
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topRight: Radius.circular(11),
                      topLeft: Radius.circular(11),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(11),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(11),
                      topLeft: Radius.circular(11),
                      bottomRight: Radius.circular(11),
                      bottomLeft: Radius.circular(0),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  message ?? '',
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style:
                      const TextStyle(color: Color(0xFF00C569), fontSize: 14),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      date ?? '',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: Color(0xFE00B555), fontSize: 9),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
