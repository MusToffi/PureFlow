import 'package:flutter/material.dart';
import 'mqtt_func.dart'; // import your MqttService here

class WaterDataWidget extends StatefulWidget {
  const WaterDataWidget({Key? key}) : super(key: key);

  @override
  State<WaterDataWidget> createState() => _WaterDataWidgetState();
}

class _WaterDataWidgetState extends State<WaterDataWidget> {
  final MqttService mqttService = MqttService();
  int score = 95; // Default initial score
  String riverName = 'Sg. Pahang';
  String status = 'Healthy';
  String availability = 'High';
  String updatedTime = '10:23 am';

  @override
  void initState() {
    super.initState();
    initializeMqtt();
  }

 Future<void> initializeMqtt() async {
  try {
    await mqttService.initializeMQTT('broker.hivemq.com', 'flutter_clientX1');
    mqttService.subscribe('waterqweqwe/topicq');

    // Set the callback function
    mqttService.onMessageCallback = (topic, message) {
      setState(() {
        score = int.tryParse(message) ?? score;
        updatedTime = getCurrentTime();
      });
    };
  } catch (e) {
    print('Error during MQTT initialization: $e');
  }
}

  String getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(197, 238, 238, 238),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Water-data',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '$score',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    riverName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'Status: ',
                        style: TextStyle(color: Colors.black87),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Text(
                        'Availability: ',
                        style: TextStyle(color: Colors.black87),
                      ),
                      Text(
                        availability,
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Text(
                        'Updated: ',
                        style: TextStyle(color: Colors.black87),
                      ),
                      Text(
                        updatedTime,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
  }
}
