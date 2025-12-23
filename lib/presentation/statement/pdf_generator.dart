// lib/presentation/statement/pdf_generator.dart

import 'dart:io';
import 'package:bneeds_moi/data/models/statement_model.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:printing/printing.dart';

class PdfGenerator {
  static Future<void> generateAndPrintPdf(
      List<StatementModel> statements, String functionName) async {
    // 1. HTML உள்ளடக்கத்தை உருவாக்குதல்
    final String htmlContent = _generateHtml(statements, functionName);

    // 2. ஒரு தற்காலிக கோப்பு பாதையை உருவாக்குதல்
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/statement.pdf';

    // 3. HTML-லிருந்து PDF-ஐ உருவாக்குதல்
    final File generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
      htmlContent,
      directory.path,
      'statement',
    );

    // 4. PDF-ஐ அச்சிடுதல் அல்லது பகிர்தல்
    await Printing.layoutPdf(
      onLayout: (format) async => generatedPdfFile.readAsBytes(),
    );
  }

// lib/presentation/statement/pdf_generator.dart

// ... (மற்ற குறியீடுகள் அப்படியே இருக்கும்)  // ✨ --- திருத்தப்பட்ட செயல்பாடு இங்கே --- ✨
  static String _generateHtml(List<StatementModel> statements, String title) {
    // 1. அறிக்கைகளை ஊர் வாரியாக குழுக்களாகப் பிரித்தல்
    Map<String, List<StatementModel>> groupedStatements = {};
    for (var statement in statements) {
      if (!groupedStatements.containsKey(statement.city)) {
        groupedStatements[statement.city] = [];
      }
      groupedStatements[statement.city]!.add(statement);
    }

    // 2. ஒவ்வொரு ஊருக்கும் HTML உருவாக்குதல்
    String allTables = '';
    final headers = [
      '#',
      'விபரம்',
      'செலுத்தியது',
      'திரும்ப தந்தது',
      'மீதம்'
    ];

    groupedStatements.forEach((city, cityStatements) {
      // அட்டவணையின் ஒவ்வொரு வரிசையையும் உருவாக்குதல்
      String rows = '';
      for (int i = 0; i < cityStatements.length; i++) {
        final statement = cityStatements[i];
        rows += '''
          <tr>
            <td>${i + 1}</td>
            <td class="left-align">${statement.description}</td>
            <td class="right-align">${statement.amount > 0 ? '₹${statement.amount.toStringAsFixed(0)}' : '-'}</td>
            <td class="right-align">${statement.paidAmount > 0 ? '₹${statement.paidAmount.toStringAsFixed(0)}' : '-'}</td>
            <td class="right-align">₹${statement.balance.toStringAsFixed(0)}</td>
          </tr>
        ''';
      }

      // இந்த ஊருக்கான முழு HTML பகுதி
      // ✨ திருத்தம்: <br> நீக்கப்பட்டது ✨
      allTables += '''
        <div class="city-header">
          <h3 class="city-title">${city}</h3>
        </div>
        <table>
          <thead>
            <tr>
              ${headers.map((h) => '<th>$h</th>').join()}
            </tr>
          </thead>
          <tbody>
            $rows
          </tbody>
        </table>
      ''';
    });

    // 3. முழுமையான HTML உள்ளடக்கம்
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <style>
          @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+Tamil:wght@400;700&display=swap');
          
          body {
            font-family: 'Noto Sans Tamil', sans-serif;
          }
          .main-title, .sub-title {
            text-align: center;
            margin: 0;
            padding: 5px 0;
          }
          hr {
            margin: 15px 0;
          }
          
          /* --- ✨ CSS திருத்தங்கள் இங்கே --- */
          .city-header {
            text-align: center;
            background-color: #e0e0e0; /* பின்னணி நிறம் */
            border: 1px solid #9e9e9e; /* பார்டர் */
            border-bottom: none; /* கீழே உள்ள பார்டரை நீக்குதல் */
            padding: 5px 0;
            margin-top: 25px; /* அட்டவணைகளுக்கு இடையில் இடைவெளி */
          }
          .city-title {
            font-size: 14px;
            font-weight: bold;
            margin: 0;
          }
          table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
            page-break-inside: avoid;
          }
           /* --- -------------------- --- */
          
          th, td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: center;
          }
          th {
            background-color: #f2f2f2;
            font-weight: bold;
          }
          .right-align {
            text-align: right;
          }
          .left-align {
            text-align: left;
          }
        </style>
      </head>
      <body>
        <h2 class="main-title">$title</h2>
        <h3 class="sub-title">அறிக்கை</h3>
        <hr>
        $allTables
      </body>
      </html>
    ''';
  }
}


