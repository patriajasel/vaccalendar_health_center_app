import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:vaccalendar_health_center_app/models/schedule_model.dart';
import 'package:vaccalendar_health_center_app/models/user_data.dart';

class ExcelServices {
  Future<void> exportChildDataToExcel(List<ChildrenData> children) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel[DateFormat('MM-dd-yyyy').format(DateTime.now())];

    List<String> headers = [
      "Child ID",
      "Name",
      "Facility No.",
      "Age",
      "Gender",
      "Height (cm)",
      "Weight (kg)",
      "Birthdate",
      "Birthplace",
      "Conditions",
      "BCG Vaccine",
      "BCG Date",
      "Hepa Vaccine",
      "Hepa Date",
      "OPV1 Vaccine",
      "OPV1 Date",
      "OPV2 Vaccine",
      "OPV2 Date",
      "OPV3 Vaccine",
      "OPV3 Date",
      "IPV1 Vaccine",
      "IPV1 Date",
      "IPV2 Vaccine",
      "IPV2 Date",
      "Pentavalent 1 Vaccine",
      "Pentavalent 1 Date",
      "Pentavalent 2 Vaccine",
      "Pentavalent 2 Date",
      "Pentavalent 3 Vaccine",
      "Pentavalent 3 Date",
      "PCV1 Vaccine",
      "PCV1 Date",
      "PCV2 Vaccine",
      "PCV2 Date",
      "PCV3 Vaccine",
      "PCV3 Date",
      "MMR Vaccine",
      "MMR Date",
    ];

    CellStyle headerStyle = CellStyle(
      backgroundColorHex: ExcelColor.blue300,
      bold: true,
      topBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
      rightBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
      leftBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
      bottomBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
      fontSize: 10,
      horizontalAlign: HorizontalAlign.Center,
      fontColorHex: ExcelColor.black,
    );

