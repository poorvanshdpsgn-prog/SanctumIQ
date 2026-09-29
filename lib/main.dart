import 'package:flutter/material.dart';

import 'pages/contact_page.dart';
import 'pages/team_page.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';
import 'widgets/cyber_grid.dart';
import 'widgets/glass_panel.dart';
import 'widgets/section_header.dart';
import 'widgets/sci_button.dart';
import 'widgets/status_indicator.dart';

void main() => runApp(const SanctumIQApp());

class SanctumIQApp extends StatelessWidget {
  const SanctumIQApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Sanctum IQ | Protecting What Matters',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const HomePage(),
        routes: {
          '/team': (_) => const TeamPage(),
          '/contact': (_) => const ContactPage(),
        },
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _sectionKeys = List.generate(9, (_) => GlobalKey());
  bool _menuOpen = false;

  void _goTo(int index) {
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOutCubic,
          alignment: .04);
    }
    setState(() => _menuOpen = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(children: [
          const Positioned.fill(child: CyberGrid()),
          CustomScrollView(controller: _scrollController, slivers: [
            SliverToBoxAdapter(child: _navigation()),
            SliverToBoxAdapter(child: _hero()),
            SliverToBoxAdapter(child: _signalBar()),
            SliverToBoxAdapter(child: _problem()),
            SliverToBoxAdapter(child: _solution()),
            SliverToBoxAdapter(child: _architecture()),
            SliverToBoxAdapter(child: _intelligence()),
            SliverToBoxAdapter(child: _effectiveness()),
            SliverToBoxAdapter(child: _technology()),
            SliverToBoxAdapter(child: _demo()),
            SliverToBoxAdapter(child: _about()),
            SliverToBoxAdapter(child: _footer()),
          ]),
          if (_menuOpen) _mobileMenu(),
        ]),
      );

  Widget _navigation() => LayoutBuilder(builder: (context, constraints) {
        final mobile = constraints.maxWidth < 1100;
        return Container(
          height: 76,
          padding: EdgeInsets.symmetric(horizontal: mobile ? 22 : 56),
          decoration: const BoxDecoration(
              color: Color(0xee07100f),
              border: Border(bottom: BorderSide(color: AppColors.border))),
          child: Row(children: [
            const _Brand(),
            const Spacer(),
            if (!mobile) ...[
              _navLink('HOW IT WORKS', 3), _navLink('FEATURES', 4),
              _navLink('ABOUT', 8),
              TextButton(onPressed: () => Navigator.pushNamed(context, '/team'), child: const Text('TEAM', style: TextStyle(color: AppColors.muted, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w700))),
              TextButton(onPressed: () => Navigator.pushNamed(context, '/contact'), child: const Text('CONTACT', style: TextStyle(color: AppColors.muted, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w700))),
              const SizedBox(width: 12),
              SciButton(label: 'PROTECT WHAT MATTERS', compact: true,
                  onPressed: () => _goTo(7)),
            ] else
              IconButton(
                onPressed: () => setState(() => _menuOpen = !_menuOpen),
                icon: Icon(_menuOpen ? Icons.close : Icons.menu,
                    color: AppColors.cyan),
                tooltip: 'Open navigation',
              ),
          ]),
        );
      });

  Widget _navLink(String label, int section) => TextButton(
        onPressed: () => _goTo(section),
        child: Text(label, style: const TextStyle(
            color: AppColors.muted, fontSize: 10, letterSpacing: 1.2,
            fontWeight: FontWeight.w700)),
      );

  Widget _mobileMenu() => Positioned(
        top: 76, left: 0, right: 0,
        child: Container(
          color: AppColors.panel,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            for (final item in [('HOW IT WORKS', 3), ('FEATURES', 4), ('ABOUT', 8)])
              TextButton(
                onPressed: () => _goTo(item.$2),
                child: Align(alignment: Alignment.centerLeft,
                    child: Text(item.$1, style: const TextStyle(
                        color: AppColors.text, letterSpacing: 1.5)))),
            TextButton(onPressed: () { Navigator.pushNamed(context, '/team'); setState(() => _menuOpen = false); }, child: const Align(alignment: Alignment.centerLeft, child: Text('TEAM', style: TextStyle(color: AppColors.text, letterSpacing: 1.5)))),
            TextButton(onPressed: () { Navigator.pushNamed(context, '/contact'); setState(() => _menuOpen = false); }, child: const Align(alignment: Alignment.centerLeft, child: Text('CONTACT', style: TextStyle(color: AppColors.text, letterSpacing: 1.5)))),
            SciButton(label: 'SEE THE SYSTEM',
                onPressed: () => _goTo(7)),
          ]),
        ),
      );

  Widget _hero() => Container(
        key: _sectionKeys[0],
        constraints: const BoxConstraints(minHeight: 630),
        padding: const EdgeInsets.fromLTRB(24, 94, 24, 70),
        child: Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(builder: (context, box) {
            final stacked = box.maxWidth < 820;
            final copy = Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, children: [
              const StatusIndicator(label: 'SMART BAG SECURITY / READY'),
              const SizedBox(height: 30),
              Text('Protect what\nmatters. Keep\nmoving.',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: box.maxWidth < 600 ? 54 : 74,
                  height: 1.04, letterSpacing: -3.2)),
              const SizedBox(height: 24),
              ConstrainedBox(constraints: const BoxConstraints(maxWidth: 510), child: const Text(
                'An affordable smart security companion for your everyday bag—helping protect your belongings and keep your workday on track.',
                style: TextStyle(color: AppColors.muted, fontSize: 16, height: 1.8))),
              const SizedBox(height: 32),
              Wrap(spacing: 12, runSpacing: 12, children: [
                SciButton(label: 'EXPLORE THE FEATURES',
                    onPressed: () => _goTo(4)),
                SciButton(label: 'HOW IT WORKS', outlined: true,
                    onPressed: () => _goTo(3)),
              ]),
              const SizedBox(height: 46),
              const Wrap(spacing: 26, runSpacing: 12, children: [
                _TinyFact(value: 'SECURITY', label: 'FOR YOUR BELONGINGS'),
                _TinyFact(value: 'REMINDERS', label: 'FOR YOUR DAY'),
                _TinyFact(value: 'PLUG & USE', label: 'ON THE BAG YOU OWN'),
              ]),
            ]);
            if (stacked) {
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                copy, _commandVisual(compact: true),
              ]);
            }
            return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(flex: 11, child: copy), const SizedBox(width: 50),
              Expanded(flex: 9, child: _commandVisual(compact: false)),
            ]);
          }),
        )),
      );

  Widget _commandVisual({required bool compact}) => Padding(
        padding: EdgeInsets.only(top: compact ? 54 : 0),
        child: GlassPanel(padding: const EdgeInsets.all(0), child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(height: 46, padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
              child: const Row(children: [StatusIndicator(label: 'PROTOTYPE OVERVIEW', small: true), Spacer(), _MicroLabel('ILLUSTRATIVE')]),
            ),
            Padding(padding: const EdgeInsets.all(20), child: Column(children: [
              Row(children: [
                Expanded(child: _metric('ACCESS CONTROL', 'RFID', 'AUTHORIZED OVERRIDE', AppColors.green)),
                const SizedBox(width: 12), Expanded(child: _metric('MOBILE ALERTS', 'BLE', 'BLUETOOTH LINK', AppColors.cyan)),
              ]),
              const SizedBox(height: 18),
              Container(height: compact ? 170 : 148, padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Row(children: [_MicroLabel('BAG + SMART MODULE'), Spacer(), _MicroLabel('OVERVIEW')]),
                  const SizedBox(height: 16), Expanded(child: _systemDiagram()),
                ])),
              const SizedBox(height: 12),
              for (final row in [('UNAUTHORIZED ACCESS', 'RFID OVERRIDE', AppColors.amber), ('MOISTURE SENSOR', 'MONITORING', AppColors.cyan), ('MEETING REMINDERS', 'RTC / OLED', AppColors.green)])
                Padding(padding: const EdgeInsets.symmetric(vertical: 9), child: Row(children: [
                  Container(width: 5, height: 5, decoration: BoxDecoration(color: row.$3, shape: BoxShape.circle)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(row.$1, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 9, letterSpacing: .8, color: AppColors.muted))),
                  const SizedBox(width: 8),
                  Flexible(child: Align(alignment: Alignment.centerRight, child: Text(row.$2, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: 'monospace', fontSize: 9, letterSpacing: .6, color: row.$3)))),
                ])),
            ])),
          ])),
      );

  Widget _metric(String title, String value, String note, Color color) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _MicroLabel(title), const SizedBox(height: 15),
          Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: color, letterSpacing: -1)),
          const SizedBox(height: 4), Text(note, style: const TextStyle(fontFamily: 'monospace', fontSize: 8, color: AppColors.muted, letterSpacing: .3)),
        ]));

  Widget _signalBar() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: const BoxDecoration(color: Color(0x990b1715), border: Border.symmetric(horizontal: BorderSide(color: AppColors.border))),
        child: Center(child: Wrap(alignment: WrapAlignment.center, spacing: 34, runSpacing: 14,
          children: const [ _MicroLabel('AFFORDABLE SMART SECURITY'), _MicroLabel('FITS YOUR EVERYDAY BAG'), _MicroLabel('PROTECTING WHAT MATTERS') ])),
      );

  Widget _problem() => _section(key: _sectionKeys[1], number: '01', eyebrow: 'THE PROBLEM', title: 'A regular bag cannot protect what is inside.', subtitle: 'Laptops, confidential documents, and everyday electronics travel with us. A conventional bag carries them, but cannot alert us to unauthorized access, water intrusion, or a missed meeting.', child: LayoutBuilder(builder: (context, box) {
    final cols = box.maxWidth > 760 ? 3 : 1;
    return _grid(cols, [
      _infoCard('01 / UNAUTHORIZED ACCESS', 'Regular bags offer little warning if someone opens or interferes with them.', Icons.lock_open_outlined, AppColors.cyan),
      _infoCard('02 / WATER DAMAGE', 'A small spill or leak can put laptops and important documents at risk.', Icons.water_drop_outlined, AppColors.amber),
      _infoCard('03 / MISSED MOMENTS', 'Busy workdays make it easy to miss a meeting reminder or a useful alert.', Icons.event_busy_outlined, AppColors.red),
    ]);
  }));

  Widget _solution() => _section(key: _sectionKeys[2], number: '02', eyebrow: 'THE SOLUTION', title: 'A smart companion for the bag you already own.', subtitle: 'Sanctum IQ turns an everyday office bag into a more secure, helpful companion—with alerts and reminders built around your routine.', child: LayoutBuilder(builder: (context, box) {
    final horizontal = box.maxWidth > 760;
    final overview = GlassPanel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const StatusIndicator(label: 'AFFORDABLE / PRACTICAL / PLUG & USE'), const SizedBox(height: 24),
        Text('Protection that moves with you.', style: Theme.of(context).textTheme.headlineMedium?.copyWith(height: 1.2)),
        const SizedBox(height: 18), const Text('Attach the system to a bag, suitcase, or kit without changing its structure. Sanctum IQ watches for suspicious access and moisture, keeps time and reminders visible, and can notify your phone over Bluetooth.', style: TextStyle(color: AppColors.muted, height: 1.8)),
      ]));
    final steps = Column(children: [
        _featureLine('01', 'SENSE', 'Ultrasonic sensors watch for access and nearby movement.'),
        _featureLine('02', 'VERIFY', 'An RFID card authorizes access and helps prevent false alarms.'),
        _featureLine('03', 'ALERT', 'The system shows status on its OLED and sends Bluetooth alerts.'),
        _featureLine('04', 'STAY ON TIME', 'The RTC keeps the clock and meeting reminders accurate.'),
      ]);
    if (!horizontal) return Column(children: [overview, const SizedBox(height: 16), steps]);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: overview), const SizedBox(width: 18), Expanded(child: steps),
    ]);
  }));

  Widget _architecture() => _section(key: _sectionKeys[3], number: '03', eyebrow: 'HOW IT WORKS', title: 'A small system with a clear job.', subtitle: 'Sensors detect changes around the bag. The controller checks access, updates the display, and shares important alerts.', child: LayoutBuilder(builder: (context, box) {
    final cols = box.maxWidth > 760 ? 4 : 1;
    return _grid(cols, [
      _stepCard('01', 'DETECT', 'Ultrasonic sensors watch for unauthorized opening and nearby movement.'),
      _stepCard('02', 'AUTHORIZE', 'Use the RC522 RFID module as an authorized-access override.'),
      _stepCard('03', 'INFORM', 'See time, reminders, and system status on the OLED; moisture is detected inside the bag.'),
      _stepCard('04', 'CONNECT', 'Bluetooth sends real-time notifications to the connected mobile app.'),
    ]);
  }));

  Widget _intelligence() => _section(key: _sectionKeys[4], number: '04', eyebrow: 'KEY FEATURES', title: 'Everyday protection, built in.', subtitle: 'Six practical features bring security and helpful reminders into one compact bag system.', child: LayoutBuilder(builder: (context, box) {
    final cols = box.maxWidth > 760 ? 3 : 1;
    return _grid(cols, [
      _infoCard('UNAUTHORIZED ACCESS', 'Detect suspicious opening of the bag and alert the user. RFID provides an authorized-access override.', Icons.lock_outline, AppColors.cyan),
      _infoCard('REAL-TIME MOBILE ALERTS', 'Send instant notifications to the connected mobile application via Bluetooth.', Icons.bluetooth, AppColors.cyan),
      _infoCard('MEETING REMINDERS', 'The DS3231 real-time clock keeps time and scheduled reminders ready to display.', Icons.event_available_outlined, AppColors.green),
      _infoCard('MOISTURE DETECTION', 'Detect water intrusion inside the bag to help protect laptops and important documents.', Icons.water_drop_outlined, AppColors.amber),
      _infoCard('ACTIVE SURVEILLANCE', 'A servo-mounted ultrasonic sensor monitors nearby movement around the bag.', Icons.radar, AppColors.purple),
      _infoCard('SMART OLED DISPLAY', 'Check the time, reminders, system status, and alerts at a glance.', Icons.memory, AppColors.green),
    ]);
  }));

  Widget _effectiveness() => _section(key: _sectionKeys[5], number: '05', eyebrow: 'DESIGNED FOR EVERYDAY USE', title: 'Practical protection, without replacing your bag.', subtitle: 'The project focuses on useful safeguards and reminders in a system that is affordable, portable, and adaptable.', child: LayoutBuilder(builder: (context, box) {
    final cols = box.maxWidth > 760 ? 3 : 1;
    return _grid(cols, [
      _effectCard('PROTECT BELONGINGS', 'Monitor access and moisture around the items you carry to work.'),
      _effectCard('FIT YOUR ROUTINE', 'Keep time and meeting reminders visible while notifications reach your phone.'),
      _effectCard('USE WHAT YOU OWN', 'Attach it to a bag, suitcase, or kit without modifying the original structure.'),
    ]);
  }));

  Widget _technology() => _section(key: _sectionKeys[6], number: '06', eyebrow: 'THE PROTOTYPE', title: 'Straightforward components. One useful system.', subtitle: 'An Arduino Uno connects the sensors, RFID reader, display, real-time clock, and servo into a compact prototype.', child: LayoutBuilder(builder: (context, box) {
    final horizontal = box.maxWidth > 760;
    final details = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _trustItem('ARDUINO UNO', 'Main microcontroller for system operation.'),
        _trustItem('TWO HC-SR04 ULTRASONIC SENSORS', 'Detect unauthorized access and monitor nearby surroundings.'),
        _trustItem('DS3231 RTC + OLED', 'Maintain accurate time and show reminders, status, and alerts.'),
      ]);
    final principles = GlassPanel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const _MicroLabel('ADDITIONAL COMPONENTS'), const SizedBox(height: 22),
        for (final v in ['Analog moisture sensor', 'Servo motor for active surveillance', 'RC522 RFID authorized-access override', 'Breadboard, jumper wires, and office bag'])
          Padding(padding: const EdgeInsets.only(bottom: 17), child: Row(children: [const Icon(Icons.check, size: 15, color: AppColors.green), const SizedBox(width: 12), Expanded(child: Text(v, style: const TextStyle(color: AppColors.text, fontSize: 13)))])),
        const SizedBox(height: 4),
        const Text('A power bank powers the current demonstration prototype. Rechargeable batteries are planned for a future model.', style: TextStyle(color: AppColors.muted, fontSize: 11, height: 1.7)),
      ]));
    if (!horizontal) return Column(children: [details, const SizedBox(height: 20), principles]);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: details), const SizedBox(width: 32), Expanded(child: principles),
    ]);
  }));

  Widget _demo() => Container(key: _sectionKeys[7],
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
    child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1180), child: GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 48),
      child: LayoutBuilder(builder: (context, box) {
        final stacked = box.maxWidth < 760;
        final copy = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const StatusIndicator(label: 'SANCTUM IQ / PROTOTYPE'), const SizedBox(height: 20),
              Text('Protection for\nwhat you carry.', style: Theme.of(context).textTheme.headlineMedium?.copyWith(height: 1.16)),
              const SizedBox(height: 16), const Text('A smart office-bag companion designed to help keep your belongings safe and your day on schedule.', style: TextStyle(color: AppColors.muted, height: 1.7)),
            ]);
        final button = SciButton(label: 'SEE HOW IT WORKS', onPressed: () => _goTo(3));
        if (stacked) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [copy, const SizedBox(height: 24), button]);
        return Row(children: [Expanded(child: copy), const SizedBox(width: 30), button]);
      }),
    ))));

  Widget _about() => _section(key: _sectionKeys[8], number: '07', eyebrow: 'ABOUT SANCTUM IQ', title: 'Protecting what matters.', subtitle: 'Sanctum IQ is an entrepreneurship and financial literacy project: an affordable smart security system that makes an everyday bag more helpful and protective.', child: GlassPanel(child: LayoutBuilder(builder: (context, box) {
    final horizontal = box.maxWidth > 760;
    final headline = Text('A smart companion for work.', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.cyan));
    const body = Text('Designed to keep valuable items safer while helping people stay productive, Sanctum IQ brings access sensing, moisture detection, mobile alerts, and meeting reminders into one practical system. It can be attached to a bag, suitcase, or kit without changing its structure.', style: TextStyle(color: AppColors.muted, height: 1.9));
    if (!horizontal) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [headline, const SizedBox(height: 18), body]);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 2, child: headline), const SizedBox(width: 40), const Expanded(flex: 3, child: body)]);
  })));

  Widget _footer() => Container(
    padding: const EdgeInsets.fromLTRB(24, 32, 24, 26),
    decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border)), color: Color(0xaa07100f)),
    child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1180), child: Column(children: [
      Row(children: [const _Brand(), const Spacer(), const StatusIndicator(label: 'PROTOTYPE / IN DEVELOPMENT', small: true)]),
      const SizedBox(height: 28), const Divider(color: AppColors.border, height: 1),
      const SizedBox(height: 18), Row(children: [
        const Expanded(child: Text('© 2026 SANCTUM IQ. PROTECTING WHAT MATTERS.', style: TextStyle(fontFamily: 'monospace', fontSize: 9, letterSpacing: .7, color: AppColors.muted))),
        TextButton(onPressed: () => _goTo(0), child: const Text('BACK TO TOP ↑', style: TextStyle(color: AppColors.cyan, fontFamily: 'monospace', fontSize: 9, letterSpacing: 1))),
      ]),
    ]))));

  Widget _section({required Key key, required String number, required String eyebrow, required String title, required String subtitle, required Widget child}) =>
      Container(key: key, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 78),
        child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1180), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SectionHeader(number: number, eyebrow: eyebrow, title: title, subtitle: subtitle),
          const SizedBox(height: 34), child,
        ]))));

  Widget _grid(int columns, List<Widget> children) => LayoutBuilder(builder: (context, box) {
    final spacing = 14.0;
    final itemWidth = (box.maxWidth - spacing * (columns - 1)) / columns;
    return Wrap(spacing: spacing, runSpacing: spacing,
      children: children.map((child) => SizedBox(width: itemWidth, child: child)).toList());
  });

  Widget _infoCard(String label, String body, IconData icon, Color color) => GlassPanel(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 21), const SizedBox(height: 20),
      _MicroLabel(label), const SizedBox(height: 12),
      Text(body, style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.75)),
    ]));

  Widget _stepCard(String no, String title, String body) => GlassPanel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(no, style: const TextStyle(color: AppColors.cyan, fontFamily: 'monospace', fontSize: 12, letterSpacing: 1.5)),
    const SizedBox(height: 26), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1)),
    const SizedBox(height: 12), Text(body, style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.7)),
  ]));

  Widget _featureLine(String no, String title, String body) => Container(
    margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: AppColors.panel, borderRadius: BorderRadius.circular(9), border: Border.all(color: AppColors.border)),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(no, style: const TextStyle(color: AppColors.cyan, fontFamily: 'monospace', fontSize: 11)),
      const SizedBox(width: 18), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: AppColors.text, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
        const SizedBox(height: 7), Text(body, style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.6)),
      ])),
    ]));

  Widget _effectCard(String title, String body) => GlassPanel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Icon(Icons.arrow_outward, size: 17, color: AppColors.green), const SizedBox(height: 21),
    _MicroLabel(title), const SizedBox(height: 11), Text(body, style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.75)),
  ]));

  Widget _trustItem(String title, String body) => Padding(padding: const EdgeInsets.only(bottom: 23), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Icon(Icons.verified_user_outlined, color: AppColors.cyan, size: 17), const SizedBox(width: 14),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontFamily: 'monospace', color: AppColors.text, fontSize: 10, letterSpacing: .8, fontWeight: FontWeight.w700)),
      const SizedBox(height: 7), Text(body, style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.7)),
    ])),
  ]));

}

