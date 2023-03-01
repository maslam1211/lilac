// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class VideoDownloadButton extends StatefulWidget {
//   final String videoUrl;

//   VideoDownloadButton({required this.videoUrl});

//   @override
//   _VideoDownloadButtonState createState() => _VideoDownloadButtonState();
// }

// class _VideoDownloadButtonState extends State<VideoDownloadButton> {
//   bool _downloading = false;

//   Future<void> _downloadVideo() async {
//     setState(() {
//       _downloading = true;
//     });

//     final url = Uri.parse(widget.videoUrl);
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final storagePermission = await Permission.storage.request();
//       if (storagePermission.isGranted) {
//         final appDirectory = await getExternalStorageDirectory();
//         final videoFile = await appDirectory!.createFile('video.mp4');
//         await videoFile.writeAsBytes(response.bodyBytes);

//         setState(() {
//           _downloading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Video downloaded successfully'),
//         ));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Storage permission not granted'),
//         ));
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Failed to download video'),
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: _downloading ? null : _downloadVideo,
//       child: _downloading
//           ? CircularProgressIndicator()
//           : Text('Download Video'),
//     );
//   }
// }