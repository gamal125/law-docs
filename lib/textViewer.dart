// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docs/Componant/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
class TextViewer extends StatefulWidget {
   const TextViewer({super.key,required this.name,required this.id,required this.section,required this.edit});
  final String name;
  final String id;
  final String section;
  final String edit;

  @override
  State<TextViewer> createState() => _TextViewerState();
}

class _TextViewerState extends State<TextViewer> {
  TextEditingController textController=TextEditingController();
  TextEditingController editController=TextEditingController();
  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text:widget.name);
    editController = TextEditingController(text:widget.edit);
  }
  final admin=CacheHelper.getData(key: 'admin');

bool change=false;


  final  formKey3 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return admin?
    Scaffold(
        backgroundColor:  HexColor('#EAEEFA'),
        appBar: AppBar(

          title: Center(child: Text("${widget.section} 》 ${widget.id}")),actions:  [
          !change?const SizedBox() :
          InkWell(
              onTap:(){
                if(formKey3.currentState!.validate()) {
                  FirebaseFirestore.instance.collection(widget.section).doc(widget.id).set({'text':textController.text}).then((value) async {
                    setState(() {
                      change=false;
                      FocusScope.of(context).unfocus();
                    });
                    if(editController.text.isNotEmpty){
                      FirebaseFirestore.instance.collection(widget.section).doc(widget.id).collection(widget.id).doc(widget.id).set({'text':editController.text}).then((value) async {
                        setState(() {
                          change=false;
                          FocusScope.of(context).unfocus();
                        });
                      });
                    }
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
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: formKey3,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(widget.id,textAlign: TextAlign.right,),
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
                            onChanged: (value){
                              setState(() {
                                change=true;
                              });
                            },
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
                            onChanged: (value){
                              setState(() {
                                change=true;
                              });
                            },
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
    )

        : Scaffold(
        backgroundColor:  HexColor('#EAEEFA'),
      appBar: AppBar(title: Center(child: Text('${widget.section} 》 ${widget.id}')),actions: const [],backgroundColor:  HexColor('#EAEEFA'),),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(widget.id,textAlign: TextAlign.right,),
              ),
            ],
          ),
          Expanded(
            flex: widget.edit!=''? 3:1,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(elevation: 4,child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(width: double.infinity,child: SingleChildScrollView(child: SelectableText(widget.name,textAlign: TextAlign.justify,textDirection: TextDirection.rtl,))),
              ),),
            ),
          ),
          widget.edit!=''?const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text('التعديلات',textAlign: TextAlign.right,),
              ),
            ],
          ):const SizedBox(),
          widget.edit!=''? Expanded(
            flex: 1,
            child: GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: widget.name));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم نسخ النص',textAlign: TextAlign.right,)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                child: Card(elevation: 4,child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SizedBox(width: double.infinity,child: SingleChildScrollView(child: SelectableText(widget.edit,textAlign: TextAlign.justify,textDirection: TextDirection.rtl,))),
                ),),
              ),
            ),
          ):const SizedBox(),
        ],
      )
    );
  }
}
