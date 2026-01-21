import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileCubit>().getProfile(forceRefresh: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final username = _getUsername(state);
        final imageUrl = _getImageUrl(state);
        final isLoading = state is Loading;

        return Skeletonizer(
          enabled: isLoading,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(username),
              const Spacer(),
              _buildAvatar(imageUrl, isLoading),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection(String username) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          "assets/logo/Hungry_.svg",
          color: AppColors.primaryColor,
          height: 35.h, // استخدم .h من ScreenUtil
        ),
        Gap(5.h), // استخدم .h من ScreenUtil
        Skeleton.leaf(
          // أضف Skeleton للنص
          child: CustomText(
            text: "Hello, $username",
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String? imageUrl, bool isLoading) {
    return CircleAvatar(
      radius: 25.r,
      backgroundColor: AppColors.primaryColor,
      child: _buildAvatarContent(imageUrl, isLoading),
    );
  }

  Widget _buildAvatarContent(String? imageUrl, bool isLoading) {
    if (isLoading) {
      return SizedBox(
        width: 20.w,
        height: 20.h,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: 50.w,
          height: 50.h,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const CircularProgressIndicator.adaptive(),
          errorWidget: (context, url, error) => _buildDefaultIcon(),
        ),
      );
    }

    return _buildDefaultIcon();
  }

  Widget _buildDefaultIcon() {
    return Icon(
      CupertinoIcons.person,
      color: Colors.white,
      size: 24.sp, // استخدم .sp من ScreenUtil
    );
  }

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
