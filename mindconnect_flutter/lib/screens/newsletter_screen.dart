import 'package:flutter/material.dart';

class NewsletterScreen extends StatefulWidget {
  const NewsletterScreen({super.key});
  @override
  State<NewsletterScreen> createState() => _NewsletterScreenState();
}

class _NewsletterScreenState extends State<NewsletterScreen> {
  final ctrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String msg = '';

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!formKey.currentState!.validate()) return;
    // TODO: send ctrl.text to a backend / mailing service (Mailchimp, Firebase...).
    setState(() => msg = 'Thank you for signing up! You will receive updates soon.');
    ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('📧 Newsletter Signup', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Sign up to receive wellness tips, research updates, and news about mental '
            'health events. Your email will never be shared.'),
        const SizedBox(height: 12),
        Form(
          key: formKey,
          child: TextFormField(
            controller: ctrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                labelText: 'Your email', border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
            validator: (v) =>
                (v == null || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim()))
                    ? 'Enter a valid email'
                    : null,
          ),
        ),
        const SizedBox(height: 8),
        Align(alignment: Alignment.centerRight, child: FilledButton(onPressed: _submit, child: const Text('Sign Up'))),
        const SizedBox(height: 8),
        Text(msg),
      ],
    );
  }
}
