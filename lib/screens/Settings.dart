import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smatprop/constants/global_constants.dart';
import 'package:smatprop/screens/pricing.dart';
import 'dart:io';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


//===========================================
  //List<CameraDescription>? cameras; //list out the camera available
  //CameraController? controller; //controller for camera
  XFile? image2; //for captured image
  bool photo = false;
  bool upload = false;

  bool callback = false;
bool _imageSelected = false;

  String? _base64Image;

  File ? _selectedImage;
  /*Future _pickImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(()  {
        _selectedImage = File(pickedImage!.path);
        upload = true;
      });
    }
  }*/
  File? image;
  Future<void> _pickImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _imageSelected = true;
      });
    }
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);if(image == null) return;final imageTemp = File(image.path);setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
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
             //  _pickImageFromGallery;();
              pickImage();
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