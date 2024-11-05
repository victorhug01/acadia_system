import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatefulWidget {
  const PdfView({super.key});

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: ElevatedButton(
      //   onPressed: () {},
      //   child: Row(
      //     crossAxisAlignment: CrossAxisAlignment.end,
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       IconButton(
      //         icon: const Icon(Icons.zoom_in),
      //         onPressed: () {
      //           _pdfViewerController.zoomLevel += 0.25;
      //         },
      //       ),
      //       IconButton(
      //         icon: const Icon(Icons.zoom_out),
      //         onPressed: () {
      //           _pdfViewerController.zoomLevel -= 0.25;
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: SfPdfViewer.asset(
        'assets/contrato/contrato.pdf',
        initialZoomLevel: 0.01,
        maxZoomLevel: 100.0,
        controller: _pdfViewerController,
      ),
    );
  }
}
