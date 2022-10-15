import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invitation/screen/home.dart';
import 'dart:convert';
import 'package:invitation/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class IndexUndangan extends StatefulWidget {
  const IndexUndangan({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _IndexUndanganState();
  }
}

class _IndexUndanganState extends State<IndexUndangan> {
  final int _currentIndex = 0;
  bool isPerformingRequest = false;
  int pageNumber = 0;
  final scrollController = ScrollController(initialScrollOffset: 0);
  final ScrollController _scrollController = ScrollController();
  List<LUndangan> sinvitation = <LUndangan>[];

  @override
  void initState() {
    _getMoreData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<LUndangan>> _getDataInvitations() async {
    isPerformingRequest = true;
    List<LUndangan> arrundangan = <LUndangan>[];
    setState(() {
      pageNumber++;
    });
    final prefs = await SharedPreferences.getInstance();
    var istoken = prefs.getString('access_token');
    var map = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $istoken',
    };
    var data = {};
    final Uri restApiUrl = Uri.parse(
        "http://back-end.e-procurement.abdi.co.id/api/index-invitations?page=$pageNumber&per_page=6");

    http.Response response = await http.post(
      restApiUrl,
      headers: map,
      body: jsonEncode(data),
    );
    if (response.statusCode == 403) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }
    if (response.statusCode == 200) {
      var arr = json.decode(response.body);

      arr.forEach((itm) {
        arrundangan.add(LUndangan.fromJSON(itm));
      });
      isPerformingRequest = false;

      return arrundangan;
    } else {
      isPerformingRequest = false;
      // If that call was not successful, throw an error.
      if (kDebugMode) {
        print(response.statusCode);
      }
      return [];
    }
  }

  _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
      });
      List<LUndangan>? newEntries =
          (await _getDataInvitations()).cast<LUndangan>(); //returns empty list
      if (newEntries.isEmpty) {
        double edge = 50.0;
        double offsetFromBottom = _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          _scrollController.animateTo(
              _scrollController.offset - (edge - offsetFromBottom),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
      }
      setState(() {
        sinvitation.addAll(newEntries);
        isPerformingRequest = false;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: sinvitation.length + 1,
              itemBuilder: (context, index) {
                if (index == sinvitation.length) {
                  return _buildProgressIndicator();
                } else {
                  return Container(
                    decoration: const BoxDecoration(
                        border: Border(top: BorderSide(width: 2.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 5, right: 60),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 15.0, right: 10.0),
                                            child: Icon(
                                              Icons.people_alt_rounded,
                                              color: Colors.blueAccent,
                                              size: 40,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: RichText(
                                              text: TextSpan(
                                                  text: sinvitation[index]
                                                      .name
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 20)),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Row(
                                                children: <Widget>[
                                                  RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: sinvitation[index]
                                                            .mobile_no
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black38,
                                                            fontSize: 20)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 1.0),
                                              child: Row(
                                                children: <Widget>[
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Share.share(
                                                            'Tanpa mengurangi rasa hormat, perkenankan kami mengundang Bapak/Ibu/Saudara/i ${sinvitation[index].name.toString()} & partner untuk menghadiri acara kami.'
                                                            'Berikut link undangan kami, untuk info lengkap dari acara bisa kunjungi : '
                                                            'http://amir-midah-my-wedding.epizy.com/?code=${sinvitation[index].mobile_no.toString()}&name=${sinvitation[index].name}'
                                                            ' Merupakan suatu kebahagiaan bagi kami apabila Bapak/Ibu/Saudara/i berkenan untuk hadir dan memberikan doa restu.'
                                                            'Mohon maaf perihal undangan hanya di bagikan melalui pesan ini.'
                                                            'Terima kasih banyak atas perhatiannya.',
                                                            subject:
                                                                'Wedding Invitation');
                                                        //subject is optional, and it is required for Email App.
                                                      },
                                                      child: const Text(
                                                          "Share Text Link")),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Row(
                                                children: <Widget>[
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        DeleteInvitation(
                                                            sinvitation[index]
                                                                .id);
                                                      },
                                                      child:
                                                          const Text("Delete")),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void DeleteInvitation(id) async {
    final prefs = await SharedPreferences.getInstance();
    var istoken = prefs.getString('access_token');
    var map = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $istoken',
    };
    var data = {'invitation_id': id};
    final Uri restApiUrl = Uri.parse(
        "http://back-end.e-procurement.abdi.co.id/api/delete-invitations");

    http.Response response = await http.post(
      restApiUrl,
      headers: map,
      body: jsonEncode(data),
    );
    if (response.statusCode == 403) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
    }
  }
}

class LUndangan {
  final int id;
  final String name;
  final String mobile_no;

  LUndangan({required this.id, required this.name, required this.mobile_no});

  factory LUndangan.fromJSON(Map<String, dynamic> json) {
    return LUndangan(
        id: json['id'], name: json['name'], mobile_no: json['mobile_no']);
  }
}
