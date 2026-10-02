import 'dart:convert';
import 'dart:js_interop';

@JS('sanctumSerialConnect')
external JSPromise<JSString> _serialConnect();

@JS('sanctumSerialReconnect')
external JSPromise<JSString> _serialReconnect();

@JS('sanctumSerialDiagnose')
external JSPromise<JSString> _serialDiagnose();

@JS('sanctumSerialDisconnect')
external JSPromise<JSAny?> _serialDisconnect();

class ArduinoSerial {
  bool get supported => true;

  Future<Map<String, dynamic>> connect() async =>
      _decode(await _serialConnect().toDart);

  Future<Map<String, dynamic>> reconnect() async =>
      _decode(await _serialReconnect().toDart);

  Future<Map<String, dynamic>> diagnose() async =>
      _decode(await _serialDiagnose().toDart);

  Future<void> disconnect() async {
    await _serialDisconnect().toDart;
  }

  Map<String, dynamic> _decode(JSString value) =>
      (jsonDecode(value.toDart) as Map).cast<String, dynamic>();
}
