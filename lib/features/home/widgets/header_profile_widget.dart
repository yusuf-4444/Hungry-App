import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_cubit.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_state.dart';
import 'package:hungry_app/shared/custom_text.dart';

class HeaderProfile extends StatefulWidget {
  const HeaderProfile({super.key});

  @override
  State<HeaderProfile> createState() => _HeaderProfileState();
}

class _HeaderProfileState extends State<HeaderProfile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().getProfile(forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return _buildHeader(state);
      },
    );
  }

  Widget _buildHeader(ProfileState state) {
    final username = _getUsername(state);
    final imageUrl = _getImageUrl(state);
    final isLoading = state is Loading;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWelcomeSection(username),
        const Spacer(),
        _buildAvatar(imageUrl, isLoading),
      ],
    );
  }

  Widget _buildWelcomeSection(String username) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          "assets/logo/Hungry_.svg",
          color: AppColors.primaryColor,
          height: 35,
        ),
        const Gap(5),
        CustomText(text: "Hello, $username", color: Colors.grey.shade600),
      ],
    );
  }

  Widget _buildAvatar(String? imageUrl, bool isLoading) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: AppColors.primaryColor,
      child: _buildAvatarContent(imageUrl, isLoading),
    );
  }

  Widget _buildAvatarContent(String? imageUrl, bool isLoading) {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildDefaultIcon(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            );
          },
        ),
      );
    }

    return _buildDefaultIcon();
  }

  Widget _buildDefaultIcon() {
    return const Icon(CupertinoIcons.person, color: Colors.white);
  }

  // Data Extractors
  String _getUsername(ProfileState state) {
    if (state is Success) {
      return state.data.data.name;
    }
    return "Guest";
  }

  String? _getImageUrl(ProfileState state) {
    if (state is Success) {
      return state.data.data.image;
    }
    return null;
  }
}
