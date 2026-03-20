import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {

  static Future generateSummaryPDF(
      double total,
      Map<String, double> categoryTotals,
      DateTime start,
      DateTime end) async {

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              pw.Text(
                "Expense Summary",
                style: pw.TextStyle(fontSize: 24),
              ),

              pw.SizedBox(height: 10),

              pw.Text(
                "${start.toString().split(' ')[0]}  →  ${end.toString().split(' ')[0]}",
              ),

              pw.SizedBox(height: 20),

              pw.Text(
                "Total Spending: ₹${total.toInt()}",
                style: pw.TextStyle(fontSize: 18),
              ),

              pw.SizedBox(height: 20),

              ...categoryTotals.entries.map((entry) {

                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [

                    pw.Text(entry.key),

                    pw.Text("₹${entry.value.toInt()}"),

                  ],
                );

              }),

            ],
          );

        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );

  }

}