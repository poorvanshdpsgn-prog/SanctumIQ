import 'package:flutter/material.dart';

import '../utils/arduino_serial_stub.dart'
    if (dart.library.js_interop) '../utils/arduino_serial_web.dart';

import '../theme/app_colors.dart';
import '../widgets/cyber_grid.dart';
import '../widgets/glass_panel.dart';
import '../widgets/section_header.dart';
import '../widgets/site_page_header.dart';
import '../widgets/status_indicator.dart';

/// Future contract for trusted-firmware recovery, which remains separate from
/// browser serial diagnostics because web pages cannot run Arduino flash tools.
abstract interface class HardwareDiagnosticsGateway {
  Future<DiagnosticRun> runDiagnostics();
  Future<FirmwareRestoreResult> restoreTrustedFirmware();
  Future<bool> verifyTrustedFirmware();
}

enum HardwareHealth { healthy, warning, fault, missing, notTested }

class ComponentHealth {
  const ComponentHealth({
    required this.name,
    required this.detail,
    this.health = HardwareHealth.notTested,
  });
  final String name;
  final String detail;
  final HardwareHealth health;
}

class DiagnosticRun {
  const DiagnosticRun({required this.components, required this.completedAt});
  final List<ComponentHealth> components;
  final DateTime completedAt;
}

class FirmwareRestoreResult {
  const FirmwareRestoreResult({required this.success, required this.message});
  final bool success;
  final String message;
}

class DiagnosticsPage extends StatefulWidget {
  const DiagnosticsPage({super.key});

  static const _defaultComponents = [
    ComponentHealth(
      name: 'Arduino Uno',
      detail: 'Controller connection / agent handshake',
    ),
    ComponentHealth(
      name: 'Ultrasonic sensor',
      detail: 'Distance response / access sensing',
    ),
    ComponentHealth(
      name: 'Analog moisture sensor',
      detail: 'Analog reading / water detection',
    ),
    ComponentHealth(
      name: 'RC522 RFID reader',
      detail: 'Reader response / authorized access',
    ),
    ComponentHealth(
      name: 'Servo motor',
      detail: 'Movement / surveillance positioning',
    ),
    ComponentHealth(
      name: 'DS3231 RTC',
      detail: 'Clock communication / timekeeping',
    ),
    ComponentHealth(
      name: 'OLED display',
      detail: 'Display communication / status output',
    ),
  ];

  @override
  State<DiagnosticsPage> createState() => _DiagnosticsPageState();
}

class _DiagnosticsPageState extends State<DiagnosticsPage> {
  final _serial = ArduinoSerial();
  late List<ComponentHealth> _components = DiagnosticsPage._defaultComponents;
  bool _connected = false;
  bool _connecting = false;
  bool _testing = false;
  String _connectionMessage =
      'No authorized Arduino port detected. Connect to choose a serial device.';

  @override
  void initState() {
    super.initState();
    _tryReconnectAuthorizedPort();
  }

  Future<void> _tryReconnectAuthorizedPort() async {
    final result = await _serial.reconnect();
    if (!mounted || result['ok'] != true) return;
    setState(() {
      _connected = true;
      _connectionMessage =
          result['message'] as String? ?? 'Arduino reconnected.';
    });
  }

