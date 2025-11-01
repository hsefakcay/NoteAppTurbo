import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

import '../../product/constants/app_constants.dart';
import '../../product/widgets/index.dart';
import 'bloc/auth_cubit.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isAuthenticated) {
            Navigator.of(context).pushReplacementNamed(AppConstants.routeHome);
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: context.padding.medium,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      Center(
                        child: Container(
                          width: context.sized.dynamicWidth(0.2),
                          height: context.sized.dynamicWidth(0.2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                context.general.colorScheme.primary,
                                context.general.colorScheme.primary.withOpacity(0.7),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.note_alt_outlined,
                            size: context.sized.dynamicWidth(0.1),
                            color: context.general.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      context.sized.emptySizedHeightBoxNormal,

                      // Başlık
                      Text('auth.registerTitle'.tr(), style: theme.textTheme.displayMedium),
                      context.sized.emptySizedHeightBoxLow3x,
                      Text(
                        'auth.register'.tr(),
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: context.general.colorScheme.primary,
                        ),
                      ),
                      context.sized.emptySizedHeightBoxNormal,

                      // Email Field
                      Text('auth.email'.tr(), style: theme.textTheme.titleLarge),
                      context.sized.emptySizedHeightBoxLow,
                      CustomTextField.email(controller: _emailCtrl, hintText: 'auth.emailHint'.tr()),
                      context.sized.emptySizedHeightBoxLow,

                      // Password Field
                      Text('auth.password'.tr(), style: theme.textTheme.titleLarge),
                      context.sized.emptySizedHeightBoxLow,
                      CustomTextField.password(
                        controller: _passwordCtrl,
                        hintText: 'auth.passwordHintMin'.tr(),
                      ),
                      context.sized.emptySizedHeightBoxLow,

                      // Confirm Password Field
                      Text('auth.passwordConfirm'.tr(), style: theme.textTheme.titleLarge),
                      context.sized.emptySizedHeightBoxLow,
                      CustomTextField.password(
                        controller: _confirmPasswordCtrl,
                        hintText: 'auth.passwordConfirmHint'.tr(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'auth.passwordRequired'.tr();
                          }
                          if (value != _passwordCtrl.text) {
                            return 'auth.passwordMismatch'.tr();
                          }
                          return null;
                        },
                      ),
                      context.sized.emptySizedHeightBoxNormal,

                      // Register Button
                      GradientButton(
                        text: 'auth.register'.tr(),
                        isLoading: state.isLoading,
                        onPressed: state.isLoading
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  context.read<AuthCubit>().register(
                                    _emailCtrl.text,
                                    _passwordCtrl.text,
                                  );
                                }
                              },
                      ),
                      context.sized.emptySizedHeightBoxNormal,

                      // Login Link
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text('auth.hasAccount'.tr(), style: theme.textTheme.bodyMedium),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () => Navigator.of(
                                context,
                              ).pushReplacementNamed(AppConstants.routeLogin),
                              child: Text(
                                'auth.login'.tr(),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      context.sized.emptySizedHeightBoxNormal,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
