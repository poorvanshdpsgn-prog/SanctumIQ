import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SitePageHeader extends StatelessWidget {
  const SitePageHeader({super.key, required this.currentPage});

  final String currentPage;

  void _goHome(BuildContext context) =>
      Navigator.of(context).popUntil((route) => route.isFirst);

  void _open(BuildContext context, String route) {
    if (currentPage == route.substring(1)) return;
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, size) {
        final compact = size.maxWidth < 680;
        return Container(
          height: 76,
          padding: EdgeInsets.symmetric(horizontal: compact ? 22 : 56),
          decoration: const BoxDecoration(
            color: Color(0xee07100f),
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(children: [
            InkWell(
              onTap: () => _goHome(context),
              borderRadius: BorderRadius.circular(5),
              child: const _PageBrand(),
            ),
            const Spacer(),
            if (compact) ...[
              IconButton(
                tooltip: 'Home',
                onPressed: () => _goHome(context),
                icon: const Icon(Icons.home_outlined, color: AppColors.muted),
              ),
              IconButton(
                tooltip: 'Team',
                onPressed: () => _open(context, '/team'),
                icon: Icon(Icons.groups_outlined,
                    color: currentPage == 'team' ? AppColors.cyan : AppColors.muted),
              ),
              IconButton(
                tooltip: 'Hardware health',
                onPressed: () => _open(context, '/diagnostics'),
                icon: Icon(Icons.monitor_heart_outlined,
                    color: currentPage == 'diagnostics' ? AppColors.cyan : AppColors.muted),
              ),
              IconButton(
                tooltip: 'Contact',
                onPressed: () => _open(context, '/contact'),
                icon: Icon(Icons.mail_outline,
                    color: currentPage == 'contact' ? AppColors.cyan : AppColors.muted),
              ),
            ] else ...[
              _navLink(context, 'HOME', 'home', _goHome),
              _navLink(context, 'TEAM', 'team', (_) => _open(context, '/team')),
              _navLink(context, 'HARDWARE HEALTH', 'diagnostics', (_) => _open(context, '/diagnostics')),
              _navLink(context, 'CONTACT', 'contact', (_) => _open(context, '/contact')),
            ],
          ]),
        );
      });

  Widget _navLink(BuildContext context, String label, String page,
          void Function(BuildContext) onTap) =>
      TextButton(
        onPressed: () => onTap(context),
        child: Text(label,
            style: TextStyle(
              color: currentPage == page ? AppColors.cyan : AppColors.muted,
              fontSize: 10,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            )),
      );
}

class _PageBrand extends StatelessWidget {
  const _PageBrand();

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 29,
          height: 29,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cyan),
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Icon(Icons.shield_outlined, color: AppColors.cyan, size: 16),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('SANCTUM', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 2.2)),
            Text('S M A R T   B A G   S E C U R I T Y', style: TextStyle(fontFamily: 'monospace', fontSize: 6, color: AppColors.muted, letterSpacing: .15)),
          ],
        ),
      ]);
}