class _Brand extends StatelessWidget {
  const _Brand();
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 29, height: 29, decoration: BoxDecoration(border: Border.all(color: AppColors.cyan), borderRadius: BorderRadius.circular(7)),
      child: const Icon(Icons.shield_outlined, color: AppColors.cyan, size: 16)),
    const SizedBox(width: 10), const Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('SANCTUM', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 2.2)),
      Text('S M A R T   B A G   S E C U R I T Y', style: TextStyle(fontFamily: 'monospace', fontSize: 6, color: AppColors.muted, letterSpacing: .15)),
    ]),
  ]);
}

class _TinyFact extends StatelessWidget {
  const _TinyFact({required this.value, required this.label});
  final String value, label;
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Text(value, style: const TextStyle(color: AppColors.cyan, fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: .7)),
    const SizedBox(width: 7), Text(label, style: const TextStyle(color: AppColors.muted, fontFamily: 'monospace', fontSize: 8, letterSpacing: .5)),
  ]);
}

class _MicroLabel extends StatelessWidget {
  const _MicroLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontFamily: 'monospace', fontSize: 8, letterSpacing: 1, color: AppColors.muted, fontWeight: FontWeight.w600));
}

Widget _systemDiagram() => LayoutBuilder(builder: (context, constraints) {
  final compact = constraints.maxWidth < 360;
  return Row(children: [
    if (!compact)
      const Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.work_outline, color: AppColors.cyan, size: 38),
        SizedBox(height: 8), _MicroLabel('YOUR BAG'),
      ])),
    if (!compact) const Icon(Icons.sync_alt, color: AppColors.muted, size: 20),
    Expanded(flex: 2, child: Container(
      margin: EdgeInsets.symmetric(horizontal: compact ? 4 : 12),
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12, vertical: 8),
      decoration: BoxDecoration(color: AppColors.panel, borderRadius: BorderRadius.circular(7), border: Border.all(color: AppColors.border)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('ARDUINO UNO', style: TextStyle(color: AppColors.cyan, fontFamily: 'monospace', fontSize: 9, letterSpacing: .8, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Wrap(spacing: 4, runSpacing: 4, children: [
          _diagramTag('ACCESS'), _diagramTag('WATER'), _diagramTag('TIME'), _diagramTag('OLED'),
        ]),
      ]))),
    const Icon(Icons.bluetooth, color: AppColors.cyan, size: 18),
    const SizedBox(width: 6), const Icon(Icons.phone_iphone, color: AppColors.muted, size: 22),
  ]);
});

Widget _diagramTag(String label) => Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4)),
  child: Text(label, style: const TextStyle(color: AppColors.muted, fontFamily: 'monospace', fontSize: 6, letterSpacing: .3)));
