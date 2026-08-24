import 'package:flutter/material.dart';

/// Temporary route target — replaced by the full portfolio experience
/// in the public-site phase.
class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Portfolio — coming next phase')),
    );
  }
}
