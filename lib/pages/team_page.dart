import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/cyber_grid.dart';
import '../widgets/glass_panel.dart';
import '../widgets/sci_button.dart';
import '../widgets/section_header.dart';
import '../widgets/site_page_header.dart';
import '../widgets/status_indicator.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(children: [
          const Positioned.fill(child: CyberGrid()),
          CustomScrollView(slivers: [
            const SliverToBoxAdapter(child: SitePageHeader(currentPage: 'team')),
            SliverToBoxAdapter(child: _content(context)),
            const SliverToBoxAdapter(child: _PageFooter()),
          ]),
        ]),
      );

  Widget _content(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 76, 24, 84),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const StatusIndicator(label: 'THE PEOPLE BEHIND SANCTUM IQ'),
              const SizedBox(height: 24),
              Text('A small team. A practical idea.',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: MediaQuery.sizeOf(context).width < 600 ? 42 : 62,
                        height: 1.08,
                        letterSpacing: -2.2,
                      )),
              const SizedBox(height: 18),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 720),
                child: const Text(
                  'Sanctum IQ brings software and hardware work together to make everyday bags more helpful and protective. Each side of the project supports one simple goal: protect what matters.',
                  style: TextStyle(color: AppColors.muted, fontSize: 15, height: 1.8),
                ),
              ),
              const SizedBox(height: 48),
              const SectionHeader(
                number: '01',
                eyebrow: 'PROJECT TEAM',
                title: 'Different skills, one smart companion.',
                subtitle: 'Meet the contributors working on the software experience and the physical prototype.',
              ),
              const SizedBox(height: 28),
              LayoutBuilder(builder: (context, constraints) {
                final stacked = constraints.maxWidth < 760;
                final members = [
                  _TeamCard(
                    number: '01',
                    name: 'Yashvardhan',
                    role: 'SOFTWARE',
                    icon: Icons.code,
                    summary:
                        'Works on the software side of Sanctum IQ: shaping how system status, meeting reminders, and security alerts are presented to the user.',
                    contributions: const [
                      'Software experience and system interaction',
                      'Clear presentation of reminders and alerts',
                      'Connecting the user-facing side of the project',
                    ],
                  ),
                  _TeamCard(
                    number: '02',
                    name: 'Poorvansh',
                    role: 'HARDWARE & DEBUGGING',
                    icon: Icons.memory,
                    summary:
                        'Focuses on the hardware stack and debugging—bringing the Arduino and its sensors, display, and access-control components together as a working prototype.',
                    contributions: const [
                      'Integrating the Arduino Uno with sensors and modules',
                      'Checking wiring and component behavior',
                      'Finding and resolving hardware issues during testing',
                    ],
                  ),
                ];
                if (stacked) {
                  return Column(children: [
                    for (var i = 0; i < members.length; i++) ...[
                      if (i > 0) const SizedBox(height: 16),
                      members[i],
                    ],
                  ]);
                }
                return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: members[0]),
                  const SizedBox(width: 16),
                  Expanded(child: members[1]),
                ]);
              }),
              const SizedBox(height: 42),
              GlassPanel(
                child: LayoutBuilder(builder: (context, constraints) {
                  final stacked = constraints.maxWidth < 680;
                  final copy = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const _MicroLabel('SHARED PURPOSE'),
                    const SizedBox(height: 12),
                    Text('Make useful protection accessible.',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.cyan)),
                    const SizedBox(height: 10),
                    const Text(
                      'Sanctum IQ is an Entrepreneurship & Financial Literacy project focused on an affordable, plug-and-use security companion for bags, suitcases, and kits.',
                      style: TextStyle(color: AppColors.muted, height: 1.8),
                    ),
                  ]);
                  final button = SciButton(
                    label: 'CONTACT THE TEAM',
                    onPressed: () => Navigator.pushNamed(context, '/contact'),
                  );
                  if (stacked) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      copy, const SizedBox(height: 22), button,
                    ]);
                  }
                  return Row(children: [Expanded(child: copy), const SizedBox(width: 28), button]);
                }),
              ),
            ]),
          ),
        ),
      );
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({
    required this.number,
    required this.name,
    required this.role,
    required this.icon,
    required this.summary,
    required this.contributions,
  });

  final String number;
  final String name;
  final String role;
  final IconData icon;
  final String summary;
  final List<String> contributions;

  @override
  Widget build(BuildContext context) => GlassPanel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.cyan, size: 20),
            ),
            const Spacer(),
            Text(number, style: const TextStyle(color: AppColors.cyan, fontFamily: 'monospace', fontSize: 10, letterSpacing: 1.2)),
          ]),
          const SizedBox(height: 24),
          Text(name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(role, style: const TextStyle(color: AppColors.cyan, fontFamily: 'monospace', fontSize: 9, letterSpacing: 1.1, fontWeight: FontWeight.w700)),
          const SizedBox(height: 15),
          Text(summary, style: const TextStyle(color: AppColors.muted, height: 1.75, fontSize: 13)),
          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 17),
          for (final item in contributions)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Padding(padding: EdgeInsets.only(top: 2), child: Icon(Icons.check, color: AppColors.green, size: 14)),
                const SizedBox(width: 10),
                Expanded(child: Text(item, style: const TextStyle(color: AppColors.text, fontSize: 11, height: 1.55))),
              ]),
            ),
        ]),
      );
}

class _MicroLabel extends StatelessWidget {
  const _MicroLabel(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Text(label,
      style: const TextStyle(color: AppColors.muted, fontFamily: 'monospace', fontSize: 8, letterSpacing: 1.2, fontWeight: FontWeight.w600));
}

class _PageFooter extends StatelessWidget {
  const _PageFooter();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
        child: const Center(
          child: Text('SANCTUM IQ  /  PROTECTING WHAT MATTERS',
              style: TextStyle(color: AppColors.muted, fontFamily: 'monospace', fontSize: 9, letterSpacing: .8)),
        ),
      );
}
