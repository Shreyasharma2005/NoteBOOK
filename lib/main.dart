import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';

void main() {
  runApp(const NoteBOOKApp());
}
class NoteBOOKApp extends StatelessWidget {
  const NoteBOOKApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoteBOOK',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String selectedFileName = "No file selected";
  String? selectedFilePath;

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFileName = result.files.single.name;
        selectedFilePath = result.files.single.path;
        print(selectedFilePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NoteBOOK"),
        centerTitle: true,
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: pickPDF,
              child: const Text("Import PDF"),
            ),
          ),

          Expanded(
            child: selectedFilePath == null
                ? const Center(
                    child: Text("No PDF Selected"),
                  )
                : SfPdfViewer.file(
                    File(selectedFilePath!),

                     onTextSelectionChanged:
                          (PdfTextSelectionChangedDetails details) {

                        if (details.selectedText != null &&
                            details.selectedText!.isNotEmpty) {

                          print("==========");
                          print("SELECTED TEXT:");
                          print(details.selectedText);
                          print("==========");
                        }
                      },
                  ),
          ),

        ],
      ),
    );
  }
}