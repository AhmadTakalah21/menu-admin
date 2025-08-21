import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/profile/cubit/profile_cubit.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import 'package:user_admin/global/widgets/auth_text_field.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_app_bar.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';

abstract class ProfileViewCallbacks {
  Future<void> onRefresh();
  void onTryAgainTap();
  void onNameChanged(String name);
  void onNameSubmitted(String name);
  void onUsernameChanged(String username);
  void onUsernameSubmitted(String username);
  void onPasswordChanged(String password);
  void onPasswordSubmitted(String password);
  void onSaveTap();
  void onIgnoreTap();
}

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return ProfilePage(permissions: permissions, restaurant: restaurant);
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    implements ProfileViewCallbacks {
  late final ProfileCubit profileCubit = context.read();

  final nameFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    profileCubit.getProfile();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  void onIgnoreTap() => Navigator.pop(context);

  @override
  void onNameChanged(String name) => profileCubit.setName(name);

  @override
  void onNameSubmitted(String name) => usernameFocusNode.requestFocus();

  @override
  void onPasswordChanged(String password) => profileCubit.setPassword(password);

  @override
  void onPasswordSubmitted(String password) => passwordFocusNode.unfocus();

  @override
  Future<void> onRefresh() async => profileCubit.getProfile();

  @override
  void onSaveTap() => profileCubit.updateProfile();

  @override
  void onTryAgainTap() => profileCubit.getProfile();

  @override
  void onUsernameChanged(String username) => profileCubit.setUsername(username);

  @override
  void onUsernameSubmitted(String username) => passwordFocusNode.requestFocus();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.restaurant.backgroundColor,
      appBar: MainAppBar(restaurant: widget.restaurant, title: "profile".tr()),
      drawer: MainDrawer(
        permissions: widget.permissions,
        restaurant: widget.restaurant,
      ),
      body: Stack(
        children: [
          if (widget.restaurant.backgroundImageHomePage != null)
            Positioned.fill(
              child: AppImageWidget(
                url: widget.restaurant.backgroundImageHomePage!,
                errorWidget: const SizedBox.shrink(),
              ),
            ),
          RefreshIndicator(
            onRefresh: onRefresh,
            child: SingleChildScrollView(
              child: Padding(
                padding: AppConstants.padding16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildProfileForm(),
                    const SizedBox(height: 30),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return BlocConsumer<ProfileCubit, GeneralProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          profileCubit.setName(state.profile.name);
          profileCubit.setUsername(state.profile.username);
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: LoadingIndicator(color: AppColors.black));
        } else if (state is ProfileSuccess) {
          nameController.text = state.profile.name;
          usernameController.text = state.profile.username;
        }

        return Container(
          padding: AppConstants.padding30,
          decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9).withValues(alpha: 0.6),
              borderRadius: AppConstants.borderRadius50,
              border: Border.all(color: AppColors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(8, 8),
                ),
              ]),
          child: Column(
            children: [
              AuthTextField(
                controller: nameController,
                onChanged: onNameChanged,
                onSubmitted: onNameSubmitted,
                focusNode: nameFocusNode,
                borderColor: widget.restaurant.color,
                title: "name".tr(),
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 10),
              AuthTextField(
                controller: usernameController,
                onChanged: onUsernameChanged,
                onSubmitted: onUsernameSubmitted,
                focusNode: usernameFocusNode,
                borderColor: widget.restaurant.color,
                title: "username".tr(),
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 10),
              AuthTextField(
                obscureText: true,
                controller: passwordController,
                onChanged: onPasswordChanged,
                onSubmitted: onPasswordSubmitted,
                focusNode: passwordFocusNode,
                borderColor: widget.restaurant.color,
                title: "password".tr(),
                prefixIcon: Icons.lock_outline,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Expanded(flex: 4, child: _buildCancelButton()),
        const SizedBox(width: 16),
        Expanded(flex: 4, child: _buildSaveButton()),
        const Spacer(),
      ],
    );
  }

  Widget _buildCancelButton() {
    return MainActionButton(
      padding: AppConstants.paddingV10,
      onPressed: onIgnoreTap,
      borderRadius: AppConstants.borderRadius20,
      buttonColor: AppColors.white,
      textColor: widget.restaurant.color,
      border: Border.all(color: widget.restaurant.color, width: 2),
      text: "cancel".tr(),
    );
  }

  Widget _buildSaveButton() {
    return BlocConsumer<ProfileCubit, GeneralProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileSuccess) {
          passwordController.clear();
          MainSnackBar.showSuccessMessage(context, state.message);
        } else if (state is UpdateProfileFail) {
          MainSnackBar.showErrorMessage(context, state.error);
        }
      },
      builder: (context, state) {
        return MainActionButton(
          padding: AppConstants.paddingV10,
          onPressed: onSaveTap,
          borderRadius: AppConstants.borderRadius20,
          buttonColor: widget.restaurant.color,
          text: "save".tr(),
          isLoading: state is UpdateProfileLoading,
        );
      },
    );
  }
}
