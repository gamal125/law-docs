// ignore_for_file: file_names, non_constant_identifier_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Componant/Componant.dart';
import 'Componant/cache_helper.dart';
import 'MainScreen.dart';
import 'UploadText.dart';

class SystemScreen extends StatefulWidget {
  const SystemScreen({super.key});

  @override
  State<SystemScreen> createState() => _SystemScreenState();
}

class _SystemScreenState extends State<SystemScreen> {
  int tappedButtonIndex=0;
  var searchController=TextEditingController();
  var textEditingControlle=TextEditingController();
  var labelEditingController=TextEditingController();
  final  formKey2 = GlobalKey<FormState>();
  final  formKey = GlobalKey<FormState>();
  bool admin=CacheHelper.getData(key: 'admin');
  List<String> textList=['الأنظمة', 'الأنظمة الاخرى',];
  var EditingController=TextEditingController();
  final  Key2 = GlobalKey<FormState>();
  List<QueryDocumentSnapshot>  filesSearch=[];
  List<QueryDocumentSnapshot>  Search=[];
  List<QueryDocumentSnapshot>  currantList=[];
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: HexColor('#EAEEFA'),
      body: SafeArea(
        child:    GestureDetector(
          onTap: () {

              FocusScope.of(context).unfocus();
          },
          child: Container(
            decoration:   BoxDecoration(
              color:HexColor('#EAEEFA'),
            ),
            child: ListView(

              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Form(
                        key: formKey2,
                        child: PopupMenuButton(
                            onSelected: (value){
                              if(value==0){

                                AwesomeDialog(
                                  body:    Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      children: [
                                        admin?const Text('تحويل لوضع المستخدم'):const Text('تحويل لوضع المدير'),
                                        const SizedBox(height: 20,),
                                        TextFormField(
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                          controller: textEditingControlle,
                                          validator: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'برجاء إدخال كلمة المرور';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            border: OutlineInputBorder(borderSide: const BorderSide(width: 1),borderRadius: BorderRadius.circular(25)),
                                            hintText: '******',
                                            hintTextDirection: TextDirection.rtl,
                                            labelText: 'ادخل كلمة المرور',
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
                                  btnCancelText: 'لا',
                                  btnOkText: 'نعم',
                                  btnOkOnPress: () {
                                    if(formKey2.currentState!.validate()){
                                      if(textEditingControlle.text=='Shahad27'){
                                        admin=!admin;
                                        CacheHelper.saveData(key: 'admin', value: admin);

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const MainScreen()),
                                        );

                                      }else{
                                        showToast(text: 'كلمة مرور خاطئه', state: ToastStates.error);
                                      }
                                    }
                                  },
                                ).show();
                              }
                            },
                            itemBuilder: (context){
                              return [
                                PopupMenuItem(value: 0,child: Row(children: [
                                  const Icon(Icons.person),
                                  admin? const Text('تسجيل كمستخدم  '):const Text('تسجيل كمدير '),
                                ],))];
                            }),
                      ),
                      Row(
                        children: [
                          Text('موسوعة القانون السعودي',style: TextStyle(color:Colors.black,fontSize: size.width*0.033,fontWeight: FontWeight.bold),),
                          const SizedBox(width: 10,),


                          Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/image/light.png'),fit: BoxFit.cover,),shape: BoxShape.circle),
                          ),
                          //   Image.asset('assets/image/courthouse.png',fit: BoxFit.scaleDown,),
                          const SizedBox(width: 15,),

                          //   Image.asset('assets/image/courthouse.png',fit: BoxFit.scaleDown,),


                        ],
                      ),

                    ],
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 10,),
                    IconButton(onPressed: (){}, icon: Image.asset(
                      'assets/image/search.png', // Replace 'icon_image.png' with your PNG image path
                      width: 30, // Adjust the width as needed
                      height: 30, // Adjust the height as needed
                    ),),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: TextField(
                          onChanged: (value){
                            searchPhone(value);
                            setState(() {
                              searchController.text=value;
                            });

                          },
                          textAlign:TextAlign.right,
                          controller: searchController,
                          cursorColor: Colors.black,
                          decoration:  InputDecoration(
                            labelText: "",
                            filled: true,
                            fillColor: Colors.white,
                            border:  OutlineInputBorder(
                              borderRadius:  BorderRadius.circular(30.0),
                            ),
                          ),

                          keyboardType: TextInputType.text,

                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height*0.01,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Card(
                    shadowColor: Colors.grey[500],
                    surfaceTintColor: HexColor('#FFFFFF'),
                    elevation: 4,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                          alignment: AlignmentDirectional.center,
                            color:  tappedButtonIndex==1? HexColor('#d5d8e0'):Colors.white,
                            child: InkWell(
                              onTap: (){    setState(() {
                                searchController.text='';
                                tappedButtonIndex=1;
                              });},
                              child: Padding(
                                padding: const EdgeInsets.all( 20.0),
                                child: Text('الأنظمة الاخرى',style: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width*0.040),),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: AlignmentDirectional.center,
                            color:  tappedButtonIndex==0? HexColor('#d5d8e0'):Colors.white,
                            child: InkWell(
                              onTap: (){    setState(() {
                                searchController.text='';
                                tappedButtonIndex=0;
                              });},
                              child: Padding(
                                padding: const EdgeInsets.all( 20.0),
                                child: Text('الأنظمة',style: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width*0.040),),
                              ),
                            ),
                          ),
                        ),
                      ],),),
                ),
                SizedBox(height: size.height*0.02,),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                    alignment: AlignmentDirectional.centerEnd,child: Text('الأنظمة',style: TextStyle(color: Colors.black,fontSize: size.width*0.045),)),
                SizedBox(height: size.height*0.02,),
                searchController.text.isEmpty?
                StreamBuilder<QuerySnapshot>(
                    stream: tappedButtonIndex==0? FirebaseFirestore.instance.collection('الأنظمة').snapshots():
                    FirebaseFirestore.instance.collection('الأنظمة الاخرى').snapshots(),

                    builder: (context,snapshot)  {
                      List<String> texts=[];
                      if(snapshot.hasData) {
if(snapshot.data!.docs.isNotEmpty){
                        for (var element in snapshot.data!.docs) {
                          texts.add(element.id);
                        }
                        currantList=snapshot.data!.docs;
                        currantList.toSet().toList();
                        return ListView.separated(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return systemItem(size,'assets/image/polices.png',textList[tappedButtonIndex],texts[index],snapshot.data!.docs[index],context,admin,searchController.text,EditingController,Key2); },
                      separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 10,); },
                      itemCount:texts.length,

                    );}
