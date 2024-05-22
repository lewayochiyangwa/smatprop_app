import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smatprop/constants/global_constants.dart';
import 'package:smatprop/screens/pricing.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'fileupload_dialog.dart';
import 'fileupload_dialog_nonparam.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


//===========================================

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
        Uri.parse('http://192.168.100.27:8091/server/uploadflutter'),
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

    //  request.fields['ID'] = widget.id;
      request.fields['ID'] = '2';
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

//==============================
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(color: Colors.white54,
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),

                const SizedBox(
                  height: 15,
                ),
               const SizedBox(
                  height: 15,
                ),
                Container(
                  child: Expanded(
                      child: ListView(
                        children: [
                          imageProfile(),
                          SizedBox(
                            height: 20,
                          ),
                          Center(child: Text("Change Profile Picture",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            child: Card(
                              margin:
                              const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                              color:ThemeColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: const ListTile(
                                leading: Icon(
                                  Icons.privacy_tip_sharp,
                                  color: ThemeColor2,
                                ),
                                title: Text(
                                  'Upgrade To Premium',
                                  style: TextStyle(
                                      fontSize: 18,color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color:ThemeColor2,
                                ),
                              ),
                            ),
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PricingPlatform(),
                                ),
                              );

                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          Card(
                            color: ThemeColor,
                            margin:
                            const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: const ListTile(
                              leading: Icon(
                                Icons.privacy_tip_sharp,
                                color: ThemeColor2,
                              ),
                              title: Text(
                                'Join WhatsApp Group',
                                style: TextStyle(
                                    fontSize: 18,color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios_outlined,color: ThemeColor2,),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            color:ThemeColor,
                            margin:
                            const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: const ListTile(
                              leading: Icon(
                                Icons.add_reaction_sharp,
                                color:ThemeColor2,
                              ),
                              title: Text(
                                'Help & Support',
                                style: TextStyle(
                                    fontSize: 18,color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color:ThemeColor2,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            color:ThemeColor,
                            margin:
                            const EdgeInsets.only(left: 35, right: 35, bottom: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: const ListTile(
                              leading: Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                              title: Text(
                                'Logout',
                                style: TextStyle(
                                    fontSize: 18,color:Colors.red, fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios_outlined,color: Colors.red,),
                            ),
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
        ));
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
      /*  CircleAvatar(
          radius: 80.0,
          backgroundImage: _imageFile == null
              ? AssetImage("assets/profile.jpeg")
              : FileImage(File(_imageFile.path)),
        ),*/
        CircleAvatar(
          radius: 80.0,
          backgroundImage: AssetImage("assets/images/logo.png"),
        ),

        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () async{
              print("lets upload");

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return FileUploadNonParamDialog();
                },
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }
}