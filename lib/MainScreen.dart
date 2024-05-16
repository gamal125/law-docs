// ignore_for_file: file_names
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docs/ContractScreen.dart';
import 'package:docs/SystemScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Componant/Componant.dart';
import 'Componant/cache_helper.dart';
import 'Componant/constant.dart';
final Uri _url = Uri.parse('https://www.freeprivacypolicy.com/live/5299e008-e790-40ad-a3b3-22462e20f91e');
 class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

    @override
    State<MainScreen> createState() => _MainScreenState();
   }

  class _MainScreenState extends State<MainScreen> {
  var searchController=TextEditingController();
  var textEditingController=TextEditingController();
  final  formKey2 = GlobalKey<FormState>();
  bool admin=CacheHelper.getData(key: 'admin');
  bool loading=false;
  bool changed=false;
  bool changed2=false;
  int index1=0;
  int index2 =1;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

  }
  @override
  Widget build(BuildContext context) {

    var size=MediaQuery.of(context).size;
     return  Scaffold(
backgroundColor: HexColor('#EAEEFA'),

      body: SafeArea(child:
      GestureDetector(
        onTap:(){
          FocusScope.of(context).unfocus();},
        child: Container(
          decoration: const BoxDecoration(),
          child: Column(

            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
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
              Padding(
                padding: const EdgeInsets.only(top: 15.0,right: 15,left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: (){

                        navigateTo(context, const ContractScreen(names: ['الكل','عقد البيع','عقد الشراء','عقد الايجار','عقد اتعاب محاماة','اخرى'],));
                        },
                      child: Container(
                        decoration:  BoxDecoration(border: Border.all(width: 2,color:pColor ),borderRadius: BorderRadius.circular(22),color:HexColor('#FFFFFF') ),
                        child: Column(

                          children: [
                            !loading?   Container(
                              height: size.height*0.18,
                              width: size.width*0.38,

                              decoration:  BoxDecoration(image: const DecorationImage(image: AssetImage('assets/image/terms.png'),fit: BoxFit.scaleDown),borderRadius: BorderRadius.circular(20)),
                            ):Center(child:   SizedBox(
                      height: size.height*0.18,
                          width: size.width*0.38,
                          child: const SpinKitCircle(color: Colors.blue,)),),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('العقود',style: TextStyle(color: Colors.black,fontSize: size.width*0.045),),
                            ),
                          ],
                        )
                      ),
                    ),
                    InkWell(
                      onTap: (){
                      navigateTo(context,const SystemScreen());
                      },
                      child: Container(
                        decoration:  BoxDecoration(border: Border.all(width: 2,color:pColor ),borderRadius: BorderRadius.circular(22),color:HexColor('#FFFFFF') ),
                        child: Column(
                          children: [
                            Container(
                              height: size.height*0.18,
                              width: size.width*0.38,
                              decoration:  BoxDecoration(image: const DecorationImage(image: AssetImage('assets/image/regulatory.png'),fit: BoxFit.scaleDown),borderRadius: BorderRadius.circular(20)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('الأنظمة',style: TextStyle(color: Colors.black,fontSize: size.width*0.045),),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],),
              ),
        SizedBox(height: MediaQuery.of(context).size.height*0.03,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                              padding: const EdgeInsets.only(left: 20.0,right:20,bottom: 15),
                              alignment: AlignmentDirectional.centerEnd,child: Text('عقود تهمك',style: TextStyle(color: Colors.black,fontSize: size.width*0.039),)),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('العقود').doc('الكل').collection('الكل').orderBy('date',descending: true).snapshots(),
                              builder: (context,snapshot) {

                                if(snapshot.hasData){

                                var files= snapshot.data!.docs;
                                  if(snapshot.data!.docs.isNotEmpty){

                                    return Column(

                                      children: [
                                        contractItemMain(size,'assets/image/polices.png',files.first['url'],files.first['name'],context),
                                        files.length>1?    contractItemMain(size,'assets/image/polices.png',files.last['url'],files.last['name'],context):Container(),
                                      ],
                                    );
                                  }
                                  else{
                                    return const Center(child: Text('! لا يوجد عقود حتي الان',style: TextStyle(color: Colors.grey),),);
                                  }

                                }
                                else{   return const Center(child: Text('! لا يوجد عقود حتي الان',style: TextStyle(color: Colors.grey),),);}}),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(children: [
                                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15),

                      alignment: AlignmentDirectional.centerEnd,child: Text('أنظمة تهمك',style: TextStyle(color: Colors.black,fontSize: size.width*0.039),)),
                                    StreamBuilder<QuerySnapshot>(
                      stream:  FirebaseFirestore.instance.collection('الأنظمة').orderBy('text',descending: true).snapshots(),


                      builder: (context,snapshot)  {
                        List<String> texts=[];

                        if(snapshot.hasData) {
                          if(snapshot.data!.docs.isNotEmpty){
                            for (var element in snapshot.data!.docs) {

                              texts.add(element.id);
                            }


                            // Ensure that index1 and index2 are not the same


                            return Column(
                              children: [
                                snapshot.data!.docs.length==1?     systemItemMain(
                                    size, 'assets/image/polices.png', texts.first,
                                    texts.first, snapshot.data!.docs.first,
                                    context):
                                Column(
                                  children: [
                                    systemItemMain(
                                        size, 'assets/image/polices.png', texts.first,
                                        texts.first, snapshot.data!.docs.first,
                                        context),
                                    systemItemMain(
                                        size, 'assets/image/polices.png', texts.last,
                                        texts.last, snapshot.data!.docs.last,
                                        context),
                                  ],
                                ),


                              ],
                            );
                          }
                          else {
                            return const Center(child: Text(' ! لا يوجد أنظمة حتي الان ',style: TextStyle(color: Colors.grey),),);
                          }
                        }
                        else {
                          return const Center(child: Text(' ! لا يوجد أنظمة حتي الان',style: TextStyle(color: Colors.grey),),);
                        }


                      }
                                    )
                            ],),
                    )
                  ],
                ),
              ),
              const SizedBox(height:15,),
              TextButton(onPressed: (){
                _launchUrl();
              }, child: const Text('Privacy',style: TextStyle(color: Colors.grey),))
            ],),
        ),
      ),),
       floatingActionButton:admin? IgnorePointer(
           ignoring: true,
           child: FloatingActionButton(backgroundColor: HexColor('#FFD700'),clipBehavior: Clip.antiAliasWithSaveLayer,elevation: 4, onPressed: () {  },child: const Icon(Icons.add,color: Colors.white,),)):null,
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url,mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }
}
