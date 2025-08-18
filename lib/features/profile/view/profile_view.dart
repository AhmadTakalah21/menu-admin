import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/profile/cubit/profile_cubit.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_back_button.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';

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
    final restColor = widget.restaurant.color;
    return Scaffold(
      appBar: AppBar(),
      drawer: MainDrawer(
        permissions: widget.permissions,
        restaurant: widget.restaurant,
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          child: Padding(
            padding: AppConstants.padding16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainBackButton(color: restColor!),
                const SizedBox(height: 20),
                Text(
                  "update_profile".tr(),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 40),
                _buildProfileForm(),
                const SizedBox(height: 30),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
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

        return Column(
          children: [
            MainTextField(
              controller: nameController,
              onChanged: onNameChanged,
              onSubmitted: onNameSubmitted,
              focusNode: nameFocusNode,
              labelText: "name".tr(),
            ),
            const SizedBox(height: 20),
            MainTextField(
              controller: usernameController,
              onChanged: onUsernameChanged,
              onSubmitted: onUsernameSubmitted,
              focusNode: usernameFocusNode,
              labelText: "username".tr(),
            ),
            const SizedBox(height: 20),
            MainTextField(
              controller: passwordController,
              onChanged: onPasswordChanged,
              onSubmitted: onPasswordSubmitted,
              focusNode: passwordFocusNode,
              labelText: "password".tr(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MainActionButton(
          padding: AppConstants.padding14,
          onPressed: onIgnoreTap,
          borderRadius: AppConstants.borderRadius5,
          buttonColor: AppColors.blueShade3,
          text: "ignore".tr(),
          shadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        const SizedBox(width: 8),
        _buildSaveButton(),
        const SizedBox(width: 10),
      ],
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
        var onTap = onSaveTap;
        Widget? child;
        if (state is UpdateProfileLoading) {
          onTap = () {};
          child = const LoadingIndicator(size: 20);
        }

        return MainActionButton(
          padding: AppConstants.padding14,
          onPressed: onTap,
          borderRadius: AppConstants.borderRadius5,
          buttonColor: AppColors.blueShade3,
          text: "save".tr(),
          shadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
          child: child,
        );
      },
    );
  }
}
