import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/global_constants.dart';

class FileUploadNonParamDialog extends StatefulWidget {

 // const FileUploadNonParamDialog({Key? key}) : super(key: key);
  const FileUploadNonParamDialog();

  @override
  _FileUploadNonParamDialogState createState() => _FileUploadNonParamDialogState();
}

class _FileUploadNonParamDialogState extends State<FileUploadNonParamDialog> {
  File? _selectedFile;
  bool _uploading = false;

  late SharedPreferences logindata;
  late String email="";
  late String token="";



  @override
  void initState() {
    super.initState();
    initial_state();
  }

  initial_state() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      //  token=logindata.getString('token')!;
      //  email=logindata.getString('email')!;
      token = logindata.getString('token') ?? '';
      email = logindata.getString('email') ?? '';
    });
    ////////////////////////////
    var url = Uri.parse(ip_address3+'api/v1/auth/profilepic');
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'email':email

    });
    try {
      var response = await http.post(url, headers: headers, body: body);
      print("test response");
      print(response.body);
      setState(() {
       // profilepicLink=ngrok+"/houses/"+response.body;
        logindata.setString("proLink",ngrok+"/houses/"+response.body);
        print("zvasetwa");
        //print(profilepicLink);
      });

    } catch (error) {
      print(error);
    }
   // print(profilepicLink);
    ////////////////////////////

  }



  void _showFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _uploadFile() async {
    print("tapinda mu method uoload");

    setState(() {
      _uploading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ip_address3+'api/v1/auth/uploadflutter'),
      );

      print("after request declare");
      print(token);
      request.headers['Authorization'] = token;
     // request.headers['Content-Type'] = 'application/json';
      request.headers['Content-Type'] = 'multipart/form-data';
      print("after request headers");

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _selectedFile!.path,
      ));
      print("after request file attach");
      print(_selectedFile!.path);

      String? filePath = _selectedFile?.absolute.toString();
      String fileName = path.basename(filePath!);
      fileName = fileName.substring(0, fileName.length - 1);

      request.fields['ID'] = 'r174145e@students.msu.ac.zw';
      request.fields['FileName'] = fileName;

      print("after request ====");

      var response = await request.send(); // Wait for the response
      print(response);
      if (response.statusCode == 200) {
        print('File uploaded successfully');
        Navigator.of(context).pop();
      } else {
        print('File upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  void xx()async{


    String filePath = _selectedFile!.path;
    String fileExtension = filePath!.split('.').last;
    final bytes = _selectedFile!.readAsBytesSync();
print('this is the file extension');
    final base64Image = base64Encode(bytes);
        var url = Uri.parse('http://192.168.100.16:8081/api/v1/auth/uploadflutter2');
        var headers = {'Content-Type': 'application/json'};
        var body = json.encode({
          'file_content':base64Image,
          'user_id':'dd',
          'ext':fileExtension
        });
    print('before post');
          var response = await http.post(url, headers: headers, body: body);
          print(response.body);
  }



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Upload File'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _selectedFile != null
                ? Text('Selected file: ${_selectedFile!.path}')
                : Text('No file selected'),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Select File'),
              style: ElevatedButton.styleFrom(
                // fixedSize: const Size(100,10),
                elevation: 10,
                backgroundColor: Colors.green,
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontStyle: FontStyle.normal),
              ),
              onPressed: _showFilePicker,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          child: Text('Cancel'),
          style: ElevatedButton.styleFrom(
           // fixedSize: const Size(100,10),
            elevation: 10,
            backgroundColor: Colors.blue,
            textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontStyle: FontStyle.normal),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: _uploading ? CircularProgressIndicator() : Text('Upload'),
          style: ElevatedButton.styleFrom(
            // fixedSize: const Size(100,10),
            elevation: 5,
            backgroundColor: Colors.blue,
            textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontStyle: FontStyle.normal),
          ),
          onPressed:(){
            print('upload is pressed');
           // _selectedFile != null && !_uploading ? _uploadFile : null;
            _uploadFile();
           // xx();
          } ,
         /* onPressed:(){
            print(_selectedFile?.absolute.toString());
            setState(() {
              _selectedFile != null && !_uploading ? _uploadFile : null;
            });

          },*/
        ),
      ],
    );
  }
}