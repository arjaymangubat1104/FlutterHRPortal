import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/viewmodel/theme_view_model.dart';
import 'package:provider/provider.dart';

class FilesSchduleTile extends StatelessWidget {
  final String date;
  final String statusMessage;
  const FilesSchduleTile({
    super.key,
    required this.date,
    required this.statusMessage,
  });

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);

    Color changeBackgroundColor(String value) {
      switch (value) {
        case 'Pending':
          return Colors.orange[100]!;
        case 'Approved':
          return Colors.green[100]!;
        case 'Rejected':
          return Colors.red[100]!;
        default:
          return Colors.grey; // Default color
      }
    }

    Color changeTextColor(String value) {
      switch (value) {
        case 'Pending':
          return Colors.orange;
        case 'Approved':
          return Colors.green;
        case 'Rejected':
          return Colors.red;
        default:
          return Colors.grey; // Default color
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: themeViewModel.currentTheme.backgroundColor,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: themeViewModel.currentTheme.themeColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: changeBackgroundColor(
                  statusMessage,
                ),
              ),
              child: Text(
                statusMessage,
                style: TextStyle(
                  color: changeTextColor(
                    statusMessage,
                  ),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
