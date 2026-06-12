class BusinessOwnerDashboardModel {
  final int totalEarnings;
  final int confirmedCount;
  final int pendingCount;
  final List<DashboardActivity> recentActivity;
  final List<DashboardPerformance> performance;

  BusinessOwnerDashboardModel({
    required this.totalEarnings,
    required this.confirmedCount,
    required this.pendingCount,
    required this.recentActivity,
    required this.performance,
  });

  factory BusinessOwnerDashboardModel.fromJson(Map<String, dynamic> json) {
    return BusinessOwnerDashboardModel(
      totalEarnings: (json['totalEarnings'] ?? 0).toInt(),
      confirmedCount: (json['confirmedCount'] ?? 0).toInt(),
      pendingCount: (json['pendingCount'] ?? 0).toInt(),
      recentActivity: json['recentActivity'] != null
          ? List<DashboardActivity>.from(
              json['recentActivity'].map((x) => DashboardActivity.fromJson(x)))
          : [],
      performance: json['performance'] != null
          ? List<DashboardPerformance>.from(
              json['performance'].map((x) => DashboardPerformance.fromJson(x)))
          : [],
    );
  }
}

class DashboardActivity {
  final String id;
  final String userName;
  final String serviceName;
  final String startDate;
  final String endDate;
  final String status;

  String get name => userName;

  DashboardActivity({
    required this.id,
    required this.userName,
    required this.serviceName,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory DashboardActivity.fromJson(Map<String, dynamic> json) {
    return DashboardActivity(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      serviceName: json['serviceName'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class DashboardPerformance {
  final String date;
  final int count;

  DashboardPerformance({
    required this.date,
    required this.count,
  });

  factory DashboardPerformance.fromJson(Map<String, dynamic> json) {
    return DashboardPerformance(
      date: json['date'] ?? '',
      count: (json['count'] ?? 0).toInt(),
    );
  }
}
