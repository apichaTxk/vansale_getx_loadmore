import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as Http;
import 'package:flutter/material.dart';
import 'package:vansale_getx_and_loadmoredata/connect_to_http.dart';
import 'package:get/get.dart';
import 'package:vansale_getx_and_loadmoredata/widget/detail_page.dart';

class DetailPage extends StatefulWidget {
  final int userId;

  const DetailPage({
    super.key,
    required this.userId,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  RxMap<String, dynamic> userDetail = <String, dynamic>{}.obs;

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  @override
  void dispose() {
    userDetail.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Page"),
      ),
      body: Center(
        child: Obx(() {
          if(userDetail.isEmpty) return Container();
          return Column(
            children: [
              Text(
                "${userDetail["data"]?["first_name"]}",
              ),
              Text(
                "${userDetail["data"]?["email"]}",
              ),
            ],
          );
        }),
      ),
    );
  }

  Future getUserDetail() async {
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://reqres.in/api/users/${widget.userId}");
    var response = await Http.get(url);
    userDetail.value = await json.decode(response.body);
  }
}
