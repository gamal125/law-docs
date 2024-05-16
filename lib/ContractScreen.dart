// ignore_for_file: non_constant_identifier_names, file_names
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docs/Componant/constant.dart';
import 'package:docs/UploadPdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Componant/Componant.dart';
import 'Componant/cache_helper.dart';
import 'MainScreen.dart';

class ContractScreen extends StatefulWidget {
    const ContractScreen({super.key,required this.names});
   final List<String> names;
  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  var textEditingController=TextEditingController();
  var nameEditingController=TextEditingController();
  final  formKey2 = GlobalKey<FormState>();
  final  key = GlobalKey<FormState>();
  bool admin=CacheHelper.getData(key: 'admin');
  int tappedButtonIndex=0;
  var searchController=TextEditingController();
  List<String> names=['الكل','عقد البيع','عقد الشراء','عقد الايجار','عقد اتعاب محاماة','اخرى'];
  List<QueryDocumentSnapshot>  filesSearch=[];
  List<QueryDocumentSnapshot>  Search=[];
  List<QueryDocumentSnapshot>  currantList=[];

  @override
void initState()   {
    // TODO: implement initState
names=widget.names;


   super.initState();
  }
  @override
  Widget build(BuildContext context) {

    var size=MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: HexColor('#EAEEFA'),
      body: SafeArea(
        child:    GestureDetector(
          onTap:(){
            FocusScope.of(context).unfocus();
            },
          child: Container(
            decoration:  BoxDecoration(
           color:HexColor('#EAEEFA'),),
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
                                          controller: textEditingController,
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
                                      if(textEditingController.text=='Shahad27'){
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

                            }

                          ,
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
                const SizedBox(height: 20,),
             Container(
        height: size.height*0.05,
            alignment: AlignmentDirectional.center,
            child: ListView.separated(
        reverse: true,
        shrinkWrap: true,
            physics: const ScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return item(names[index],index,); },
        separatorBuilder: (BuildContext context, int index) { return const SizedBox(width: 10,); },
        itemCount:names.length,

      ),
    ),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 20),
                    alignment: AlignmentDirectional.centerEnd,child: Text('العقود',style: TextStyle(color: Colors.black,fontSize: size.width*0.035),)),


           searchController.text.isEmpty?    StreamBuilder<QuerySnapshot>(
               stream:  FirebaseFirestore.instance.collection('العقود').doc(widget.names[tappedButtonIndex]).collection(widget.names[tappedButtonIndex]).orderBy('date',descending: true).snapshots(),
                    builder: (context,snapshot) {

                      if(snapshot.hasData) {
                        if(snapshot.data!.docs.isNotEmpty){

                          currantList=snapshot.data!.docs;
                          currantList.toSet().toList();
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return contractItem(size,currantList[index]['name'],currantList[index]['url'],'assets/image/polices.png',context,admin,names); },
                            separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 10,); },
                            itemCount:snapshot.data!.docs.length,

                          );}
                        else{
                          return const Center(child: Text('! لا يوجد انظمه حتي الان',style: TextStyle(color: Colors.grey),),);
                        }
                      }else{
                        return const Center(child:   SpinKitCircle(color: Colors.blue,));
                      }
               })
               :ListView.separated(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return contractItem(size,filesSearch[index]['name'],filesSearch[index]['url'],'assets/image/polices.png',context,admin,names); },
                separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 10,); },
                itemCount:filesSearch.length,
              )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:admin? FloatingActionButton(onPressed: (){

    navigateTo(context, UploadPdf());
      },backgroundColor: HexColor('#FFD700'),clipBehavior: Clip.antiAliasWithSaveLayer,elevation: 4,child: const Icon(Icons.add,color: Colors.white,),):null,

    );
  }

void searchPhone(String query) async {
   final suggest=currantList.where((service){
     final serviceTitle=service['name'].toLowerCase();
     final input=query.toLowerCase();
     return serviceTitle.contains(input);
   }).toList();
  setState(() {
    filesSearch=suggest;
  });
}
Widget item(String text,int index)=>Container(
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
          color:  Colors.white,
          borderRadius: BorderRadius.circular(20),border: Border.all(width: 5,color: tappedButtonIndex==index?pColor:Colors.white,)),
      child:  InkWell(
       //  onLongPress: (){
       //    String oldName=text;
       //    nameEditingController.text=text;
       // admin?   AwesomeDialog(
       //      body:    Padding(
       //        padding: const EdgeInsets.all(18.0),
       //        child: Form(
       //          key:key ,
       //          child: Column(
       //            children: [
       //          const Text('تعديل اسم الماده'),
       //              SizedBox(height: 20,),
       //              TextFormField(
       //                textAlign: TextAlign.right,
       //                textDirection: TextDirection.rtl,
       //                controller: nameEditingController,
       //                validator: (String? value) {
       //                  if (value!.isEmpty) {
       //                    return 'برجاء إدخال النص ';
       //                  }
       //                  return null;
       //                },
       //                decoration: InputDecoration(
       //                  alignLabelWithHint: true,
       //                  border: OutlineInputBorder(borderSide: BorderSide(width: 1),borderRadius: BorderRadius.circular(25)),
       //
       //                  hintTextDirection: TextDirection.rtl,
       //                  labelText: 'اسم  الماده',
       //                ),
       //              ),
       //            ],
       //          ),
       //        ),
       //      ),
       //      context: context,
       //      dialogType: DialogType.warning,
       //      animType: AnimType.rightSlide,
       //
       //      btnCancelOnPress: () {
       //
       //      },
       //      btnCancelText: 'لا',
       //      btnOkText: 'نعم',
       //      btnOkOnPress: () {
       //        if(key.currentState!.validate()){
       //          FirebaseStorage.instance.ref().child(oldName).listAll().then((value) {
       //
       //            renameOrDeleteFolder(oldName,nameEditingController.text,value.items.length).then((value) {navigateAndFinish(context, MainScreen());});
       //
       //          } );
       //        }
       //      },
       //    ).show():null;
       //  },
        onTap: (){
          setState(() {
          searchController.clear();
          tappedButtonIndex=index;
        });
          },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(text,style: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width*0.040),),
        ),
      ));
}
/*
Future<void> renameOrDeleteFolder(String originalFolderName, String newFolderName,int listResultLength ) async {
  // If the original folder exists and is not empty, rename it

  if (listResultLength > 0) {
    // Get a reference to the original folder
    Reference originalFolderRef = FirebaseStorage.instance.ref().child(originalFolderName);

    // Get a reference to the new folder
    Reference newFolderRef = FirebaseStorage.instance.ref().child(newFolderName);

    // List files from the original folder
    ListResult result = await originalFolderRef.listAll();

    // Iterate over the files and move them to the new folder
    for (Reference ref in result.items) {
      // Get the file name
      String fileName = ref.name;

      // Get the data of the original file
      Uint8List? fileData = await ref.getData();

      // Check if fileData is not null
      if (fileData != null) {
        // Upload the file to the new folder with content type 'application/pdf'
        await newFolderRef.child(fileName).putData(
            fileData, SettableMetadata(contentType: 'application/pdf'));
      }

      // Delete the original file
      await ref.delete();
    }

    // Print a message indicating that the folder has been renamed
    print('Folder renamed successfully.');
  } else {
    // If the original folder is empty, print a message indicating that it doesn't exist files
    FirebaseStorage.instance.ref().child(originalFolderName).delete();

    // Create an empty file inside the folder (creating an empty file effectively creates an empty folder)


  }
}*/
