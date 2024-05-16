// ignore_for_file: must_be_immutable, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docs/Componant/Componant.dart';
import 'package:docs/SystemScreen.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class UploadText extends StatelessWidget {
  UploadText({super.key,required this.section,required this.id});

  final String section;
  final String id;
  final  formKey3 = GlobalKey<FormState>();
   var textController=TextEditingController();
   var editController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor:  HexColor('#EAEEFA'),
        appBar: AppBar(

          title: const Center(child: Text('اضافة نص')),actions:  [
            InkWell(
                onTap:(){
                  if(formKey3.currentState!.validate()) {
                    FirebaseFirestore.instance.collection(section).doc(id).set({'text':textController.text}).then((value) {

    FirebaseFirestore.instance.collection(section).doc(id).collection(id).doc(id).set({'text':editController.text.isEmpty?'':editController.text}).then((value) {
      showToast(text:'تم الحفظ', state: ToastStates.success);
      navigateAndFinish(context, const SystemScreen());
    });


                    });
                  }
                }
        ,child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(15)),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('حفظ',style: TextStyle(color: Colors.white),),
                ),),
        ))
        ],backgroundColor:  HexColor('#EAEEFA',),
        ),
        body: GestureDetector(
          onTap:(){
          FocusScope.of(context).unfocus();},
          child: Form(
            key: formKey3,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(id,textAlign: TextAlign.right,),
                    ),
                  ],
                ),

                Flexible(
                 flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(elevation: 4,child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height*0.7,
                          width: double.infinity,child: SingleChildScrollView(
                          child: TextFormField(
                            textAlign: TextAlign.justify,
                            textDirection: TextDirection.rtl,
                            maxLines: 100000,
                            controller: textController,
                            validator: (value){
                              if(value==null){
                                return 'من فضلك ادخل النص';
                              }
                              return null;
                            },

                          )
                      )),
                    ),),
                  ),
                ),
              const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text('التعديلات',textAlign: TextAlign.right,),
                    ),
                  ],
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                    child: Card(elevation: 4,child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SizedBox(width: double.infinity,child: SingleChildScrollView(
                          child: TextField(
                            textAlign: TextAlign.justify,
                            textDirection: TextDirection.rtl,
                            maxLines: 10000,
                            controller: editController,

                          )
                      )
                      ),
                    ),),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
