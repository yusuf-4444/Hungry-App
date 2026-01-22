import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    print('👤 ProfileView - initState');
    _checkGuestMode();

    final profileCubit = context.read<ProfileCubit>();
    final currentState = profileCubit.state;

    if (currentState is profile_state.Success) {
      print('✅ Found cached profile data');
      _updateProfileData(currentState.data);
    }
  }

  Future<void> _checkGuestMode() async {
    final guest = await PrefHelper.isGuest();
    if (mounted) {
      setState(() {
        isGuestMode = guest;
      });
      print('🎭 Guest Mode: $isGuestMode');
    }
  }

  void _updateProfileData(ProfileModel data) {
    print('📝 Updating Profile Data in UI');
    print('   ├─ Name: ${data.data.name}');
    print('   ├─ Email: ${data.data.email}');
    print('   └─ Image: ${data.data.image ?? "No Image"}');

    if (mounted) {
      setState(() {
        profileModel = data;
        _name.text = data.data.name;
        _email.text = data.data.email;
        _address.text = data.data.address ?? "";
        _visa.text = data.data.visa ?? "";
        _selectedImageUrl = data.data.image;
        _selectedImageFile = null;
      });
    }
  }

  Future<void> uploadImage() async {
    print('📸 Upload Image Tapped');
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      print('✅ Image Selected: ${image.path}');
      setState(() {
        _selectedImageFile = File(image.path);
        _selectedImageUrl = null;
      });
    } else {
      print('❌ No Image Selected');
    }
  }

  Future<void> _updateProfile() async {
    print('💾 Update Profile Tapped');

    if (_name.text.isEmpty || _email.text.isEmpty) {
      print('⚠️ Validation Failed: Name or Email is empty');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar("Please fill name and email", Colors.red));
      return;
    }

    setState(() {
      isUpdating = true;
    });

    try {
      print('🔄 Calling updateProfile API...');
      await context.read<UpdateProfileCubit>().updateProfile(
        name: _name.text,
        email: _email.text,
        delivaryAddress: _address.text,
        visa: _visa.text,
        image: _selectedImageFile,
      );
    } catch (e) {
      print('❌ Update Profile Exception: $e');
      if (mounted) {
        setState(() {
          isUpdating = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    print('🚪 Logout Tapped');
    setState(() {
      isLoggingOut = true;
    });

    try {
      if (isGuestMode) {
        print('🎭 Logging out Guest Mode');
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
        print('👤 Logging out Authenticated User');
        await context.read<LogoutCubit>().logout();
      }
    } catch (e) {
      print('❌ Logout Exception: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar("Logout Failed: ${e.toString()}", Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoggingOut = false;
        });
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
    print('🏗️ ProfileView - Building - Guest: $isGuestMode');

    if (isGuestMode) {
      return _buildGuestView();
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, profile_state.ProfileState>(
          listener: (context, state) {
            print(
              '👂 ProfileView - ProfileCubit Listener - State: ${state.runtimeType}',
            );
            if (state is profile_state.Success) {
              _updateProfileData(state.data);
            }
          },
        ),
        BlocListener<UpdateProfileCubit, UpdateProfileState>(
          listener: (context, state) {
            print(
              '👂 ProfileView - UpdateProfileCubit Listener - State: ${state.runtimeType}',
            );
            if (state is Success) {
              print('✅ Profile Updated Successfully');
              context.read<ProfileCubit>().refreshProfile();
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar("Updated Successfully", Colors.white),
              );
            } else if (state is Failure) {
              print('❌ Profile Update Failed: ${state.error}');
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar("Update Failed: ${state.error}", Colors.red),
              );
            }
            if (mounted) {
              setState(() {
                isUpdating = false;
              });
            }
          },
        ),
        BlocListener<LogoutCubit, dynamic>(
          listener: (context, state) {
            print(
              '👂 ProfileView - LogoutCubit Listener - State: ${state.runtimeType}',
            );
            if (state is Success) {
              print('✅ Logout Successful');
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
              print('❌ Logout Failed: ${state.error}');
              if (mounted) {
                setState(() {
                  isLoggingOut = false;
                });
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
          print('🏗️ ProfileView - BlocBuilder - State: ${state.runtimeType}');
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outline, size: 80, color: Colors.white),
            const Gap(20),
            const CustomText(
              text: "Guest Mode",
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            const Gap(10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: CustomText(
                text: "Please login to view and edit your profile",
                color: Colors.white,
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(30),
            CustomMainButton(
              text: "Go to Login",
              fontSize: 16,
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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.white),
              const Gap(20),
              const CustomText(
                text: "Error Loading Profile",
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CustomText(
                  text: error,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(30),
              ElevatedButton(
                onPressed: () => context.read<ProfileCubit>().refreshProfile(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryColor,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text("Retry", style: TextStyle(fontSize: 16)),
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
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
          ],
          backgroundColor: AppColors.primaryColor,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      const Gap(10),
                      _buildAvatar(),
                      const Gap(10),
                      CustomMainButton(
                        onPressed: uploadImage,
                        text:
                            _selectedImageFile == null &&
                                (_selectedImageUrl == null ||
                                    _selectedImageUrl!.isEmpty)
                            ? "Upload Image"
                            : "Change Image",
                        fontSize: 12,
                        width: 200,
                      ),
                      const Gap(10),
                      CustomTextFormField(controller: _name, labelText: 'Name'),
                      const Gap(20),
                      CustomTextFormField(
                        controller: _email,
                        labelText: 'Email',
                      ),
                      const Gap(20),
                      CustomTextFormField(
                        controller: _address,
                        labelText: 'Delivery Address',
                      ),
                      const Gap(20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(),
                      ),
                      const Gap(20),
                      CustomTextFormField(
                        textInputType: TextInputType.number,
                        controller: _visa,
                        labelText: _visa.text.isEmpty
                            ? "Add Visa"
                            : 'Edit Visa',
                      ),
                      const Gap(20),
                      if (_visa.text.isNotEmpty) _buildVisaCard(),
                      const Gap(80),
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
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          border: Border.all(width: 3, color: Colors.white),
          shape: BoxShape.circle,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(60),
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
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      tileColor: Colors.white,
      leading: Image.asset("assets/profileIcons/image 13.png"),
      horizontalTitleGap: 30,
      title: const CustomText(
        text: "Debit card",
        color: Colors.black,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
      subtitle: CustomText(
        text: _formatVisaNumber(_visa.text),
        color: Colors.black,
      ),
      trailing: const CustomText(text: "Default", color: Colors.black),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
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
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    CustomText(
                      text: isUpdating ? "Updating..." : "Edit Profile",
                      color: Colors.white,
                    ),
                    const Gap(10),
                    const Icon(Icons.edit, color: Colors.white),
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
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    CustomText(
                      text: isLoggingOut ? "Logging out..." : "Logout",
                      color: Colors.black,
                    ),
                    const Gap(10),
                    const Icon(Icons.logout, color: Colors.black),
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
    print('🗑️ ProfileView - dispose');
    _name.dispose();
    _email.dispose();
    _address.dispose();
    _visa.dispose();
    super.dispose();
  }
}
