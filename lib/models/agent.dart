enum AgentStatus { running, idle, stopped, error }

class Agent {
  final String id;
  final String name;
  final String description;
  AgentStatus status;
  final DateTime createdAt;
  DateTime? lastActivity;
  final List<AgentLog> logs;

  Agent({
    required this.id,
    required this.name,
    required this.description,
    this.status = AgentStatus.idle,
    required this.createdAt,
    this.lastActivity,
    List<AgentLog>? logs,
  }) : logs = logs ?? [];

  String get statusLabel {
    switch (status) {
      case AgentStatus.running:
        return 'Berjalan';
      case AgentStatus.idle:
        return 'Siaga';
      case AgentStatus.stopped:
        return 'Berhenti';
      case AgentStatus.error:
        return 'Error';
    }
  }
}

class AgentLog {
  final String message;
  final DateTime timestamp;
  final LogLevel level;

  AgentLog({
    required this.message,
    required this.timestamp,
    this.level = LogLevel.info,
  });
}

enum LogLevel { info, warning, error, success }
