import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/email_launcher_stub.dart'
    if (dart.library.js_interop) '../utils/email_launcher_web.dart';
import '../widgets/cyber_grid.dart';
import '../widgets/glass_panel.dart';
import '../widgets/section_header.dart';
import '../widgets/site_page_header.dart';
import '../widgets/status_indicator.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        const Positioned.fill(child: CyberGrid()),
        CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: SitePageHeader(currentPage: 'contact'),
            ),
            SliverToBoxAdapter(child: _content(context)),
            const SliverToBoxAdapter(child: _PageFooter()),
          ],
        ),
      ],
    ),
  );

  Widget _content(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 76, 24, 84),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StatusIndicator(label: 'CONTACT THE PROJECT TEAM'),
            const SizedBox(height: 24),
            Text(
              'Let’s talk about what matters.',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: MediaQuery.sizeOf(context).width < 600 ? 40 : 60,
                height: 1.08,
                letterSpacing: -2.1,
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700),
              child: const Text(
                'Questions, feedback, or ideas for Sanctum IQ? Send a note to the project team and we’ll be glad to hear from you.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 15,
                  height: 1.8,
                ),
              ),
            ),
            const SizedBox(height: 42),
            LayoutBuilder(
              builder: (context, constraints) {
                final stacked = constraints.maxWidth < 800;
                final form = _ContactFormPreview();
                final details = _ContactDetails(
                  onTeam: () =>
                      Navigator.pushReplacementNamed(context, '/team'),
                );
                if (stacked) {
                  return Column(
                    children: [form, const SizedBox(height: 18), details],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: form),
                    const SizedBox(width: 18),
                    Expanded(flex: 4, child: details),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

class _ContactFormPreview extends StatefulWidget {
  @override
  State<_ContactFormPreview> createState() => _ContactFormPreviewState();
}

class _ContactFormPreviewState extends State<_ContactFormPreview> {
  static const _recipient = 'studiossoutheast@gmail.com';
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  void _composeEmail() {
    if (!_formKey.currentState!.validate()) return;

    final uri = Uri(
      scheme: 'mailto',
      path: _recipient,
      queryParameters: {
        'subject': 'Sanctum IQ website enquiry',
        'body':
            'Name: ${_name.text.trim()}\n'
            'Email: ${_email.text.trim()}\n\n'
            '${_message.text.trim()}',
      },
    );
    openEmailDraft(uri.toString());
  }

  @override
  Widget build(BuildContext context) => GlassPanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          number: '01',
          eyebrow: 'SEND A MESSAGE',
          title: 'Get in touch.',
          subtitle: 'Complete the details below to open a message addressed to the Sanctum IQ team.',
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _formField(label: 'YOUR NAME', hint: 'Name', controller: _name),
              const SizedBox(height: 16),
              _formField(
                label: 'YOUR EMAIL',
                hint: 'name@example.com',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty ||
                      !email.contains('@') ||
                      !email.contains('.')) {
                    return 'Enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _formField(
                label: 'MESSAGE',
                hint: 'How can we help?',
                controller: _message,
                maxLines: 5,
                validator: (value) => (value?.trim().isEmpty ?? true)
                    ? 'Please enter a message.'
                    : null,
              ),
              const SizedBox(height: 22),
              SizedBox(
                height: 44,
                child: FilledButton.icon(
                  onPressed: _composeEmail,
                  icon: const Icon(Icons.outgoing_mail, size: 15),
                  label: const Text(
                    'OPEN EMAIL DRAFT',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9,
                      letterSpacing: .9,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Opens your email app with the message addressed to $_recipient. Nothing is sent or stored by this website.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _formField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: AppColors.muted,
          fontFamily: 'monospace',
          fontSize: 8,
          letterSpacing: 1.1,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        validator:
            validator ??
            (value) => (value?.trim().isEmpty ?? true)
                ? 'This field is required.'
                : null,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.muted),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    ],
  );
}

class _ContactDetails extends StatelessWidget {
  const _ContactDetails({required this.onTeam});
  final VoidCallback onTeam;

  @override
  Widget build(BuildContext context) => GlassPanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StatusIndicator(label: 'PROJECT INFORMATION'),
        const SizedBox(height: 24),
        Text(
          'A student-led prototype.',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        const Text(
          'Sanctum IQ is an Entrepreneurship & Financial Literacy project exploring affordable, plug-and-use security for bags and everyday carry items.',
          style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.8),
        ),
        const SizedBox(height: 22),
        const Divider(height: 1, color: AppColors.border),
        const SizedBox(height: 20),
        const _DetailRow(
          icon: Icons.shield_outlined,
          label: 'PROJECT',
          value: 'Sanctum IQ',
        ),
        const SizedBox(height: 15),
        const _DetailRow(
          icon: Icons.memory,
          label: 'FOCUS',
          value: 'Smart bag security',
        ),
        const SizedBox(height: 15),
        const _DetailRow(
          icon: Icons.mail_outline,
          label: 'EMAIL',
          value: _ContactFormPreviewState._recipient,
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: onTeam,
          icon: const Icon(Icons.groups_outlined, size: 16),
          label: const Text(
            'MEET THE TEAM',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              letterSpacing: .8,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.cyan,
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: AppColors.cyan, size: 16),
      const SizedBox(width: 11),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.muted,
                fontFamily: 'monospace',
                fontSize: 8,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(color: AppColors.text, fontSize: 12),
            ),
          ],
        ),
      ),
    ],
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
        'SANCTUM IQ  /  PROTECTING WHAT MATTERS',
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
