class CaptainDashboardModel {
  final int totalEarnings;
  final int pendingCount;
  final int activeCount;
  final List<DashboardActivity> recentActivity;
  final List<DashboardPerformance> performance;

  CaptainDashboardModel({
    required this.totalEarnings,
    required this.pendingCount,
    required this.activeCount,
    required this.recentActivity,
    required this.performance,
  });

  factory CaptainDashboardModel.fromJson(Map<String, dynamic> json) {
    return CaptainDashboardModel(
      totalEarnings: (json['totalEarnings'] ?? 0).toInt(),
      pendingCount: (json['pendingCount'] ?? 0).toInt(),
      activeCount: (json['activeCount'] ?? 0).toInt(),
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
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      userName: json['userName']?.toString() ?? 
                json['customerName']?.toString() ?? 
                json['clientName']?.toString() ?? 
                json['name']?.toString() ?? 'Unknown User',
      serviceName: (json['serviceName'] ?? json['activityName'] ?? 'Service').toString(),
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Pending',
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
