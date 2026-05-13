import 'dart:math';
import '../models/agent.dart';

class AgentService {
  static final AgentService _instance = AgentService._internal();
  factory AgentService() => _instance;
  AgentService._internal();

  final List<Agent> _agents = [
    Agent(
      id: '1',
      name: 'Monitor Agent',
      description: 'Memantau status sistem secara real-time',
      status: AgentStatus.running,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      lastActivity: DateTime.now().subtract(const Duration(minutes: 2)),
      logs: [
        AgentLog(
          message: 'Sistem berjalan normal',
          timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
          level: LogLevel.success,
        ),
        AgentLog(
          message: 'CPU usage: 45%',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          level: LogLevel.info,
        ),
        AgentLog(
          message: 'Memory usage: 2.3GB / 8GB',
          timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
          level: LogLevel.info,
        ),
      ],
    ),
    Agent(
      id: '2',
      name: 'Task Agent',
      description: 'Mengelola dan menjalankan tugas-tugas terjadwal',
      status: AgentStatus.idle,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      lastActivity: DateTime.now().subtract(const Duration(hours: 1)),
      logs: [
        AgentLog(
          message: 'Tugas terakhir selesai',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          level: LogLevel.success,
        ),
        AgentLog(
          message: 'Menunggu tugas berikutnya',
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 5)),
          level: LogLevel.info,
        ),
      ],
    ),
    Agent(
      id: '3',
      name: 'Data Agent',
      description: 'Memproses dan menganalisis data secara otomatis',
      status: AgentStatus.error,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      lastActivity: DateTime.now().subtract(const Duration(hours: 3)),
      logs: [
        AgentLog(
          message: 'Koneksi database terputus',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          level: LogLevel.error,
        ),
        AgentLog(
          message: 'Mencoba reconnect...',
          timestamp: DateTime.now().subtract(const Duration(hours: 3, minutes: 1)),
          level: LogLevel.warning,
        ),
      ],
    ),
    Agent(
      id: '4',
      name: 'Report Agent',
      description: 'Membuat laporan otomatis berdasarkan data terkumpul',
      status: AgentStatus.stopped,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      lastActivity: DateTime.now().subtract(const Duration(days: 1)),
      logs: [
        AgentLog(
          message: 'Agent dihentikan oleh pengguna',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          level: LogLevel.warning,
        ),
      ],
    ),
  ];

  List<Agent> getAgents() => List.unmodifiable(_agents);

  Agent? getAgentById(String id) {
    try {
      return _agents.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  void startAgent(String id) {
    final agent = getAgentById(id);
    if (agent != null) {
      agent.status = AgentStatus.running;
      agent.logs.insert(
        0,
        AgentLog(
          message: 'Agent dimulai',
          timestamp: DateTime.now(),
          level: LogLevel.success,
        ),
      );
    }
  }

  void stopAgent(String id) {
    final agent = getAgentById(id);
    if (agent != null) {
      agent.status = AgentStatus.stopped;
      agent.logs.insert(
        0,
        AgentLog(
          message: 'Agent dihentikan',
          timestamp: DateTime.now(),
          level: LogLevel.warning,
        ),
      );
    }
  }

  void restartAgent(String id) {
    final agent = getAgentById(id);
    if (agent != null) {
      agent.status = AgentStatus.running;
      agent.logs.insert(
        0,
        AgentLog(
          message: 'Agent di-restart',
          timestamp: DateTime.now(),
          level: LogLevel.info,
        ),
      );
    }
  }

  Map<String, int> getStats() {
    return {
      'total': _agents.length,
      'running': _agents.where((a) => a.status == AgentStatus.running).length,
      'idle': _agents.where((a) => a.status == AgentStatus.idle).length,
      'stopped': _agents.where((a) => a.status == AgentStatus.stopped).length,
      'error': _agents.where((a) => a.status == AgentStatus.error).length,
    };
  }
}
