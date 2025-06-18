import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatController extends GetxController {
  StreamController<String>? responseController;
  String _buffer = "";
  RxBool isSent = false.obs;
  RxBool isFileSelected = false.obs;
  final RxList<File> _files = <File>[].obs;

  void sendPrompt(List<Content> prompt) async {
    responseController = StreamController<String>();
    _buffer = "";
    responseController!.add(""); // Reset UI
    Stream<GenerateContentResponse> stream;
    final model = FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-pro');
    if(isFileSelected.value){
      final video = await  _files[0].readAsBytes();
      final videoPart = InlineDataPart("image/png", video);
      stream = model.generateContentStream([
        Content.multi([TextPart(jsonEncode(prompt[0].parts[0].toJson())), videoPart])
      ]);
    } else {
      stream = model.generateContentStream(prompt);
    }

    stream.listen((chunk) {
      final text = chunk.text ?? "";
      _buffer += text;
      responseController!.add(_buffer); // Emit the updated text
    }, onError: (e) {
      responseController!.add("Error: $e");
    }, onDone: () {
      responseController!.close();
    },);
  }

  Stream<String> get responseStream => responseController!.stream;

  // Pick files from the storage using file_picker before that ge tth permission for the storage
  Future<void> requestStoragePermission() async {
    // For apps targeting Android 13 or higher, request granular media permissions.
    // For older versions, request storage permission.
    
    // First, check the Android version
    final deviceInfo = await DeviceInfoPlugin().androidInfo;

    // Permissions to request
    late Map<Permission, PermissionStatus> statuses;

    if (deviceInfo.version.sdkInt >= 33) {
      // Request for video and photo permissions
      statuses = await [
        Permission.videos,
        Permission.photos,
      ].request();
    } else {
      // Request legacy storage permission
      statuses = await [
        Permission.storage,
      ].request();
    }

    // Handle the permission statuses
    var allGranted = true;
    statuses.forEach((permission, status) {
      if (!status.isGranted) {
        allGranted = false;
      }
    });

    if (allGranted) {
      pickImageFromGallery();
    } else {
      // At least one permission was denied
      // Optionally, open app settings if permissions are permanently denied
      if (await Permission.videos.isPermanentlyDenied || await Permission.photos.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }
  
  Future<List<File>> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    // Use .pickImage for images
    final List<XFile> pickedFiles = await picker.pickMultiImage();

    List<File> files = [];
    if(pickedFiles.isNotEmpty) {
      for (var file in pickedFiles) {
        files.add(File(file.path));
      }
      _files.value = files;
      isFileSelected = true.obs;
    }
    return files;
  }
}