  Future<void> _connect() async {
    setState(() => _connecting = true);
    final result = await _serial.connect();
    if (!mounted) return;
    setState(() {
      _connecting = false;
      _connected = result['ok'] == true;
      _connectionMessage = result['message'] as String? ?? 'Connection failed.';
    });
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      _testing = true;
      _connectionMessage = 'Requesting component diagnostics…';
    });
    final result = await _serial.diagnose();
    if (!mounted) return;
    final report = result['report'];
    if (result['ok'] == true && report is Map && report['components'] is Map) {
      final values = (report['components'] as Map).cast<String, dynamic>();
      const keys = [
        'arduino',
        'ultrasonic',
        'moisture',
        'rfid',
        'servo',
        'rtc',
        'oled',
      ];
      setState(() {
        _components = List.generate(DiagnosticsPage._defaultComponents.length, (
          i,
        ) {
          final original = DiagnosticsPage._defaultComponents[i];
          return ComponentHealth(
            name: original.name,
            detail: original.detail,
            health: _parseHealth(values[keys[i]]),
          );
        });
        _testing = false;
        _connectionMessage =
            result['message'] as String? ?? 'Diagnostic report received.';
      });
    } else {
      setState(() {
        _testing = false;
        _connectionMessage =
            result['message'] as String? ?? 'Diagnostic request failed.';
      });
    }
  }

  HardwareHealth _parseHealth(dynamic value) {
    switch (value?.toString().toUpperCase()) {
      case 'HEALTHY':
        return HardwareHealth.healthy;
      case 'WARNING':
        return HardwareHealth.warning;
      case 'FAULT':
        return HardwareHealth.fault;
      case 'MISSING':
        return HardwareHealth.missing;
      default:
        return HardwareHealth.notTested;
    }
  }

  Future<void> _disconnect() async {
    await _serial.disconnect();
    if (!mounted) return;
    setState(() {
      _connected = false;
      _components = DiagnosticsPage._defaultComponents;
      _connectionMessage = 'Arduino disconnected.';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        const Positioned.fill(child: CyberGrid()),
        CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: SitePageHeader(currentPage: 'diagnostics'),
            ),
            SliverToBoxAdapter(child: _content(context)),
            const SliverToBoxAdapter(child: _PageFooter()),
          ],
        ),
      ],
    ),
  );

  Widget _content(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 64, 24, 80),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusIndicator(
              label: _connected
                  ? 'ARDUINO SERIAL / CONNECTED'
                  : 'ARDUINO SERIAL / NOT CONNECTED',
            ),
            const SizedBox(height: 24),
            Text(
              'Hardware health,\nmade visible.',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: MediaQuery.sizeOf(context).width < 600 ? 43 : 64,
                height: 1.06,
                letterSpacing: -2.5,
              ),
            ),
            const SizedBox(height: 18),
            const SizedBox(
              width: 690,
              child: Text(
                'Connect to an Arduino over USB serial, request component checks, and see missing hardware called out clearly. The board must implement the Sanctum IQ diagnostic response protocol.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 15,
                  height: 1.8,
                ),
              ),
            ),
            const SizedBox(height: 30),
            _connectionBanner(),
            const SizedBox(height: 44),
            const SectionHeader(
              number: '01',
              eyebrow: 'COMPONENT INVENTORY',
              title: 'Expected hardware',
              subtitle: 'Connect over USB, then run the board diagnostic command. Components without an explicit response remain NOT TESTED; missing is shown only when the board reports MISSING.',
            ),
            const SizedBox(height: 24),
            _componentList(),
            if (_components.any(
              (item) => item.health == HardwareHealth.missing,
            )) ...[
              const SizedBox(height: 12),
              _missingAlert(),
            ],
            const SizedBox(height: 38),
            const SectionHeader(
              number: '02',
              eyebrow: 'AFTER THE CHECK',
              title: 'Restore a known-good state',
              subtitle: 'Firmware restoration is not connected yet. The current site can request and display diagnostics; trusted-firmware flashing and verification still require a separate recovery integration.',
            ),
            const SizedBox(height: 24),
            _recoveryFlow(),
            const SizedBox(height: 24),
            _protocolNote(),
          ],
        ),
      ),
    ),
  );

  Widget _connectionBanner() => GlassPanel(
    padding: const EdgeInsets.all(20),
    child: LayoutBuilder(
      builder: (context, box) {
        final narrow = box.maxWidth < 650;
        final copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MicroLabel(
              _connected
                  ? 'SERIAL DEVICE CONNECTED'
                  : 'BROWSER SERIAL CONNECTION',
            ),
            const SizedBox(height: 8),
            Text(
              _connected
                  ? 'Arduino serial connection is open.'
                  : 'Connect your Arduino over USB serial.',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _connectionMessage,
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ],
        );
        final tag = Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_connected)
                OutlinedButton(
                  onPressed: _testing ? null : _runDiagnostics,
                  child: Text(_testing ? 'TESTING…' : 'RUN DIAGNOSTICS'),
                ),
              OutlinedButton(
                onPressed: _connecting || _testing
                    ? null
                    : (_connected ? _disconnect : _connect),
                child: Text(
                  _connecting
                      ? 'CONNECTING…'
                      : (_connected ? 'DISCONNECT' : 'CONNECT ARDUINO'),
                ),
              ),
            ],
          ),
        );
        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [copy, const SizedBox(height: 16), tag],
          );
        }
        return Row(
          children: [
            Expanded(child: copy),
            const SizedBox(width: 18),
            tag,
          ],
        );
      },
    ),
  );

  Widget _componentList() => GlassPanel(
    padding: EdgeInsets.zero,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: const Row(
            children: [
              Expanded(child: _MicroLabel('EXPECTED COMPONENT')),
              _MicroLabel('HEALTH STATE'),
            ],
          ),
        ),
        for (var i = 0; i < _components.length; i++) ...[
          _ComponentRow(component: _components[i]),
          if (i != _components.length - 1)
            const Divider(height: 1, indent: 18, endIndent: 18),
        ],
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 15, color: AppColors.cyan),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  '${_components.length} expected items · ${_components.where((c) => c.health != HardwareHealth.notTested).length} tested',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontFamily: 'monospace',
                    fontSize: 9,
                    letterSpacing: .4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _recoveryFlow() => LayoutBuilder(
    builder: (context, box) {
      final steps = [
        ('01', 'CONNECT', 'Select and open the Arduino USB serial port.'),
        ('02', 'DIAGNOSE', 'Check controller and expected components.'),
        (
          '03',
          'REPORT',
          'Show healthy, warning, fault, missing, or not tested.',
        ),
        (
          '04',
          'RESTORE + VERIFY',
          'Flash trusted firmware and confirm its identity.',
        ),
      ];
      final cards = steps
          .map((s) => _FlowCard(number: s.$1, title: s.$2, detail: s.$3))
          .toList();
      if (box.maxWidth < 760) {
        return Column(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              cards[i],
            ],
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(child: cards[i]),
          ],
        ],
      );
    },
  );

  Widget _missingAlert() {
    final missing = _components
        .where((item) => item.health == HardwareHealth.missing)
        .map((item) => item.name)
        .join(', ');
    return GlassPanel(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.amber,
            size: 19,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EXPECTED COMPONENT MISSING',
                  style: TextStyle(
                    color: AppColors.amber,
                    fontFamily: 'monospace',
                    fontSize: 10,
                    letterSpacing: .8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$missing · Check the component connection and wiring.',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _protocolNote() => GlassPanel(
    padding: const EdgeInsets.all(18),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MicroLabel('BOARD DIAGNOSTIC PROTOCOL'),
        SizedBox(height: 12),
        _Bullet(
          'Serial speed: 115200 baud. Connect opens a browser-approved serial port.',
        ),
        _Bullet(
          'Request: {"protocol":"sanctum-iq/1","command":"diagnostics"} followed by a newline.',
        ),
        _Bullet(
          'Reply: one JSON line with protocol "sanctum-iq/1" and component states for arduino, ultrasonic, moisture, rfid, servo, rtc, and oled.',
        ),
        SizedBox(height: 8),
        Text(
          'The website sends the request and parses the response. The current firmware was not changed; it must implement this protocol before component tests can return real results.',
          style: TextStyle(color: AppColors.muted, fontSize: 11, height: 1.6),
        ),
      ],
    ),
  );
}

