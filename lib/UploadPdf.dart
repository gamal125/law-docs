// ignore_for_file: unused_local_variable, file_names

import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:docs/Componant/Componant.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
class UploadPdf extends StatefulWidget {
    UploadPdf({super.key});
  final List<String> path=['عقد البيع','عقد الشراء','عقد الايجار','عقد اتعاب محاماة','اخرى'];
  @override
  State<UploadPdf> createState() => _UploadPdfState();
}

class _UploadPdfState extends State<UploadPdf> {
  FilePickerResult? resultt;
  FilePickerResult? resultt2;
  FilePickerResult? resultt3;
TextEditingController name1=TextEditingController();
  TextEditingController name2=TextEditingController();
  TextEditingController name3=TextEditingController();
bool state=false;
int index=0;
  double progress = 0.0;
  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    ).then((value)  { setState(() {

      resultt=value;

    });


 return null;});
  }
  Future<void> _selectFile2() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    ).then((value) { setState(() {

      resultt2=value;
    });
    return null;});
  }
  Future<void> _selectFile3() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    ).then((value) { setState(() {

      resultt3=value;

    });
    return null;});
  }
  String? downloadurl;
  String? downloadurl2;
  String? downloadurl3;

  Future<void> upload(String name,FilePickerResult? result)async {

      if (result != null) {
        PlatformFile file = result.files.first;
        File fileData = File(file.path!);
        Uint8List?  bytes = await fileData.readAsBytes();
        if (bytes.isNotEmpty) {
        Reference ref = FirebaseStorage.instance.ref().child(
            'pdf/${file.name}');

        UploadTask uploadTask = ref.putData(bytes);
        // Wait for the upload to complete and get download URL
        await uploadTask.whenComplete(() async {

          ref.getDownloadURL().then((value) {


              FirebaseFirestore.instance.collection('العقود').doc('الكل').collection('الكل').doc(name).set({'name':name,'url':value,'date':DateTime.now().toString()});
              FirebaseFirestore.instance.collection('العقود').doc(widget.path[index]).collection(widget.path[index]).doc(name).set({'name':name,'url':value,'date':DateTime.now().toString()});




            setState(() {
              downloadurl=value;

            });

          });

        });

      }
      }
      else {
        // User canceled the picker
      }

    //////// بختار المسار اللي هيتحفظ فيه من القائمهلو مش 0 هينفز مرتين  و لو ب 0 هينفذ الداله مره واحده
  }
  @override
  void initState(){
    super.initState();

  }
  @override
  Widget build(BuildContext context) {


    return  Scaffold(
        appBar: AppBar(title: const Center(child: Text('اضافة ملف')),actions: const [],backgroundColor:  HexColor('#EAEEFA'),),
      body: GestureDetector(
        onTap:(){
          FocusScope.of(context).unfocus();},
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.height*0.65,
              child: ListView(
                children: [
                  const SizedBox(height: 10,),
                  InkWell(onTap: (){
          
                    AwesomeDialog(
                      body:    Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                          const Text('اسم الملف'),
                            const SizedBox(height: 20,),
                            TextFormField(
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              controller: name1,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'برجاء إدخال اسم الملف';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(borderSide: const BorderSide(width: 1),borderRadius: BorderRadius.circular(25)),
                                hintText: '',
                                hintTextDirection: TextDirection.rtl,
                                labelText: 'اسم الملف',
                              ),
                            ),
                          ],
                        ),
                      ),
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
          
                      btnCancelOnPress: () {
          
                      },
                      btnCancelText: 'رجوع',
                      btnOkText: 'متابعه',
                      btnOkOnPress: () {
          
                          if(name1.text.isNotEmpty){
          
                            _selectFile();
                          }else{
                            showToast(text: 'ادخل اسم العقد', state: ToastStates.error);
                          }
          
                      },
                    ).show();
          
                  }, child: Container(
                    width: MediaQuery.of(context).size.width*0.6,
                    height: MediaQuery.of(context).size.height*0.15,
                    padding: const EdgeInsets.all(5), decoration:
                  BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.blue,width: 2)
                  ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.5,
                          height: MediaQuery.of(context).size.height*0.1,
                          decoration:   const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/upload.png')),
          
                          ),
                        ),           resultt!=null?Text(resultt!.names.first!): const Text('اضغط لرفع الملف الاول',style: TextStyle(color: Colors.blue),),
                      ],),
                  )),
                  const SizedBox(height: 10,),
                  InkWell(onTap: (){
                    AwesomeDialog(
                      body:    Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            const Text('اسم الملف'),
                            const SizedBox(height: 20,),
                            TextFormField(
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              controller: name2,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'برجاء إدخال اسم الملف';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(borderSide: const BorderSide(width: 1),borderRadius: BorderRadius.circular(25)),
                                hintText: '',
                                hintTextDirection: TextDirection.rtl,
                                labelText: 'اسم الملف',
                              ),
                            ),
                          ],
                        ),
                      ),
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
          
                      btnCancelOnPress: () {
          
                      },
                      btnCancelText: 'رجوع',
                      btnOkText: 'متابعه',
                      btnOkOnPress: () {
          
                        if(name2.text.isNotEmpty){
          
                          _selectFile2();
                        }else{
                          showToast(text: 'ادخل اسم العقد', state: ToastStates.error);
                        }
          
                      },
                    ).show();
          
                  }, child: Container(
                    width: MediaQuery.of(context).size.width*0.6,
                    height: MediaQuery.of(context).size.height*0.15,
                    padding: const EdgeInsets.all(5), decoration:
                  BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.blue,width: 2)
                  ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.5,
                          height: MediaQuery.of(context).size.height*0.1,
                          decoration:   const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/upload.png')),
          
                          ),
                        ),
                        resultt2!=null?Text(resultt2!.names.first!):
                        const Text(' اضغط لرفع الملف الثاني',style: TextStyle(color: Colors.blue),),
                      ],),
                  )),
                  const SizedBox(height: 10,),
                  InkWell(onTap: (){
                    AwesomeDialog(
                      body:    Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            const Text('اسم الملف'),
                            const SizedBox(height: 20,),
                            TextFormField(
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              controller: name3,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'برجاء إدخال اسم الملف';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(borderSide: const BorderSide(width: 1),borderRadius: BorderRadius.circular(25)),
                                hintText: '',
                                hintTextDirection: TextDirection.rtl,
                                labelText: 'اسم الملف',
                              ),
                            ),
                          ],
                        ),
                      ),
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
          
                      btnCancelOnPress: () {
          
                      },
                      btnCancelText: 'رجوع',
                      btnOkText: 'متابعه',
                      btnOkOnPress: () {
          
                        if(name3.text.isNotEmpty){
          
                          _selectFile3();
                        }else{
                          showToast(text: 'ادخل اسم العقد', state: ToastStates.error);
                        }
          
                      },
                    ).show();
          
                  }, child: Container(
                    width: MediaQuery.of(context).size.width*0.6,
                    height: MediaQuery.of(context).size.height*0.15,
                    padding: const EdgeInsets.all(5), decoration:
                  BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.blue,width: 2)
                  ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.5,
                          height: MediaQuery.of(context).size.height*0.1,
                          decoration:   const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/upload.png')),
          
                          ),
                        ),
                        resultt3!=null?Text(resultt3!.names.first!):const Text('اضغط لرفع الملف الثالث',style: TextStyle(color: Colors.blue),),
                      ],),
                  )),
                ],
              ),
            ),
              resultt!=null?Text(resultt!.names.first!):const SizedBox(),
              resultt2!=null?Text(resultt2!.names.first!):const SizedBox(),
              resultt3!=null?Text(resultt3!.names.first!):const SizedBox(),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width*0.7,
                decoration: BoxDecoration(
          
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.grey[200],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<int>(
                  value: index,
                  isExpanded: true,
                  onChanged: (int? newIndex) {
                    setState(() {
                      index = newIndex!;
                    });
                  },
                  items: widget.path.asMap().entries.map<DropdownMenuItem<int>>((entry) {
                    int index = entry.key;
                    String value = entry.value;
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          !state ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: (){
                  setState(() {
                    state=true;
                  });
                  uploadall(name1.text,name2.text,name3.text);




                },
                child: Container(
                  width: MediaQuery.of(context).size.width*0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.blue,width: 2),
                      color: Colors.blue

                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: Text('رفع',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
          ):
          const SpinKitCircle(color: Colors.blue,)
          
          
          ],),
        ),
      )
    );
  }


Future<void> uploadall(String name,String name2,String name3,)async{


    if(resultt==null&&resultt2==null&&resultt3==null){
setState(() {
  state=false;
});
      showToast(text: 'اختر ملف اولا', state: ToastStates.error);

  }else{
      if(resultt!=null){

        upload(name,resultt);






      }
      if(resultt2!=null){

        upload(name2,resultt2);
      }
      if(resultt3!=null){

        upload(name3,resultt3);



      }
      showToast(text: 'جاري رفع العقود', state: ToastStates.success);

      Future.delayed(const Duration(seconds: 6)).then((value) {
        setState(() {
          state=false;

          showToast(text: 'تم رفع العقود', state: ToastStates.success);
          Navigator.pop(context);
          // navigateAndFinish(context, MainScreen());
        });
      });

    }

}
}
