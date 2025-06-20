import 'package:avionics_internal/Constants/ApiClass/ApiErrorModel.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Constants/constantImages.dart';
import '../../../bloc/Profile/Avtar/avtar_cubit.dart';
import '../../../bloc/Profile/Avtar/avtar_state.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';

class AvtarScreen extends StatefulWidget {
  final bool isComeFromSignupScreen;
  final String userEmail;

  const AvtarScreen({
    Key? key,
    required this.isComeFromSignupScreen,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AvtarScreenState();
}

class _AvtarScreenState extends State<AvtarScreen> {
  final List<String> titles = ['Student', 'Professional', 'Enthusiast', 'ATCO'];
  final List<String> userTypes = [
    'student',
    'professional',
    'enthusiast',
    'atco',
  ];

  final List<String> icons = [
    AssetsPath.avtarThird, // student
    AssetsPath.avtarFirst, // professional
    AssetsPath.avtarFouth, // enthusiast
    AssetsPath.avtarSecond, // atco
  ];

  @override
  void initState() {
    super.initState();
    context.read<AvtarCubit>().loadAvatarFromPrefs(
      widget.isComeFromSignupScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: ConstantStrings.avtarTitle,
        leftButton: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocConsumer<AvtarCubit, AvtarState>(
        listener: (context, state) {
          if (state.status == CommonApiStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Failed to select avatar'),
              ),
            );
          } else if (state.status == CommonApiStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Avatar updated successfully')),
            );
          }
        },
        builder: (context, state) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            itemCount: titles.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 0.1, color: Colors.grey, thickness: 0.1),
            itemBuilder: (context, index) {
              final userType = userTypes[index];
              final isSelected = state.selectedUserType == userType;

              return GestureDetector(
                onTap: () {
                  context.read<AvtarCubit>().selectAvatar(
                    userType,
                    widget.isComeFromSignupScreen,
                    widget.userEmail,
                    context,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  child: Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            CommonUi.setSvgImage(icons[index])!,
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              titles[index],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              size: 20,
                              color: Colors.blue,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
