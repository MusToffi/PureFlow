import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  late MqttServerClient client;
  Function(String, String)? onMessageCallback;

  Future<void> initializeMQTT(String brokerAddress, String clientId) async {
    client = MqttServerClient(brokerAddress, clientId);
    client.port = 1883; // Default MQTT port
    client.keepAlivePeriod = 30; // Try increasing the keep-alive period
    client.logging(on: true);
    client.autoReconnect = true; // Enable auto-reconnect for better stability

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMessage;

    try {
      await client.connect();
      print('Connected to MQTT broker');
    } catch (e) {
      print('Error connecting to MQTT broker: $e');
      client.disconnect();
      return; // Exit if connection fails
    }

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? events) {
      final recMess = events![0].payload as MqttPublishMessage;
      final message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      onMessageCallback?.call(events[0].topic, message);
    });
  }

  void subscribe(String topic) {
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      client.subscribe(topic, MqttQos.atLeastOnce);
      print('Subscribed to topic: $topic');
    } else {
      print('Cannot subscribe, not connected');
    }
  }

  void unsubscribe(String topic) {
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      client.unsubscribe(topic);
    } else {
      print('Cannot unsubscribe, not connected');
    }
  }

  void disconnect() {
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      client.disconnect();
      print('Disconnected from MQTT broker');
    }
  }
}
