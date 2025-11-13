import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import '../../../bloc/Profile/ContactSupport/contactsupport_cubit.dart';
import '../../../bloc/Profile/ContactSupport/contactsupport_state.dart';
import '../../../bloc/Profile/ManageAccount/manageAcc_repository.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool _loadingUser = true;

  late final ContactSupportCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ContactSupportCubit();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    try {
      final user = await ManageAccountRepository().getUserDetail();
      if (user.email.isNotEmpty) {
        emailController.text = user.email;
        _cubit.updateEmail(user.email);
      }
    } catch (_) {
    } finally {
      setState(() {
        _loadingUser = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    messageController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width > 1500
        ? 1500
        : MediaQuery.of(context).size.width;
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Contact Support",
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _loadingUser
              ? const Center(child: CircularProgressIndicator())
              : Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: BlocListener<ContactSupportCubit, ContactSupportState>(
                listenWhen: (previous, current) =>
                current.submissionSuccess && !previous.submissionSuccess,
                listener: (context, state) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Your message has been sent successfully."),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: BlocBuilder<ContactSupportCubit, ContactSupportState>(
                  builder: (context, state) {
                    final cubit = _cubit;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 30,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Enter your email",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3F3D56),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  hintText: "Enter your email address",
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) => cubit.updateEmail(value.trim()),
                              ),
                            ),
                            if (state.email.isNotEmpty && !cubit.isValidEmail(state.email)) ...[
                              const SizedBox(height: 6),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Please enter a valid email address",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            const Text(
                              "Enter description",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3F3D56),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                                controller: messageController,
                                maxLines: 10,
                                decoration: const InputDecoration(
                                  hintText: "Enter your message or details...",
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) => cubit.updateMessage(value.trim()),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: CustomBottomButton(
                                title: state.isSubmitting ? "" : "Submit",
                                backgroundColor: const Color.fromRGBO(63, 61, 81, 1.0),
                                textColor: Colors.white,
                                icon: state.isSubmitting
                                    ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 2,
                                  ),
                                )
                                    : const SizedBox(width: 0),
                                isEnabled: !state.isSubmitting &&
                                    state.email.isNotEmpty &&
                                    cubit.isValidEmail(state.email) &&
                                    state.message.isNotEmpty,
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  if (state.email.isNotEmpty &&
                                      cubit.isValidEmail(state.email) &&
                                      state.message.isNotEmpty) {
                                    cubit.submitSupport(context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
