import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color darkBlue = Color(0xFF0F2F64);
  static const Color backgroundColor = Color(0xFFF4F7FC);
  static const Color textColor = Color(0xFF172B4D);
  static const Color secondaryText = Color(0xFF718096);

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature functionality will be added later.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: primaryBlue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MediRide',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                          ),
                        ),
                        Text(
                          'ADMINISTRATION PORTAL',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w600,
                            color: secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Logout',
                    onPressed: _logout,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: darkBlue,
                      fixedSize: const Size(46, 46),
                    ),
                    icon: const Icon(Icons.logout_rounded),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Welcome banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(23),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F2F64), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(23),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ADMIN DASHBOARD',
                      style: TextStyle(
                        color: Color(0xFFBFDBFE),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Welcome, Admin!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Manage your ambulance service from one place.',
                      style: TextStyle(
                        color: Color(0xFFE0EAFF),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 18),
                    Row(
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          color: Color(0xFFBFDBFE),
                          size: 17,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Administrator access',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Statistics heading
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'A quick overview of your platform.',
                style: TextStyle(fontSize: 13, color: secondaryText),
              ),

              const SizedBox(height: 18),

              // Statistics grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth >= 500 ? 4 : 2;

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 13,
                    childAspectRatio: crossAxisCount == 4 ? 0.88 : 1.12,
                    children: const [
                      _StatCard(
                        title: 'Patients',
                        value: '120',
                        icon: Icons.people_alt_rounded,
                        iconColor: Color(0xFF2563EB),
                        iconBackground: Color(0xFFEBF2FF),
                      ),
                      _StatCard(
                        title: 'Drivers',
                        value: '25',
                        icon: Icons.badge_rounded,
                        iconColor: Color(0xFF7C3AED),
                        iconBackground: Color(0xFFF2EAFF),
                      ),
                      _StatCard(
                        title: 'Ambulances',
                        value: '18',
                        icon: Icons.local_shipping_rounded,
                        iconColor: Color(0xFF0891B2),
                        iconBackground: Color(0xFFE2F8FC),
                      ),
                      _StatCard(
                        title: 'Bookings',
                        value: '350',
                        icon: Icons.calendar_month_rounded,
                        iconColor: Color(0xFF059669),
                        iconBackground: Color(0xFFE2F8EC),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              // Management section
              const Text(
                'Management',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Manage your users and ambulance operations.',
                style: TextStyle(fontSize: 13, color: secondaryText),
              ),

              const SizedBox(height: 17),

              _ManagementTile(
                icon: Icons.people_alt_rounded,
                title: 'Manage Users',
                subtitle: 'View and manage patient accounts',
                onTap: () => _showComingSoon(context, 'User management'),
              ),
              const SizedBox(height: 12),

              _ManagementTile(
                icon: Icons.badge_rounded,
                title: 'Manage Drivers',
                subtitle: 'Review and manage driver accounts',
                onTap: () => _showComingSoon(context, 'Driver management'),
              ),
              const SizedBox(height: 12),

              _ManagementTile(
                icon: Icons.local_shipping_rounded,
                title: 'Manage Ambulances',
                subtitle: 'Manage vehicles and availability',
                onTap: () => _showComingSoon(context, 'Ambulance management'),
              ),
              const SizedBox(height: 12),

              _ManagementTile(
                icon: Icons.receipt_long_rounded,
                title: 'View Bookings',
                subtitle: 'Monitor bookings and trip status',
                onTap: () => _showComingSoon(context, 'Booking management'),
              ),

              const SizedBox(height: 25),

              // Logout button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFDC2626),
                    side: const BorderSide(color: Color(0xFFFECACA)),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  'MediRide • Admin Portal',
                  style: TextStyle(
                    color: Colors.blueGrey.shade400,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Statistics card
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFE8EDF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F2F64).withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: iconColor, size: 23),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF718096),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Management menu item
class _ManagementTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ManagementTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: const Color(0xFFE8EDF5)),
          ),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF2FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xFF2563EB), size: 25),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172B4D),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF718096),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
