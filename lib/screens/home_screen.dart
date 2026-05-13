import 'package:flutter/material.dart';
import '../models/agent.dart';
import '../services/agent_service.dart';
import '../widgets/agent_card.dart';
import '../widgets/stat_card.dart';
import 'agent_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = AgentService();
  AgentStatus? _filter;

  List<Agent> get _filteredAgents {
    final agents = _service.getAgents();
    if (_filter == null) return agents.toList();
    return agents.where((a) => a.status == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final stats = _service.getStats();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Canopus',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: const Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(stats),
          _buildFilterChips(),
          Expanded(
            child: _filteredAgents.isEmpty
                ? _buildEmpty()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: _filteredAgents.length,
                    itemBuilder: (ctx, i) => AgentCard(
                      agent: _filteredAgents[i],
                      onTap: () => _openDetail(_filteredAgents[i]),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAgentDialog,
        backgroundColor: const Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Agent'),
      ),
    );
  }

  Widget _buildHeader(Map<String, int> stats) {
    return Container(
      color: const Color(0xFF1A1A2E),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat datang di Canopus',
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              StatCard(
                label: 'Total',
                value: stats['total']!,
                color: Colors.white,
                icon: Icons.smart_toy,
              ),
              StatCard(
                label: 'Berjalan',
                value: stats['running']!,
                color: Colors.greenAccent,
                icon: Icons.play_arrow,
              ),
              StatCard(
                label: 'Siaga',
                value: stats['idle']!,
                color: Colors.lightBlueAccent,
                icon: Icons.pause,
              ),
              StatCard(
                label: 'Error',
                value: stats['error']!,
                color: Colors.redAccent,
                icon: Icons.error_outline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _chip('Semua', null),
            _chip('Berjalan', AgentStatus.running),
            _chip('Siaga', AgentStatus.idle),
            _chip('Berhenti', AgentStatus.stopped),
            _chip('Error', AgentStatus.error),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, AgentStatus? status) {
    final selected = _filter == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _filter = status),
        selectedColor: const Color(0xFF1A1A2E).withOpacity(0.15),
        checkmarkColor: const Color(0xFF1A1A2E),
        labelStyle: TextStyle(
          color: selected ? const Color(0xFF1A1A2E) : Colors.grey[700],
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.smart_toy_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Tidak ada agent',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _openDetail(Agent agent) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AgentDetailScreen(agentId: agent.id),
      ),
    ).then((_) => setState(() {}));
  }

  void _showAddAgentDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Fitur Segera Hadir'),
        content: const Text(
          'Penambahan agent baru akan tersedia di versi berikutnya.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