else{
  return const Center(child: Text('! لا يوجد انظمة حتي الان',style: TextStyle(color: Colors.grey),),);
}
                      }else{
                        return const Center(child:   SpinKitCircle(color: Colors.blue,));
                      }
                  }
                ):
                ListView.separated(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return systemItem(size,'assets/image/polices.png',textList[tappedButtonIndex],filesSearch[index].id,filesSearch[index],context,admin,searchController.text,EditingController,Key2); },
                    separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 10,); },
                  itemCount:filesSearch.length,
                ),

              ],
            ),
          ),
        ),
      ),
      floatingActionButton:admin? FloatingActionButton(onPressed: (){

          AwesomeDialog(
            body:    Form(
                key:formKey,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                  const Text('اسم الماده'),
                    const SizedBox(height: 20,),
                    TextFormField(
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      controller: labelEditingController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          showToast(text:' برجاء إدخال اسم الماده اولا' , state: ToastStates.warning);
                          return 'برجاء إدخال اسم الماده';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(borderSide: const BorderSide(width: 1),borderRadius: BorderRadius.circular(25)),
                        hintText: '',
                        hintTextDirection: TextDirection.rtl,
                        labelText: 'ادخل اسم الماده',
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
            btnOkOnPress: () {
              if(formKey.currentState!.validate()){
                navigateTo(context, UploadText(section: textList[tappedButtonIndex], id:labelEditingController.text ,));
              }
            },
          ).show();


      },backgroundColor: HexColor('#FFD700'),clipBehavior: Clip.antiAliasWithSaveLayer,elevation: 4,child: const Icon(Icons.add,color: Colors.white,),):null,

    );
  }

  void searchPhone(String query) async {
    final suggest=currantList.where((service){
      final serviceTitle=service.id.toLowerCase();
      final input=query.toLowerCase();
      return serviceTitle.contains(input);
    }).toList();

    final suggest1=currantList.where((service){
      final serviceTitle=service['text'].toLowerCase();
      final input=query.toLowerCase();
      return serviceTitle.contains(input);
    }).toList();

    setState(() {
      filesSearch.clear();
      Search.clear();
      Search=suggest1+suggest;

      for (var element in Search) {
       filesSearch.contains(element)?null:filesSearch.add(element);
        }

      filesSearch.toSet().toList();


    });
  }
}