    CellStyle headerStyle9 = CellStyle(
      backgroundColorHex: ExcelColor.blue300,
      bold: true,
      topBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
      rightBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thick),
      leftBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
      bottomBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
      fontSize: 11,
      horizontalAlign: HorizontalAlign.Center,
      fontColorHex: ExcelColor.black,
    );

    for (int i = 0; i < headers.length; i++) {
      var cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue('   ${headers[i]}   ');
      cell.cellStyle = i == 9 ? headerStyle9 : headerStyle;
      sheet.setRowHeight(i, 20);
      sheet.setColumnAutoFit(i); // Auto-fit column width
    }

    CellStyle rowStyle = CellStyle(
      backgroundColorHex: ExcelColor.white,
      bold: false,
      fontSize: 9,
      horizontalAlign: HorizontalAlign.Center,
      fontColorHex: ExcelColor.black,
      topBorder: Border(
          borderColorHex: ExcelColor.grey, borderStyle: BorderStyle.Thin),
      rightBorder: Border(
          borderColorHex: ExcelColor.grey, borderStyle: BorderStyle.Thin),
      leftBorder: Border(
          borderColorHex: ExcelColor.grey, borderStyle: BorderStyle.Thin),
      bottomBorder: Border(
          borderColorHex: ExcelColor.grey, borderStyle: BorderStyle.Thin),
    );

    CellStyle rowStyle9 = CellStyle(
      backgroundColorHex: ExcelColor.white,
      bold: false,
      fontSize: 9,
      horizontalAlign: HorizontalAlign.Center,
      fontColorHex: ExcelColor.black,
      topBorder: Border(
          borderColorHex: ExcelColor.grey, borderStyle: BorderStyle.Thin),
      rightBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thick),
      leftBorder: Border(
          borderColorHex: ExcelColor.grey, borderStyle: BorderStyle.Thin),
      bottomBorder: Border(
          borderColorHex: ExcelColor.grey, borderStyle: BorderStyle.Thin),
    );

    for (int i = 0; i < children.length; i++) {
      ChildrenData child = children[i];

      List<dynamic> rowData = [
        child.childID,
        child.childName,
        int.tryParse(child.facilityNumber) == null
            ? child.facilityNumber
            : int.parse(child.facilityNumber),
        int.tryParse(child.childAge) == null
            ? child.childAge
            : int.parse(child.childAge),
        child.childGender,
        int.parse(child.childHeight),
        int.parse(child.childWeight),
        DateFormat('MMMM dd, yyyy').format(child.birthdate!),
        child.birthplace,
        child.childConditions?.join(", ") ?? '',
        child.vaccines.bcgVaccine,
        child.vaccines.bcgDate == null
            ? ''
            : DateFormat('MMMM dd, yyyy').format(child.vaccines.bcgDate!),
        child.vaccines.hepaVaccine,
        child.vaccines.hepaDate == null
            ? ''
            : DateFormat('MMMM dd, yyyy').format(child.vaccines.hepaDate!),
        child.vaccines.opv1Vaccine,
        child.vaccines.opv1Date == null
            ? ''
            : DateFormat('MMMM dd, yyyy').format(child.vaccines.opv1Date!),
        child.vaccines.opv2Vaccine,
        child.vaccines.opv2Date == null
            ? ''
            : DateFormat('MMMM dd, yyyy').format(child.vaccines.opv2Date!),
        child.vaccines.opv3Vaccine,
        child.vaccines.opv3Date == null
            ? ''
            : DateFormat('MMMM dd, yyyy').format(child.vaccines.opv3Date!),
        child.vaccines.ipv1Vaccine,
        child.vaccines.ipv1Date == null
            ? ''
            : DateFormat('MMMM dd, yyyy').format(child.vaccines.ipv1Date!),
        child.vaccines.ipv2Vaccine,
        child.vaccines.ipv2Date == null
            ? ''
            : DateFormat('MMMM dd, yyyy').format(child.vaccines.ipv2Date!),
        child.vaccines.penta1Vaccine,
        child.vaccines.penta1Date == null
            ? ''
            : DateFormat('MMMM dd, yyyy').format(child.vaccines.penta1Date!),
        child.vaccines.penta2Vaccine,
        child.vaccines.penta2Date == null
            ? ''
            : DateFormat('MMMM dd, yyyy').format(child.vaccines.penta2Date!),
        child.vaccines.penta3Vaccine,
        child.vaccines.penta3Date == null
            ? ''
            : DateFormat('MMMM dd, yyyy').format(child.vaccines.penta3Date!),
        child.vaccines.pcv1Vaccine,
        child.vaccines.pcv1Date == null
            ? ''
            : DateFormat('MMMM dd, yyyy').format(child.vaccines.pcv1Date!),
        child.vaccines.pcv2Vaccine,
        child.vaccines.pcv2Date == null
            ? ''
            : DateFormat('MMMM dd, yyyy').format(child.vaccines.pcv2Date!),
        child.vaccines.pcv3Vaccine,
        child.vaccines.pcv3Date == null
            ? ''
            : DateFormat('MMMM dd, yyyy').format(child.vaccines.pcv3Date!),
        child.vaccines.mmrVaccine,
        child.vaccines.mmrDate == null
            ? ''
            : DateFormat('MMMM dd, yyyy').format(child.vaccines.mmrDate!),
      ];

      for (int j = 0; j < rowData.length; j++) {
        var cell = sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1));

        dynamic value = rowData[j];

        // Assign correct data type
        if (value is int) {
          cell.value = IntCellValue(value); // Store as number
        } else if (value is double) {
          cell.value = DoubleCellValue(value); // Store as number
        } else if (value is DateTime) {
          cell.value = DateTimeCellValue(
              year: value.year,
              month: value.month,
              day: value.day,
              hour: value.hour,
              minute: value.minute); // Store as date
        } else {
          cell.value = TextCellValue(value.toString()); // Default to text
        }

        cell.cellStyle = j == 9 ? rowStyle9 : rowStyle;
      }
    }

    // Encode Excel file
    List<int>? bytes = excel.encode();
    if (bytes == null) return;

    // Open a file picker to select a directory
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      String path =
          "$selectedDirectory/Children_Data_${DateFormat('MM-dd-yyyy').format(DateTime.now())}.xlsx";

      File file = File(path);
      await file.writeAsBytes(bytes, flush: true);

      print("Excel file saved at: $path");
    } else {
      print("No directory selected.");
    }
  }

  Future<void> exportScheduleData(List<ScheduleModel> schedules) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel[DateFormat('MM-dd-yyyy').format(DateTime.now())];

    List<String> headers = [
      'Schedule ID',
      'Child Name',
      'Parent Name',
      'Vaccine Status',
      'Schedule Date',
      'Status',
    ];

    CellStyle headerStyle = CellStyle(
      backgroundColorHex: ExcelColor.blue300,
      bold: true,
      topBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
      rightBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
      leftBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
      bottomBorder: Border(
          borderColorHex: ExcelColor.black, borderStyle: BorderStyle.Thin),
      fontSize: 10,
      horizontalAlign: HorizontalAlign.Center,
      fontColorHex: ExcelColor.black,
    );

    for (int i = 0; i < headers.length; i++) {
      var cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue('   ${headers[i]}   ');
      cell.cellStyle = headerStyle;
      sheet.setRowHeight(i, 20);
      sheet.setColumnAutoFit(i); // Auto-fit column width
    }

    CellStyle rowStyle = CellStyle(
      backgroundColorHex: ExcelColor.white,
      bold: false,
      fontSize: 9,
      horizontalAlign: HorizontalAlign.Center,
      fontColorHex: ExcelColor.black,
      topBorder: Border(
          borderColorHex: ExcelColor.grey, borderStyle: BorderStyle.Thin),
      rightBorder: Border(
          borderColorHex: ExcelColor.grey, borderStyle: BorderStyle.Thin),
      leftBorder: Border(
          borderColorHex: ExcelColor.grey, borderStyle: BorderStyle.Thin),
      bottomBorder: Border(
          borderColorHex: ExcelColor.grey, borderStyle: BorderStyle.Thin),
    );

    for (int i = 0; i < schedules.length; i++) {
      ScheduleModel schedule = schedules[i];

      List<dynamic> rowData = [
        schedule.schedID,
        schedule.childName,
        schedule.parent,
        schedule.vaccineType,
        DateFormat('MMMM dd, yyyy').format(schedule.schedDate),
        schedule.schedStatus
      ];

      for (int j = 0; j < rowData.length; j++) {
        var cell = sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1));

        dynamic value = rowData[j];

        // Assign correct data type
        if (value is int) {
          cell.value = IntCellValue(value); // Store as number
        } else if (value is double) {
          cell.value = DoubleCellValue(value); // Store as number
        } else if (value is DateTime) {
          cell.value = DateTimeCellValue(
              year: value.year,
              month: value.month,
              day: value.day,
              hour: value.hour,
              minute: value.minute); // Store as date
        } else {
          cell.value = TextCellValue(value.toString()); // Default to text
        }

        cell.cellStyle = rowStyle;
      }
    }

    // Encode Excel file
    List<int>? bytes = excel.encode();
    if (bytes == null) return;

    // Open a file picker to select a directory
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      String path =
          "$selectedDirectory/Schedule_Report_${DateFormat('MM-dd-yyyy').format(DateTime.now())}.xlsx";

      File file = File(path);
      await file.writeAsBytes(bytes, flush: true);

      print("Excel file saved at: $path");
    } else {
      print("No directory selected.");
    }
  }
}
