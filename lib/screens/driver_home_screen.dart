import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  // MediRide theme colors
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color darkBlue = Color(0xFF0F2F64);
  static const Color backgroundColor = Color(0xFFF4F7FC);
  static const Color textColor = Color(0xFF172B4D);
  static const Color secondaryText = Color(0xFF718096);

  bool isAvailable = true;
  bool requestAccepted = false;

  Future<void> _logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  void _acceptRequest() {
    setState(() {
      requestAccepted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo: Request accepted locally.'),
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
                      Icons.local_hospital_rounded,
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
                          'DRIVER PORTAL',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.5,
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

              // Welcome section
              const Text(
                'Welcome back, Driver!',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Your dashboard is ready. Stay safe on every trip.',
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryText,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // Driver status card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1746A2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.18),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Ambulance Status',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isAvailable
                                      ? const Color(0xFF86EFAC)
                                      : Colors.orangeAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Text(
                                isAvailable ? 'Available' : 'Unavailable',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Row(
                      children: [
                        Icon(
                          Icons.local_shipping_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Emergency Response',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Be ready to help patients',
                                style: TextStyle(
                                  color: Color(0xFFDCE8FF),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isAvailable = !isAvailable;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.6),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isAvailable ? 'Go Unavailable' : 'Go Available',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // Location card
              const Row(
                children: [
                  Icon(Icons.location_on_rounded, color: primaryBlue, size: 23),
                  SizedBox(width: 8),
                  Text(
                    'Current Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE8EDF5)),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 23,
                      backgroundColor: Color(0xFFEBF2FF),
                      child: Icon(
                        Icons.my_location_rounded,
                        color: primaryBlue,
                        size: 23,
                      ),
                    ),
                    SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location not connected',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'GPS tracking will be added later.',
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: secondaryText),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Requests heading
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Booking Requests',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0E6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'DEMO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC45A12),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),

              // Emergency request card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8EDF5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE9E9),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(
                            Icons.emergency_rounded,
                            color: Color(0xFFDC2626),
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Emergency Request',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'New booking request',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.notifications_active_outlined,
                          color: primaryBlue,
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),
                    const Divider(color: Color(0xFFEDF0F5)),
                    const SizedBox(height: 12),

                    const _RequestDetail(
                      icon: Icons.person_outline_rounded,
                      title: 'Patient',
                      value: 'Sample Patient',
                    ),
                    const SizedBox(height: 16),
                    const _RequestDetail(
                      icon: Icons.location_on_outlined,
                      title: 'Pickup Location',
                      value: 'Sylhet, Bangladesh',
                    ),
                    const SizedBox(height: 16),
                    const _RequestDetail(
                      icon: Icons.local_hospital_outlined,
                      title: 'Ambulance Type',
                      value: 'Normal Ambulance',
                    ),

                    const SizedBox(height: 22),

                    if (requestAccepted)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFF15803D),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Accepted (Demo Only)',
                              style: TextStyle(
                                color: Color(0xFF15803D),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: isAvailable ? _acceptRequest : null,
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Accept Request'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFFCBD5E1),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: Text(
                  'MediRide • Driver Portal',
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

class _RequestDetail extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _RequestDetail({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF64748B)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF172B4D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
