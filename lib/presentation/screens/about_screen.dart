import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1917),
        elevation: 0,
        title: const Text(
          'About CheckIt',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              // Header Section
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1917),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'CheckIt',
                style: TextStyle(
                  color: Color(0xFF1C1917),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Legal Metrology Compliance System',
                style: TextStyle(
                  color: Color(0xFF78716C),
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF059669),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Color(0xFFA8A29E),
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // SIH Information Card
              Container(
                margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Smart India Hackathon 2026',
                      style: TextStyle(
                        color: Color(0xFF1C1917),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFE7E5E4),
                      height: 25,
                      thickness: 1,
                    ),
                    _buildInfoRow('Problem Statement:', 'SIH26034'),
                    const SizedBox(height: 12),
                    _buildInfoRow('Title:', 'Software System to check compliance of Packaged Commodities under Legal Metrology Packaged Commodities Rules, 2011'),
                    const SizedBox(height: 12),
                    _buildInfoRow('Organization:', 'Ministry of Consumer Affairs, Food and Public Distribution'),
                    const SizedBox(height: 12),
                    _buildInfoRow('Theme:', 'Agriculture, FoodTech and Rural Development'),
                    const SizedBox(height: 12),
                    _buildInfoRow('Category:', 'Software'),
                    const SizedBox(height: 16),
                    const Text(
                      'CheckIt empowers Legal Metrology inspectors to scan product labels using on-device OCR, verify compliance against government rules, detect violations in real time, and generate court-ready PDF reports all from a mobile device. Citizens can also use it for consumer awareness.',
                      style: TextStyle(
                        color: Color(0xFF78716C),
                        fontSize: 13,
                        height: 1.6,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),

              // Team Members Section
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.only(top: 24, bottom: 12),
                child: const Text(
                  'Team Members',
                  style: TextStyle(
                    color: Color(0xFF1C1917),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              
              _buildTeamMemberCard('Tippu', const Color(0xFF1C1917)),
              _buildTeamMemberCard('Surendhar', const Color(0xFF059669)),
              _buildTeamMemberCard('Varshini', const Color(0xFFD97706)),
              _buildTeamMemberCard('Sandhiya', const Color(0xFF78716C)),
              _buildTeamMemberCard('Tamizhini', const Color(0xFFDC2626)),
              _buildTeamMemberCard('Shanmugapriya', const Color(0xFF1C1917)),

              const SizedBox(height: 32),
              
              // Footer
              const Text(
                'Built with passion for Smart India Hackathon 2026',
                style: TextStyle(
                  color: Color(0xFFA8A29E),
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Copyright 2026 CheckIt Team. All rights reserved.',
                style: TextStyle(
                  color: Color(0xFFA8A29E),
                  fontSize: 11,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF78716C),
              fontSize: 13,
              fontFamily: 'Inter',
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1C1917),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamMemberCard(String name, Color avatarColor) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF1C1917),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Developer',
                  style: TextStyle(
                    color: Color(0xFF78716C),
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Color(0xFFE7E5E4),
            size: 20,
          ),
        ],
      ),
    );
  }
}
