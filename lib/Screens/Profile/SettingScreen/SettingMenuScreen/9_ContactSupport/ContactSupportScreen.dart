import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../../../Constants/constantImages.dart';
import '../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../CustomFiles/CustomBottomButton.dart';
import '../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../../bloc/Profile/ContactSupport/contactsupport_cubit.dart';
import '../../../../../bloc/Profile/ContactSupport/contactsupport_state.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  late final ContactSupportCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ContactSupportCubit();
    _loadUserEmail();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.contactSupportScreen,
    );
  }

  Future<void> _loadUserEmail() async {
    var userEmail = await SharedPrefsHelper.getEmail();
    if (userEmail != "" && userEmail != null) {
      emailController.text = userEmail;
      _cubit.updateEmail(userEmail);
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
          centerTitle: false,
          title: "Contact Support",
          leftButton: IconButton(
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.backArrowButton),
              fit: BoxFit.cover,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Align(
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
                        horizontal: 14,
                        vertical: 18,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            /// TOP IMAGE
                            Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                constraints: const BoxConstraints(
                                  maxWidth: 220,
                                ),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: SvgPicture.asset(
                                    CommonUi.setSvgImage(
                                      AssetsPath.contactSupport,
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // TITLE
                            const Text(
                              "Contact Support",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(height: 22),

                            Container(
                              height: 58,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.extraLightGrey,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.5),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    CommonUi.setSvgImage(AssetsPath.emailIcon),
                                  ),

                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        hintText: "Enter your email",

                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF8A8A8A),
                                        ),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: (value) =>
                                          cubit.updateEmail(value.trim()),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (state.email.isNotEmpty &&
                                !cubit.isValidEmail(state.email)) ...[
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

                            const SizedBox(height: 14),

                            /// DESCRIPTION BOX
                            Container(
                              height: MediaQuery.of(context).size.height * 0.28,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.extraLightGrey,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.5),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),

                              child: TextField(
                                controller: messageController,
                                maxLines: 10,
                                minLines: 8,
                                textAlignVertical: TextAlignVertical.top,

                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),

                                decoration: const InputDecoration(
                                  hintText: "Description",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),

                                onChanged: (value) =>
                                    cubit.updateMessage(value.trim()),
                              ),
                            ),

                            const SizedBox(height: 28),

                            /// SUBMIT BUTTON
                            SizedBox(
                              width: double.infinity,
                              height: 56,

                              child: CustomBottomButton(
                                fontStyle: AppTextStyles.regular(
                                  18,
                                ).copyWith(color: Colors.white, height: 1),

                                title: state.isSubmitting ? "" : "Submit",

                                backgroundColor: const Color(0xFF1B1453),

                                textColor: Colors.white,

                                icon: state.isSubmitting
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const SizedBox.shrink(),

                                isEnabled:
                                    !state.isSubmitting &&
                                    state.email.isNotEmpty &&
                                    cubit.isValidEmail(state.email) &&
                                    state.message.isNotEmpty,

                                onPressed: () {
                                  FocusScope.of(context).unfocus();

                                  if (state.email.isNotEmpty &&
                                      cubit.isValidEmail(state.email) &&
                                      state.message.isNotEmpty) {
                                    cubit.submitSupport(context);

                                    AnalyticsService.instance.buttonPressed(
                                      FirebaseEvents.contactSupportButton,
                                      FirebaseEvents.contactSupportScreen,
                                    );
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