import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/network/pref_helper.dart';
import 'package:hungry_app/core/route/app_routes.dart';
import 'package:hungry_app/features/auth/logout/logic/cubit/logout_cubit.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_cubit.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_state.dart'
    as profile_state;
import 'package:hungry_app/features/auth/profile/logic/cubit/update_profile_cubit.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/update_profile_state.dart';
import 'package:hungry_app/features/auth/profile/models/profile_model.dart';
import 'package:hungry_app/features/auth/widgets/custom_text_form_field.dart';
import 'package:hungry_app/shared/custom_main_button.dart';
import 'package:hungry_app/shared/custom_snack_bar.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _visa = TextEditingController();

  ProfileModel? profileModel;

  String? _selectedImageUrl;
  File? _selectedImageFile;

  bool isUpdating = false;
  bool isLoggingOut = false;
  bool isGuestMode = false;

  @override
  void initState() {
    super.initState();
    _checkGuestMode();

    final profileCubit = context.read<ProfileCubit>();
    final currentState = profileCubit.state;

    if (currentState is profile_state.Success) {
      _updateProfileData(currentState.data);
    }
  }

  Future<void> _checkGuestMode() async {
    final guest = await PrefHelper.isGuest();
    if (mounted) {
      setState(() {
        isGuestMode = guest;
      });
    }
  }

  void _updateProfileData(ProfileModel data) {
    if (!mounted) return;

    setState(() {
      profileModel = data;
      _name.text = data.data.name ?? '';
      _email.text = data.data.email ?? '';
      _address.text = data.data.address ?? '';
      _visa.text = data.data.visa ?? '';
      _selectedImageUrl = data.data.image;
      _selectedImageFile = null;
    });

    // مهم: يساعد في إجبار الـ listeners (مثل الـ TextFormField) على التحديث
  }

  Future<void> uploadImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImageFile = File(image.path);
        _selectedImageUrl = null;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_name.text.trim().isEmpty || _email.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar("Please fill name and email", Colors.red));
      return;
    }

    setState(() => isUpdating = true);

    try {
      await context.read<UpdateProfileCubit>().updateProfile(
        name: _name.text.trim(),
        email: _email.text.trim(),
        delivaryAddress: _address.text.trim(),
        visa: _visa.text.trim(),
        image: _selectedImageFile,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CustomSnackBar("Update error: $e", Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() => isUpdating = false);
      }
    }
  }

  Future<void> _logout() async {
    setState(() => isLoggingOut = true);

    try {
      if (isGuestMode) {
        await PrefHelper.removeToken();
        if (mounted) {
          context.read<ProfileCubit>().clearCache();
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (_) => false,
          );
        }
      } else {
        await context.read<LogoutCubit>().logout();
        await PrefHelper.removeToken();
        if (mounted) {
          context.read<ProfileCubit>().clearCache();
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (_) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(CustomSnackBar("Logout Failed: $e", Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() => isLoggingOut = false);
      }
    }
  }

  String _formatVisaNumber(String visa) {
    try {
      String cleaned = visa.replaceAll(RegExp(r'[^\d]'), '');
      if (cleaned.isEmpty) return "**** **** **** ****";
      if (cleaned.length < 8) {
        return "**** **** **** ${cleaned.padLeft(4, '*')}";
      }
      String firstFour = cleaned.substring(0, 4);
      String lastFour = cleaned.substring(cleaned.length - 4);
      return '$firstFour **** **** $lastFour';
    } catch (e) {
      return "**** **** **** ****";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isGuestMode) {
      return _buildGuestView();
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, profile_state.ProfileState>(
          listener: (context, state) {
            if (state is profile_state.Success) {
              _updateProfileData(state.data);
            }
          },
        ),
        BlocListener<UpdateProfileCubit, UpdateProfileState>(
          listener: (context, state) {
            if (state is Success) {
              context.read<ProfileCubit>().refreshProfile();
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar("Updated Successfully", Colors.white),
              );
            } else if (state is Failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar("Update Failed: ${state.error}", Colors.red),
              );
            }
            if (mounted) {
              setState(() => isUpdating = false);
            }
          },
        ),
        BlocListener<LogoutCubit, dynamic>(
          listener: (context, state) {
            if (state is Success) {
              context.read<ProfileCubit>().clearCache();
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar("LOGGED OUT SUCCESSFULLY", Colors.white),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (_) => false,
              );
            } else if (state is Failure) {
              if (mounted) {
                setState(() => isLoggingOut = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar("Logout Failed: ${state.error}", Colors.red),
                );
              }
            }
          },
        ),
      ],
      child: BlocBuilder<ProfileCubit, profile_state.ProfileState>(
        builder: (context, state) {
          final isLoading = state is profile_state.Loading;

          if (state is profile_state.Failure && !isLoading) {
            return _buildErrorView(state.error);
          }

          return Skeletonizer(
            enabled: isLoading,
            child: _buildProfileContent(),
          );
        },
      ),
    );
  }

  Widget _buildGuestView() {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 80.sp, color: Colors.white),
            Gap(20.h),
            CustomText(
              text: "Guest Mode",
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
            Gap(10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: CustomText(
                text: "Please login to view and edit your profile",
                color: Colors.white,
                textAlign: TextAlign.center,
                fontSize: 14.sp,
              ),
            ),
            Gap(30.h),
            CustomMainButton(
              text: "Go to Login",
              fontSize: 16.sp,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return RefreshIndicator(
      onRefresh: () => context.read<ProfileCubit>().refreshProfile(),
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80.sp, color: Colors.white),
              Gap(20.h),
              CustomText(
                text: "Error Loading Profile",
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              Gap(10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: CustomText(
                  text: error,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                  fontSize: 14.sp,
                ),
              ),
              Gap(30.h),
              ElevatedButton(
                onPressed: () => context.read<ProfileCubit>().refreshProfile(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryColor,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  child: Text("Retry", style: TextStyle(fontSize: 16.sp)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return RefreshIndicator(
      onRefresh: () => context.read<ProfileCubit>().refreshProfile(),
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings, color: Colors.white, size: 24.sp),
            ),
          ],
          backgroundColor: AppColors.primaryColor,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      Gap(10.h),
                      _buildAvatar(),
                      Gap(10.h),
                      CustomMainButton(
                        onPressed: uploadImage,
                        text:
                            _selectedImageFile == null &&
                                (_selectedImageUrl == null ||
                                    _selectedImageUrl!.isEmpty)
                            ? "Upload Image"
                            : "Change Image",
                        fontSize: 12.sp,
                        width: 200.w,
                      ),
                      Gap(10.h),
                      CustomTextFormField(
                        key: ValueKey(
                          "name_${_name.text}",
                        ), // اختياري – يساعد في حالات نادرة
                        controller: _name,
                        labelText: 'Name',
                      ),
                      Gap(20.h),
                      CustomTextFormField(
                        key: ValueKey("email_${_email.text}"),
                        controller: _email,
                        labelText: 'Email',
                      ),
                      Gap(20.h),
                      CustomTextFormField(
                        key: ValueKey("address_${_address.text}"),
                        controller: _address,
                        labelText: 'Delivery Address',
                      ),
                      Gap(20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: const Divider(),
                      ),
                      Gap(20.h),
                      CustomTextFormField(
                        key: ValueKey(
                          "visa_${_visa.text}",
                        ), // ← الحل الأساسي لمشكلة الـ visa
                        textInputType: TextInputType.number,
                        controller: _visa,
                        labelText: _visa.text.isEmpty
                            ? "Add Visa"
                            : 'Edit Visa',
                      ),
                      Gap(20.h),
                      if (_visa.text.trim().isNotEmpty) _buildVisaCard(),
                      Gap(80.h),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: Container(
        height: 120.w,
        width: 120.w,
        decoration: BoxDecoration(
          border: Border.all(width: 3.w, color: Colors.white),
          shape: BoxShape.circle,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(80.r),
          child: _selectedImageFile != null
              ? Image.file(_selectedImageFile!, fit: BoxFit.cover)
              : (_selectedImageUrl != null && _selectedImageUrl!.isNotEmpty)
              ? Image.network(
                  _selectedImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      "https://tse4.mm.bing.net/th/id/OIP.hGSCbXlcOjL_9mmzerqAbQHaHa?pid=Api&P=0&h=220",
                      fit: BoxFit.cover,
                    );
                  },
                )
              : Image.network(
                  "https://tse4.mm.bing.net/th/id/OIP.hGSCbXlcOjL_9mmzerqAbQHaHa?pid=Api&P=0&h=220",
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Widget _buildVisaCard() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      tileColor: Colors.white,
      leading: Image.asset("assets/profileIcons/image 13.png", height: 30.h),
      horizontalTitleGap: 30.w,
      title: CustomText(
        text: "Debit card",
        color: Colors.black,
        fontWeight: FontWeight.w700,
        fontSize: 14.sp,
      ),
      subtitle: CustomText(
        text: _formatVisaNumber(_visa.text),
        color: Colors.black,
        fontSize: 12.sp,
      ),
      trailing: CustomText(
        text: "Default",
        color: Colors.black,
        fontSize: 12.sp,
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: isUpdating ? null : _updateProfile,
            child: Container(
              decoration: BoxDecoration(
                color: isUpdating ? Colors.grey : AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  children: [
                    CustomText(
                      text: isUpdating ? "Updating..." : "Edit Profile",
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                    Gap(10.w),
                    Icon(Icons.edit, color: Colors.white, size: 20.sp),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: isLoggingOut ? null : _logout,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.black),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  children: [
                    CustomText(
                      text: isLoggingOut ? "Logging out..." : "Logout",
                      color: Colors.black,
                      fontSize: 14.sp,
                    ),
                    Gap(10.w),
                    Icon(Icons.logout, color: Colors.black, size: 20.sp),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _address.dispose();
    _visa.dispose();
    super.dispose();
  }
}
