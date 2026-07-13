import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/widgets/bio_scaffold.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/summit_data.dart';
import '../../services/auth_service.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser;
    final name = user?.displayName ?? 'Young Researcher';
    return BioScaffold(
      gradient: const [BioColors.sun, BioColors.deepSky],
      scrimOpacity: 0.15,
      onBack: () => context.go('/summit'),
      body: Center(
        child: Container(
          width: 920,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: BioColors.parchment,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BioColors.sun, width: 8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.workspace_premium,
                  color: BioColors.sun, size: 56),
              const SizedBox(height: 6),
              const Text(
                'CERTIFICATE OF ACHIEVEMENT',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: BioColors.forest,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              const Text('This certifies that',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 6),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: BioColors.bark,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'has successfully completed BioQuest: A Journey Toward Research '
                'Discovery and is hereby recognized as an',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                decoration: BoxDecoration(
                  color: BioColors.forest,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'CONGRATULATIONS, $kSummitCitation!',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                label: 'Back to Expedition Map',
                icon: Icons.map,
                onTap: () => context.go('/map'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
