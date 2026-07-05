import 'package:flutter/material.dart';

import '../models/smart_reminder.dart';
import '../services/api_service.dart';

class SmartReminderScreen extends StatefulWidget {
  final int userId;

  const SmartReminderScreen({
    super.key,
    required this.userId,
  });

  @override
  State<SmartReminderScreen> createState() =>
      _SmartReminderScreenState();
}

class _SmartReminderScreenState
    extends State<SmartReminderScreen> {

  bool _loading = true;

  bool _regenerating = false;

  List<SmartReminder> reminders = [];

  @override
  void initState() {
    super.initState();

    _loadReminder();
  }

  Future<void> _loadReminder() async {

    setState(() {
      _loading = true;
    });

    reminders =
        await ApiService.getSmartReminders(
      widget.userId,
    );

    setState(() {
      _loading = false;
    });

  }

  Future<void> _regenerateReminder() async {

    setState(() {
      _regenerating = true;
    });

    await ApiService.regenerateReminder(
      widget.userId,
    );

    await _loadReminder();

    setState(() {
      _regenerating = false;
    });

  }

  Future<void> _completeReminder(
      SmartReminder reminder) async {

    final success =
        await ApiService.completeReminder(
      reminder.id,
    );

    if (success) {

      await _loadReminder();

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Smart Reminder",

          style: TextStyle(

            fontWeight: FontWeight.bold,

            color: Colors.white,

          ),

        ),

      ),

      body: _loading

          ? const Center(

              child:
                  CircularProgressIndicator(),

            )

          : RefreshIndicator(

              onRefresh: _loadReminder,

              child: Column(

                children: [

                  _buildHeader(),

                  Expanded(

                    child: reminders.isEmpty

                        ? _buildEmpty()

                        : ListView.builder(

                            padding:
                                const EdgeInsets.only(

                              left: 18,

                              right: 18,

                              bottom: 18,

                            ),

                            itemCount:
                                reminders.length,

                            itemBuilder:

                                (context, index) {

                              return _buildReminderCard(

                                reminders[index],

                              );

                            },

                          ),

                  ),

                ],

              ),

            ),

    );

  }
  Widget _buildHeader() {

  int completed =
      reminders.where((e) => e.isCompleted).length;

  double progress = reminders.isEmpty
      ? 0
      : completed / reminders.length;

  return Container(

    margin: const EdgeInsets.all(18),

    padding: const EdgeInsets.all(20),

    decoration: BoxDecoration(

      color: const Color(0xFF114232),

      borderRadius: BorderRadius.circular(24),

    ),

    child: Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const Row(

          children: [

            Icon(
              Icons.notifications_active,
              color: Color(0xFFC7F464),
            ),

            SizedBox(width: 10),

            Expanded(

              child: Text(

                "Today's Smart Reminder",

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 18,

                  fontWeight: FontWeight.bold,

                ),

              ),

            ),

          ],

        ),

        const SizedBox(height: 18),

        LinearProgressIndicator(

          value: progress,

          minHeight: 10,

          borderRadius:
              BorderRadius.circular(20),

          backgroundColor: Colors.white12,

          valueColor:
              const AlwaysStoppedAnimation(

            Color(0xFFC7F464),

          ),

        ),

        const SizedBox(height: 10),

        Text(

          "$completed / ${reminders.length} Reminder selesai",

          style: const TextStyle(

            color: Colors.white70,

          ),

        ),

        const SizedBox(height: 18),

        SizedBox(

          width: double.infinity,

          child: ElevatedButton.icon(

            onPressed: _regenerating

                ? null

                : _regenerateReminder,

            icon: _regenerating

                ? const SizedBox(

                    width: 18,

                    height: 18,

                    child:
                        CircularProgressIndicator(

                      strokeWidth: 2,

                    ),

                  )

                : const Icon(

                    Icons.refresh,

                  ),

            label: const Text(

              "Generate Ulang AI",

            ),

            style: ElevatedButton.styleFrom(

              backgroundColor:

                  const Color(0xFFC7F464),

              foregroundColor:

                  Colors.black,

              shape:

                  RoundedRectangleBorder(

                borderRadius:

                    BorderRadius.circular(18),

              ),

            ),

          ),

        ),

      ],

    ),

  );

}
Widget _buildEmpty() {

  return ListView(

    children: const [

      SizedBox(height: 140),

      Icon(

        Icons.notifications_off,

        size: 70,

        color: Colors.grey,

      ),

      SizedBox(height: 20),

      Center(

        child: Text(

          "Belum ada Smart Reminder",

          style: TextStyle(

            color: Colors.white,

            fontSize: 18,

            fontWeight: FontWeight.bold,

          ),

        ),

      ),

      SizedBox(height: 8),

      Center(

        child: Text(

          "Tekan Generate Ulang",

          style: TextStyle(

            color: Colors.grey,

          ),

        ),

      ),

    ],

  );

}
Widget _buildReminderCard(
  SmartReminder reminder,
) {

  return Card(

    color: const Color(0xFF161616),

    margin: const EdgeInsets.only(
      bottom: 16,
    ),

    shape: RoundedRectangleBorder(
      borderRadius:
          BorderRadius.circular(20),
    ),

    child: Padding(

      padding: const EdgeInsets.all(18),

      child: Row(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(

            width: 55,

            height: 55,

            decoration: BoxDecoration(

              color: _getReminderColor(
                reminder.reminderType,
              ),

              borderRadius:
                  BorderRadius.circular(16),

            ),

            child: Icon(

              _getReminderIcon(
                reminder.reminderType,
              ),

              color: Colors.white,

            ),

          ),

          const SizedBox(width: 16),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  reminder.title,

                  style: const TextStyle(

                    color: Colors.white,

                    fontSize: 16,

                    fontWeight:
                        FontWeight.bold,

                  ),

                ),

                const SizedBox(height: 6),

                Text(

                  reminder.message,

                  style: const TextStyle(

                    color: Colors.white70,

                    height: 1.5,

                  ),

                ),

                const SizedBox(height: 12),

                Row(

                  children: [

                    Icon(
                      Icons.schedule,
                      color: Colors.grey,
                      size: 16,
                    ),

                    const SizedBox(width: 6),

                    Text(

                      reminder.reminderTime,

                      style:
                          const TextStyle(

                        color: Colors.grey,

                      ),

                    ),

                  ],

                ),

              ],

            ),

          ),

          Checkbox(

            value:
                reminder.isCompleted,

            activeColor:
                const Color(0xFFC7F464),

            onChanged: (_) {

              _completeReminder(
                reminder,
              );

            },

          ),

        ],

      ),

    ),

  );

}
Color _getReminderColor(
  String type,
) {

  switch (type) {

    case "meal":
      return Colors.orange;

    case "water":
      return Colors.blue;

    case "exercise":
      return Colors.green;

    case "sleep":
      return Colors.indigo;

    case "motivation":
      return Colors.purple;

    default:
      return Colors.grey;

  }

}
IconData _getReminderIcon(
  String type,
) {

  switch (type) {

    case "meal":
      return Icons.restaurant;

    case "water":
      return Icons.water_drop;

    case "exercise":
      return Icons.directions_run;

    case "sleep":
      return Icons.bedtime;

    case "motivation":
      return Icons.favorite;

    default:
      return Icons.notifications;

  }

}
    }