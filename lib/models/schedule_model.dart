class ScheduleModel {
  final String scheduleIn; //default schedule in
  final String scheduleOut; //default schedule out
  final String scheduleStartDayOfTheWeek;
  final String scheduleEndDayofTheWeek;
  final String scheduleType;
  final String breakStartTime;
  final String breakEndTime;

  ScheduleModel({
    required this.scheduleIn,
    required this.scheduleOut,
    required this.scheduleStartDayOfTheWeek,
    required this.scheduleEndDayofTheWeek,
    required this.scheduleType,
    required this.breakStartTime,
    required this.breakEndTime,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      scheduleIn: json['schedule_in'],
      scheduleOut: json['schedule_out'],
      scheduleStartDayOfTheWeek: json['schedule_start_date'],
      scheduleEndDayofTheWeek: json['schedule_end_date'],
      scheduleType: json['schedule_type'],
      breakStartTime: json['break_start_time'],
      breakEndTime: json['break_end_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schedule_in': scheduleIn,
      'schedule_out': scheduleOut,
      'schedule_start_date': scheduleStartDayOfTheWeek,
      'schedule_end_date': scheduleEndDayofTheWeek,
      'schedule_type': scheduleType,
      'break_start_time': breakStartTime,
      'break_end_time': breakEndTime,
    };
  }

}