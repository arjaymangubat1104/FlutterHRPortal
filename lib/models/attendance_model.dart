class UserAttendanceModel {
  final String id;
  final String userId;
  final String? userName;
  //final String studentPhoto;
  String? attendanceStatus;
  final String? attendanceDate;
  String? timeIn;
  String? timeOut;
  String? totalTime;
  String? lateTime;
  String? underTime;

  UserAttendanceModel({
    required this.id,
    required this.userId,
    required this.userName,
    //required this.studentPhoto,
    required this.attendanceStatus,
    required this.attendanceDate,
    required this.timeIn,
    required this.timeOut,
    this.totalTime,
    this.lateTime,
    this.underTime,
  });

  factory UserAttendanceModel.fromJson(Map<String, dynamic> json) {
    return UserAttendanceModel(
      id: json['id'],
      userId: json['user_id'],
      userName: json['user_name'],
      //studentPhoto: json['student_photo'],
      attendanceStatus: json['attendance_status'],
      attendanceDate: json['attendance_date'],
      timeIn: json['time_in'],
      timeOut: json['time_out'],
      totalTime: json['total_time'],
      lateTime: json['late_time'],
      underTime: json['under_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      //'student_photo': studentPhoto,
      'attendance_status': attendanceStatus,
      'attendance_date': attendanceDate,
      'time_in': timeIn,
      'time_out': timeOut,
      'total_time': totalTime,
      'late_time': lateTime,
      'under_time': underTime,
    };
  }
  
}