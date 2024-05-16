// ignore_for_file: file_names, prefer_typing_uninitialized_variables, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class pdf extends StatelessWidget {
  const pdf(  {super.key,required this.filePath,required this.name});

  final filePath;
  final name;
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(title: Center(child: Text(name)),actions: const []),
      body: filePath == null
        ? const CircularProgressIndicator()
        : PDFView(
          onPageChanged: (int? x,int? y){


          },
            filePath: filePath!,
          ),
    );
  }
}
