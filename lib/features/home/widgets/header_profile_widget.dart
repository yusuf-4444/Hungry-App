import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_cubit.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_state.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HeaderProfile extends StatefulWidget {
  const HeaderProfile({super.key});

  @override
  State<HeaderProfile> createState() => _HeaderProfileState();
}

class _HeaderProfileState extends State<HeaderProfile> {
  String username = "Guest";
  String? image;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().getProfile(forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is Success) {
          setState(() {
            username = state.data.data.name;
            image = state.data.data.image;
          });
        }
      },
      builder: (context, state) {
        return Skeletonizer(
          enabled: state is Loading,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    "assets/logo/Hungry_.svg",
                    color: AppColors.primaryColor,
                    height: 35,
                  ),
                  const Gap(5),
                  CustomText(
                    text: "Hello, $username",
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
              const Spacer(),
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.primaryColor,
                child: image != null && image!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          image!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              CupertinoIcons.person,
                              color: Colors.white,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            );
                          },
                        ),
                      )
                    : const Icon(CupertinoIcons.person, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
