// ignore_for_file: file_names

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../pdfViewer.dart';
import '../textViewer.dart';

void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => widget,
  ),
);
void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (_) => widget,
  ),
      (route) => false,
);
    Widget itemSystem(var size)=>  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15.0),
  child: Container(
      height: size.height*0.1,

      alignment: AlignmentDirectional.centerEnd,

      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.white,width: 2)),
      child:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            Text('النظام الاساسي للحكم',style: TextStyle(color: Colors.white,fontSize: size.width*0.04),),
            const SizedBox(width: 10,),
            const Icon(Icons.data_usage,color: Colors.white,),
          ],
        ),
      )),
);
    Widget systemItem(var size,String link,String section,String text, QueryDocumentSnapshot<Object?> doc,BuildContext context,bool admin,String serch,TextEditingController textEditingController ,var formKey2)=>  Padding(
      padding:  EdgeInsets.symmetric(horizontal: size.width*0.06),
      child: InkWell(
        onLongPress: (){
          textEditingController.text=text;
          admin?   AwesomeDialog(
            body:    Form(
              key: formKey2,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    const Text('تعديل الاسم'),
                    const SizedBox(height: 20,),
                    TextFormField(
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      controller: textEditingController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'برجاء إدخال الاسم';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(borderSide: const BorderSide(width: 1),borderRadius: BorderRadius.circular(25)),

                        hintTextDirection: TextDirection.rtl,
                        labelText: 'اسم الماده',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,

            btnCancelOnPress: () {

            },
            btnCancelText: 'لا',
            btnOkText: 'نعم',
            btnOkOnPress: () async{
          Map<String,dynamic>? x;

          if(textEditingController.text!=text){
          if(formKey2.currentState!.validate()){
          await FirebaseFirestore.instance.collection(section).doc(doc.id).collection(doc.id).doc(doc.id).get().then((value) {
          x=value.data() ;
          FirebaseFirestore.instance.collection(section).doc(textEditingController.text).set({'text':doc['text']}).then((value) {
          FirebaseFirestore.instance.collection(section).doc(textEditingController.text).collection(textEditingController.text).doc(textEditingController.text).set({"text":x!['text']}).then((value) {
          FirebaseFirestore.instance.collection(section).doc(doc.id).collection(doc.id).doc(doc.id).delete();
          FirebaseFirestore.instance.collection(section).doc(doc.id).delete().then((value) {
          showToast(text: "تم تعديل الاسم", state: ToastStates.success);});});});});


          }else{
          showToast(text: 'يجب إدخال اسم اولا', state: ToastStates.error);
          }
          }else{
            showToast(text: 'يجب تعديل اسم اولا', state: ToastStates.warning);
          }
            },
          ).show():null;
        },
        onTap: (){
    Map<String,dynamic>? x;

        FirebaseFirestore.instance.collection(section).doc(doc.id).collection(doc.id).doc(doc.id).get().then((value) {
          x=value.data() ;

         navigateTo(context, TextViewer(name: doc['text'],id:doc.id, section: section, edit: x!['text'],));
        }).catchError((error){
          navigateTo(context, TextViewer(name: doc['text'],id:doc.id, section: section, edit: '',));
        });

        },
        child: Card(
          shadowColor: Colors.grey[500],
          surfaceTintColor: HexColor('#FFFFFF'),
          elevation: 4,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                admin?        Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(onPressed: (){AwesomeDialog(
                      body:    const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                          Text('هل انت متاكد من حذف النص'),
                            SizedBox(height: 20,),

                          ],
                        ),
                      ),
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,

                      btnCancelOnPress: () {

                      },
                      btnCancelText: 'لا',
                      btnOkText: 'نعم',
                      btnOkOnPress: () {
                        FirebaseFirestore.instance.collection(section).doc(doc.id).collection(doc.id).doc(doc.id).delete().then((value) {
                  FirebaseFirestore.instance.collection(section).doc(doc.id).delete().catchError((error){
                    showToast(text: 'تحقق من اتصال الانترنت', state: ToastStates.error);
                  });

                  },
                    ).catchError((error){
                          showToast(text: 'تحقق من اتصال الانترنت', state: ToastStates.error);
                        });
                      }).show();}, icon: const Icon(Icons.delete_forever,color: Colors.red,)),):const Icon(Icons.arrow_back_ios),


                Expanded(
                  child: Column(
                    children: [
                      Text(text,style: TextStyle(color: Colors.black,fontSize: size.width*0.04,overflow: TextOverflow.clip),maxLines: 1,),
                     serch.isNotEmpty&& doc['text'].contains(serch)? Text( doc['text'].substring( doc['text'].indexOf(serch)),style: TextStyle(color: Colors.grey,fontSize: size.width*0.03),maxLines: 1,):const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                Image.asset(
                  link, // Replace 'my_icon.png' with your PNG image path
                  width: 40, // Adjust the width as needed
                  height: 40, fit: BoxFit.scaleDown,// Adjust the height as needed
                ),
              ],
            ),
          ),
        ),
      ),
    );
    Widget systemItemMain(var size,String link,String section,String text, QueryDocumentSnapshot<Object?> doc,BuildContext context)=>  Padding(
      padding:  EdgeInsets.symmetric(horizontal: size.width*0.06),
      child: InkWell(
        onTap: (){
          Map<String,dynamic>? x;

          FirebaseFirestore.instance.collection(section).doc(doc.id).collection(doc.id).doc(doc.id).get().then((value) {
            x=value.data() ;
            navigateTo(context, TextViewer(name: doc['text'],id:doc.id, section: section, edit: x!['text'],));
          }).catchError((error){
            navigateTo(context, TextViewer(name: doc['text'],id:doc.id, section: section, edit: '',));
          });

        },
        child: Card(
          shadowColor: Colors.grey[500],
          surfaceTintColor: HexColor('#FFFFFF'),
          elevation: 4,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
           const Icon(Icons.arrow_back_ios),


                Expanded(child: Text(text,style: TextStyle(color: Colors.black,fontSize: size.width*0.040,),maxLines: 1,overflow: TextOverflow.clip,textAlign: TextAlign.end,)),
                const SizedBox(width: 10,),
                Image.asset(
                  link, // Replace 'my_icon.png' with your PNG image path
                  width: 40, // Adjust the width as needed
                  height: 40, fit: BoxFit.scaleDown,// Adjust the height as needed
                ),
              ],
            ),
          ),
        ),
      ),
    );
    Widget contractItem(var size,String name,String link,String imagePath,context,bool admin,List<String>names,)=>  Padding(
      padding:  EdgeInsets.symmetric(horizontal: size.width*0.07),
      child: InkWell(


        onTap: (){

         download(name,link,context);
        },
        child: Card(
          shadowColor: Colors.grey[500],
          surfaceTintColor: HexColor('#FFFFFF'),
          elevation: 4,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                admin? IconButton(onPressed:(){
                  AwesomeDialog(
                    body:    const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Text('هل انت متاكد من حذف الملف'),
                          SizedBox(height: 20,),

                        ],
                      ),
                    ),
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,

                    btnCancelOnPress: () {
    Navigator.pop(context);
                    },
                    btnCancelText: 'لا',
                    btnOkText: 'نعم',
                    btnOkOnPress: () {

                        for (var element in names) {
                          FirebaseFirestore.instance.collection('العقود').doc(element).collection(element).doc(name).delete();


                        }

                    },
                  ).show();


                },icon: const Icon( Icons.delete_forever,color: Colors.red,)):   IconButton(icon:const Icon( Icons.download_rounded,color: Colors.blue,), onPressed: () {

        downloadPdf(link, context);
      },),
                const SizedBox(width: 10,),
                Expanded(child: Text(name,style: TextStyle(color: Colors.black,fontSize: size.width*0.040),maxLines: 1,textAlign: TextAlign.center,)),
                const SizedBox(width: 10,),

                Image.asset(
                  imagePath, // Replace 'my_icon.png' with your PNG image path
                  width: 40, // Adjust the width as needed
                  height: 40, fit: BoxFit.scaleDown,// Adjust the height as needed
                ),
              ],
            ),
          ),
        ),
      ),
    );
    Widget contractItemMain(var size,String imagePath,String link,String name,context, )=>  Padding(
      padding:  EdgeInsets.symmetric(horizontal: size.width*0.07),
      child: InkWell(
        onTap: (){
          download(name,link,context);
        },
        child: Card(
          shadowColor: Colors.grey[500],
          surfaceTintColor: HexColor('#FFFFFF'),
          elevation: 4,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(icon:const Icon( Icons.download_rounded,color: Colors.blue,), onPressed: () {

                  downloadPdf(link, context);
                },),

                const SizedBox(width: 10,),
                Expanded(child: Text(name,style: TextStyle(color: Colors.black,fontSize: size.width*0.040),maxLines: 1,overflow: TextOverflow.clip,textAlign: TextAlign.center,)),
                const SizedBox(width: 10,),
                Image.asset(
                  imagePath, // Replace 'my_icon.png' with your PNG image path
                  width: 40, // Adjust the width as needed
                  height: 40, fit: BoxFit.scaleDown,// Adjust the height as needed
                ),

              ],
            ),
          ),
        ),
      ),
    );

    //تحميل داخل الهاتف
Future downloadPdf(String link,context)async{
 await launchUrl(Uri.parse(link),mode: LaunchMode.externalApplication);

}
//تحميل داخل التطبيق
Future download(String name,String link,context)async{

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$name.pdf');

      final response = await http.get(Uri.parse(link));

      if (response.statusCode == 200) {
      // Provide a filename

        await file.writeAsBytes(response.bodyBytes);

        // You can now use the PDF file as needed, such as opening it in a PDF viewer

        navigateTo(
            context, pdf(filePath: file.path, name: name,));
      }
}
void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 10,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// enum  كذا اختيار من حاجة

enum ToastStates { success, error, warning }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;

    case ToastStates.error:
      color = Colors.red;
      break;

    case ToastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}