import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: ConstantStrings.contactSupport,
        leftButton: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCenteredContactBox(
              icon: Icons.email_outlined,
              text: "Avinoncia@gmail.com",
              onTap: () => _launchEmail(context),
            ),
            const SizedBox(height: 16),
            _buildCenteredContactBox(
              icon: Icons.local_phone_outlined,
              text: "+91-834 569 9234",
              onTap: () => _launchPhone(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenteredContactBox({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF3F3D56)),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF3F3D56),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'Avinoncia@gmail.com',
      query: Uri.encodeFull('subject=Support Request'),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      _showErrorSnack(context, "Unable to open email app.");
    }
  }


  void _launchPhone(BuildContext context) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+918345699234');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      _showErrorSnack(context, "Unable to open phone app.");
    }
  }

  void _showErrorSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