class _ComponentRow extends StatelessWidget {
  const _ComponentRow({required this.component});
  final ComponentHealth component;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
    child: Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Icon(Icons.memory, color: AppColors.cyan, size: 15),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                component.name,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                component.detail,
                style: const TextStyle(color: AppColors.muted, fontSize: 10),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _HealthBadge(health: component.health),
      ],
    ),
  );
}

class _HealthBadge extends StatelessWidget {
  const _HealthBadge({required this.health});
  final HardwareHealth health;
  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (health) {
      HardwareHealth.healthy => ('HEALTHY', AppColors.green),
      HardwareHealth.warning => ('WARNING', AppColors.amber),
      HardwareHealth.fault => ('FAULT', AppColors.red),
      HardwareHealth.missing => ('MISSING', AppColors.red),
      HardwareHealth.notTested => ('NOT TESTED', AppColors.muted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: .42)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontFamily: 'monospace',
          fontSize: 8,
          letterSpacing: .55,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _FlowCard extends StatelessWidget {
  const _FlowCard({
    required this.number,
    required this.title,
    required this.detail,
  });
  final String number, title, detail;
  @override
  Widget build(BuildContext context) => GlassPanel(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            color: AppColors.cyan,
            fontFamily: 'monospace',
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.text,
            fontFamily: 'monospace',
            fontSize: 10,
            letterSpacing: .7,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          detail,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 11,
            height: 1.6,
          ),
        ),
      ],
    ),
  );
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('› ', style: TextStyle(color: AppColors.cyan)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}

class _MicroLabel extends StatelessWidget {
  const _MicroLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: AppColors.muted,
      fontFamily: 'monospace',
      fontSize: 8,
      letterSpacing: 1.1,
      fontWeight: FontWeight.w600,
    ),
  );
}

class _PageFooter extends StatelessWidget {
  const _PageFooter();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: AppColors.border)),
    ),
    child: const Center(
      child: Text(
        'SANCTUM IQ  /  HARDWARE HEALTH  /  PROTOTYPE',
        style: TextStyle(
          color: AppColors.muted,
          fontFamily: 'monospace',
          fontSize: 9,
          letterSpacing: .8,
        ),
      ),
    ),
  );
}
