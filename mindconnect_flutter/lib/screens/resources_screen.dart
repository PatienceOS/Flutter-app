import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// TODO: replace the placeholder phone numbers with REAL local contacts
/// (your campus counseling service and a national helpline for your country).
const _links = <(String, String, String)>[
  ('Campus Counseling', '123-456-7890 (replace me)', 'tel:1234567890'),
  ('National Helpline', 'Add your country’s helpline here', ''),
  ('WHO Adolescent Mental Health', 'WHO Fact Sheet',
      'https://www.who.int/news-room/fact-sheets/detail/adolescent-mental-health'),
  ('Mental Health Foundation', 'Get Help',
      'https://www.mentalhealth.org.uk/explore-mental-health/get-help'),
];

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  Future<void> _open(String url) async {
    if (url.isEmpty) return;
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('🔗 Resource Directory', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('If you or someone you know needs help, reach out to these resources. '
            'Support is available and you are not alone.'),
        const SizedBox(height: 8),
        for (final (title, subtitle, url) in _links)
          Card(
            child: ListTile(
              title: Text(title),
              subtitle: Text(subtitle),
              trailing: url.isEmpty ? null : Icon(url.startsWith('tel:') ? Icons.phone : Icons.open_in_new),
              onTap: () => _open(url),
            ),
          ),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('How to Seek Help', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('• Talk to someone you trust'),
              Text('• Contact a professional or helpline'),
              Text('• Know that you are not alone—support is available'),
            ]),
          ),
        ),
      ],
    );
  }
}
