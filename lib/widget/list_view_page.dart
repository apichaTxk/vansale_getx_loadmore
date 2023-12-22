import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as Http;
import 'package:flutter/material.dart';
import 'package:vansale_getx_and_loadmoredata/connect_to_http.dart';
import 'package:get/get.dart';
import 'package:vansale_getx_and_loadmoredata/widget/detail_page.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({Key? key}) : super(key: key);

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  RxMap<String, dynamic> pageList = <String, dynamic>{}.obs;
  RxList<dynamic> userList = <dynamic>[].obs;

  final ScrollController _scrollController = ScrollController();

  int page = 1;

  @override
  void initState() {
    super.initState();
    getUserList();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    pageList.close();
    userList.close();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      page++;
      getUserList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List View Page"),
      ),
      body: Obx(() {
        return ListView.builder(
          controller: _scrollController,
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 150,
              child: ListTile(
                title: Text(userList[index]["first_name"]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        userId: userList[index]["id"],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }

  Future getUserList() async {
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://reqres.in/api/users?page=$page");
    var response = await Http.get(url);
    pageList.value = await json.decode(response.body);
    if (pageList.isEmpty) return;
    userList.addAll(pageList["data"].toList());
  }
}
