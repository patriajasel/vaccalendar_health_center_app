import 'package:flutter/material.dart';

class DataTableCells {
  Widget buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildStatusCell(String status) {
    Color statusColor = Colors.red;
    if (status == "Finished") {
      statusColor = Colors.green;
    } else if (status == "Pending") {
      statusColor = Colors.yellowAccent.shade700;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: TextStyle(color: statusColor),
      ),
    );
  }
}
