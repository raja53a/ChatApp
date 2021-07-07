import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pingme/helper/constants.dart';
import 'package:pingme/services/database.dart';
import 'package:pingme/views/conversationScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot searchSnapshot;
  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchTextEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .getUserByUsername(searchTextEditingController.text)
          .then((val) {
        searchSnapshot = val;
        print("$searchSnapshot");
        setState(() {
          isLoading = false;
          searchSnapshot = val;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget searchList() {
    return haveUserSearched
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                searchSnapshot.docs[index].data()["name"],
                searchSnapshot.docs[index].data()["email"],
              );
            })
        : Container();
  }

//create chatRoom, send user to conversation screen
  createChatroomAndStartConversation(String userName) {
    List<String> users = [userName, Constants.myName];
    String chatRoomId = getChatRoomId(userName, Constants.myName);
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomId": chatRoomId,
    };
    DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationScreen(
          chatRoomId,
        ),
      ),
    );
  }

  Widget searchTile(String userName, String userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
              ),
              Text(
                userEmail,
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Message",
              ),
            ),
          ),
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "PingMe",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x26d8d8d8),
              padding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 3,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Icon(Icons.search),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}
