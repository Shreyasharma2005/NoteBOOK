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
  String selectedText = "";
  PdfViewerController pdfViewerController = PdfViewerController();
  final TextEditingController questionController = TextEditingController();

  Future<void> pickPDF() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(
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

  void showAskAIDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ask AI"),

          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Selected Text:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: Text(selectedText),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: questionController,
                  decoration: const InputDecoration(
                    labelText: "Your Question",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {

                print(
                  "QUESTION: ${questionController.text}",
                );

                Navigator.pop(context);
              },
              child: const Text("Ask AI"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NoteBOOK"),
        centerTitle: true,
      ),
      body: Stack(
        children: [

          Column(
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
                        controller: pdfViewerController,

                        onTextSelectionChanged:
                            (PdfTextSelectionChangedDetails details) {

                          if (details.selectedText != null &&
                              details.selectedText!.isNotEmpty) {
                            setState(() {
                              selectedText = details.selectedText!;
                            });
                          }

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

          if (selectedText.isNotEmpty)
            Positioned(
              bottom: 30,
              right: 30,
              child: ElevatedButton(
                onPressed: () {

                  pdfViewerController.clearSelection();

                  showAskAIDialog();
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: const Text("💭 Ask AI?"),
              ),
            ),
        ],
      ),
    );
  }
}