import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/network/pref_helper.dart';
import 'package:hungry_app/features/auth/logout/logic/cubit/logout_cubit.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_cubit.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_state.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/update_profile_cubit.dart';
import 'package:hungry_app/features/auth/profile/models/profile_model.dart';
import 'package:hungry_app/features/auth/view/signin_view.dart';
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

  String? image;
  String visa = "";

  String? _selectedImageUrl;
  File? _selectedImageFile;

  Future<void> uploadImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      _selectedImageFile = File(image.path);
      _selectedImageUrl = null;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
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
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is Failure) {
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<ProfileCubit>().getProfile();
            },
            child: Center(
              child: Text("internal Server Error.. please Try again later"),
            ),
          );
        }

        final isLoading = state is Loading;
        return Skeletonizer(
          enabled: isLoading,
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<ProfileCubit>().getProfile();
            },
            child: Scaffold(
              backgroundColor: AppColors.primaryColor,
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.settings, color: Colors.white),
                  ),
                ],
                backgroundColor: AppColors.primaryColor,
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),

              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Gap(10),
                      Center(
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
                                ? Image.file(
                                    _selectedImageFile!,
                                    fit: BoxFit.cover,
                                  )
                                : (_selectedImageUrl != null &&
                                      _selectedImageUrl!.isNotEmpty)
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
                      ),
                      Gap(10),
                      CustomMainButton(
                        onPressed: () {
                          uploadImage();
                        },
                        text:
                            _selectedImageFile == null &&
                                (_selectedImageUrl == null ||
                                    _selectedImageUrl!.isEmpty)
                            ? "Upload Image"
                            : "Change Image",
                        fontSize: 12,
                        width: 200,
                      ),
                      Gap(10),
                      CustomTextFormField(controller: _name, labelText: 'Name'),
                      Gap(20),
                      CustomTextFormField(
                        controller: _email,
                        labelText: 'Email',
                      ),
                      Gap(20),
                      CustomTextFormField(
                        controller: _address,
                        labelText: 'Delivary Address',
                      ),
                      Gap(20),

                      Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(),
                      ),
                      Gap(20),
                      CustomTextFormField(
                        textInputType: TextInputType.number,
                        controller: _visa,
                        labelText: visa == "" ? "Add Visa" : 'Edit Visa',
                      ),

                      Gap(20),

                      visa == ""
                          ? SizedBox.shrink()
                          : ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(14),
                              ),
                              tileColor: Colors.white,
                              leading: Image.asset(
                                "assets/profileIcons/image 13.png",
                              ),
                              horizontalTitleGap: 30,
                              title: CustomText(
                                text: "Debit card",
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontsize: 14,
                              ),
                              subtitle: CustomText(
                                text: visa.isNotEmpty
                                    ? _formatVisaNumber(visa)
                                    : "3566 **** **** 0505",
                                color: Colors.black,
                              ),
                              trailing: CustomText(
                                text: "Default",
                                color: Colors.black,
                              ),
                            ),
                      Gap(100),
                    ],
                  ),
                ),
              ),
              bottomSheet: Container(
                height: 70,
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (_selectedImageFile != null) {
                          await context
                              .read<UpdateProfileCubit>()
                              .updateProfile(
                                name: _name.text,
                                email: _email.text,
                                delivaryAddress: _address.text,
                                visa: _visa.text,
                                image: _selectedImageFile,
                              );
                        } else {
                          await context
                              .read<UpdateProfileCubit>()
                              .updateProfile(
                                name: _name.text,
                                email: _email.text,
                                delivaryAddress: _address.text,
                                visa: _visa.text,
                                image: null,
                              );
                        }
                        context.read<ProfileCubit>().getProfile();
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar("Updated Successfully", Colors.white),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
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
                                text: "Edit Profile",
                                color: Colors.white,
                              ),
                              Gap(10),
                              Icon(Icons.edit, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await context.read<LogoutCubit>().logout();
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar(
                            "LOGGED OUT SUCCESSFULLY",
                            Colors.white,
                          ),
                        );
                        PrefHelper.removeToken();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SigninView();
                            },
                          ),
                        );
                      },
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
                              CustomText(text: "Logout", color: Colors.black),
                              Gap(10),
                              Icon(Icons.logout, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) async {
        if (state is Success) {
          profileModel = state.data;
          if (profileModel != null) {
            _name.text = profileModel!.data.name;
            _email.text = profileModel!.data.email;
            _address.text = profileModel!.data.address ?? "none";
            _visa.text = profileModel!.data.visa ?? "";
            visa = _visa.text;
            _selectedImageUrl = profileModel!.data.image?.toString();
            _selectedImageFile = null;
            if (mounted) {
              setState(() {});
            }
          }
        }
      },
    );
  }
}
