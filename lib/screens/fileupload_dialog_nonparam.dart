import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

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



  void _showFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _uploadFile() async {
    if (_selectedFile == null) {
      return;
    }

    setState(() {
      _uploading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ip_address3+'api/v1/uploadflutter'),
      );

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _selectedFile!.path,
      ));

     // request.fields['id'] = '13.567';
     // request.fields['filename'] = '873';
      String? filePath = _selectedFile?.absolute.toString();
      String fileName = path.basename(filePath!);
      fileName = fileName.substring(0, fileName.length - 1);

     // request.fields['ID'] = widget.id;
      request.fields['ID'] = '55';
      request.fields['FileName'] = fileName;

      var response = await request.send();

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
          onPressed: _selectedFile != null && !_uploading ? _uploadFile : null,
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