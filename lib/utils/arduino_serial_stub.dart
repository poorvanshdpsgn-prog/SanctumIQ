class ArduinoSerial {
  bool get supported => false;

  Future<Map<String, dynamic>> connect() async => {
    'ok': false,
    'message': 'Arduino serial access is available in supported desktop browsers over HTTPS.',
  };

  Future<Map<String, dynamic>> reconnect() async => {'ok': false};

  Future<Map<String, dynamic>> diagnose() async => {
    'ok': false,
    'message': 'Serial diagnostics are unavailable on this platform.',
  };

  Future<void> disconnect() async {}
}
