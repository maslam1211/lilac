import 'dart:io';

import 'package:dio/dio.dart';

import 'dart:io' as io;
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:lilac_project/encrypt.dart';
import 'package:lilac_project/login_otp/login_screen.dart';
import 'package:lilac_project/profile_screen/profile_screen.dart';
import 'package:lilac_project/register_screen/register_screen.dart';
import 'package:lilac_project/shared_preference/provider/dark_theme.dart';
import 'package:lilac_project/utilities/dark_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'login_otp/login_otp_screen.dart';
import 'package:http/http.dart' as http;

class VedioPlayerScreen extends StatefulWidget {
  @override
  _VedioPlayerScreenState createState() => _VedioPlayerScreenState();
}
//  late String directory;

class _VedioPlayerScreenState extends State<VedioPlayerScreen> {
  String fileurl = "https://www.fluttercampus.com/video.mp4";

  late VideoPlayerController controller;
  bool _isMuted = false;
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> downloadVideo(String url, String filename) async {
    final appDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDir.path}/$filename.mp4';

    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    // Show a message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Video downloaded successfully'),
      ),
    );
  }

  // void downloadVideo(String url) async {
  //   final taskId = await FlutterDownloader.enqueue(
  //     url: url,
  //     savedDir: 'path/to/download/directory',
  //     showNotification: true,
  //     openFileFromNotification: true,
  //   );
  // }

  late String directory;
  var filesList = [];

  void _listofFiles() async {
    directory = "/storage/emulated/0/Android/data/"; //Give your folder path
    setState(() {
      filesList = io.Directory("$directory/resume/")
          .listSync(); //use your folder name insted of resume.
      print(filesList);
    });
  }

  @override
  void initState() {
    _listofFiles();
    loadVideoPlayer();
    secureScreen();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  loadVideoPlayer() {
    controller = VideoPlayerController.network(
        'https://www.fluttercampus.com/video.mp4');

    controller.setLooping(true);
    controller.addListener(() {
      setState(() {});
    });
    controller.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Ldrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black12,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: Container(
                height: 20,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black12,
                ),
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
          )
        ],
      ),
      body: Container(
          child: Column(children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
            Positioned(
              bottom: 15,
              child: Row(
                children: [
                  Container(
                    child: Row(
                      children: [
                        IconButton(
                          iconSize: 20,
                          onPressed: () {
                            if (controller.value.isPlaying) {
                              controller.pause();
                            } else {
                              controller.play();
                            }

                            setState(() {});
                          },
                          icon: Icon(
                              controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 50,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      width: 250,
                      child: VideoProgressIndicator(controller,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            backgroundColor: Colors.redAccent,
                            playedColor: Colors.green,
                            bufferedColor: Colors.purple,
                          ))),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    //duration of video
                    child: Text(
                      "" + controller.value.duration.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -9,
              left: 50,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    final newPosition =
                        controller.value.position + Duration(seconds: 10);
                    controller.seekTo(newPosition);
                  });
                },
                icon: Icon(Icons.skip_previous_rounded, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: -9,
              left: 90,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    final newPosition =
                        controller.value.position - Duration(seconds: 10);
                    controller.seekTo(newPosition);
                  });
                },
                icon: Icon(Icons.skip_next, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: -9,
              left: 130,
              child: IconButton(
                icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white),
                onPressed: () {
                  setState(() {
                    _isMuted = !_isMuted;
                    controller.setVolume(_isMuted ? 0 : 1);
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black12,
                ),
                child: Icon(
                  Icons.arrow_back,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // downloadVideo(
                //     'https://www.fluttercampus.com/video.mp4', 'myvideo');
                downloadVideo(
                    'https://www.fluttercampus.com/video.mp4', 'myvideo');
                _listofFiles();
                encryptFile("file.mp4");
              },
              child: Text("Download File."),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black12,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        Expanded(
          child: ListView.builder(
              itemCount: filesList.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(filesList[index].toString());
              }),
        )
      ])),
    );
  }
}

class Ldrawer extends StatelessWidget {
  const Ldrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Stack(
      children: [
        SizedBox(
          width: 327,
          height: 846,
          child: Drawer(
            backgroundColor: Colors.greenAccent,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 50,
                        child: ListTile(
                          leading: Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                          title: Text(
                            "Login ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register()));
                          },
                          minLeadingWidth: 1,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: ListTile(
                          leading: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          title: Text(
                            "My Profile",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          minLeadingWidth: 1,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen()));
                          },
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Settings",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        minLeadingWidth: 1,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DarkThemeScreen()));
                        },
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  child: Column(
                    children: [
                      Icon(
                        Icons.power_settings_new,
                        color: Colors.amber,
                        size: 20,
                        shadows: [
                          Shadow(
                              color: Colors.black26,
                              offset: Offset(1, 2),
                              blurRadius: 5),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Log Out",
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(
                                  color: Colors.black26,
                                  offset: Offset(-1, 3),
                                  blurRadius: 5),
                            ]),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
                SizedBox(
                  height: 85,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
